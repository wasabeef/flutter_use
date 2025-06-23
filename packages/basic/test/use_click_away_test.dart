import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  group('useClickAway', () {
    testWidgets('should return a global key', (tester) async {
      GlobalKey? capturedKey;

      await tester.pumpWidget(
        HookBuilder(
          builder: (context) {
            final clickAway = useClickAway(() {});
            capturedKey = clickAway.ref;
            return Container();
          },
        ),
      );

      expect(capturedKey, isA<GlobalKey>());
    });

    testWidgets('should provide stable key across rebuilds', (tester) async {
      final keys = <GlobalKey>[];
      var counter = 0;

      Widget buildTestWidget() => StatefulBuilder(
            builder: (context, setState) => HookBuilder(
              builder: (context) {
                final clickAway = useClickAway(() {});
                if (keys.length <= counter) {
                  keys.add(clickAway.ref);
                }
                return ElevatedButton(
                  onPressed: () {
                    counter++;
                    setState(() {});
                  },
                  child: const Text('Rebuild'),
                );
              },
            ),
          );

      await tester.pumpWidget(MaterialApp(home: buildTestWidget()));

      // Trigger rebuild
      await tester.tap(find.text('Rebuild'));
      await tester.pump();

      expect(keys.length, greaterThanOrEqualTo(2));
      expect(identical(keys[0], keys[1]), isTrue);
    });

    testWidgets('should call callback when clicking outside', (tester) async {
      var callbackCalled = false;
      late GlobalKey targetKey;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final clickAway = useClickAway(() {
                callbackCalled = true;
              });
              targetKey = clickAway.ref;

              return Scaffold(
                body: Column(
                  children: [
                    Container(
                      key: targetKey,
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      child: const Text('Target'),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: const Text('Outside'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(callbackCalled, false);

      // Tap outside the target widget (on the blue container)
      await tester.tap(find.text('Outside'));
      await tester.pump();

      expect(callbackCalled, true);
    });

    testWidgets('should not call callback when clicking inside',
        (tester) async {
      var callbackCalled = false;
      late GlobalKey targetKey;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final clickAway = useClickAway(() {
                callbackCalled = true;
              });
              targetKey = clickAway.ref;

              return Scaffold(
                body: Column(
                  children: [
                    Container(
                      key: targetKey,
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      child: const Text('Target'),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: const Text('Outside'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(callbackCalled, false);

      // Tap inside the target widget
      await tester.tap(find.text('Target'));
      await tester.pump();

      expect(callbackCalled, false);
    });

    testWidgets('should update callback when it changes', (tester) async {
      var callbackValue = 'initial';
      late GlobalKey targetKey;

      Widget buildTestWidget() => StatefulBuilder(
            builder: (context, setState) => HookBuilder(
              builder: (context) {
                final clickAway = useClickAway(() {
                  callbackValue = 'changed';
                });
                targetKey = clickAway.ref;

                return Scaffold(
                  body: Column(
                    children: [
                      Container(
                        key: targetKey,
                        width: 100,
                        height: 100,
                        color: Colors.red,
                        child: const Text('Target'),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                        child: const Text('Outside'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text('Rebuild'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );

      await tester.pumpWidget(MaterialApp(home: buildTestWidget()));

      // Trigger rebuild to ensure callback is properly updated
      await tester.tap(find.text('Rebuild'));
      await tester.pump();

      // Tap outside
      await tester.tap(find.text('Outside'));
      await tester.pump();

      expect(callbackValue, 'changed');
    });

    testWidgets('should handle widget without render box', (tester) async {
      var callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              useClickAway(() {
                callbackCalled = true;
              });
              // Don't use the key since we're testing when widget doesn't exist

              // Don't render the widget with the target key
              return Scaffold(
                body: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: const Text('Outside'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Should not crash when tapping outside
      await tester.tap(find.text('Outside'));
      await tester.pump();

      // Callback should not be called since the target widget doesn't exist
      expect(callbackCalled, false);
    });

    testWidgets('should clean up listeners on unmount', (tester) async {
      var showWidget = true;
      late GlobalKey targetKey;

      Widget buildTestWidget() => StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: showWidget
                  ? HookBuilder(
                      builder: (context) {
                        final clickAway = useClickAway(() {});
                        targetKey = clickAway.ref;

                        return Scaffold(
                          body: Column(
                            children: [
                              Container(
                                key: targetKey,
                                width: 100,
                                height: 100,
                                color: Colors.red,
                                child: const Text('Target'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showWidget = false;
                                  setState(() {});
                                },
                                child: const Text('Unmount'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Scaffold(
                      body: Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                        child: const Text('After Unmount'),
                      ),
                    ),
            ),
          );

      await tester.pumpWidget(buildTestWidget());

      // Unmount the hook
      await tester.tap(find.text('Unmount'));
      await tester.pump();

      // Should not crash after unmount
      await tester.tap(find.text('After Unmount'), warnIfMissed: false);
      await tester.pump();
    });
  });
}
