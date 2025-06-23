import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useScrolling', () {
    testWidgets('should return initial scrolling state', (tester) async {
      final result = await buildHook((_) => useScrolling());

      expect(result.current.isScrolling, false);
      expect(result.current.controller, isA<ScrollController>());
    });

    testWidgets('should provide stable controller across rebuilds',
        (tester) async {
      final result = await buildHook((_) => useScrolling());

      final firstController = result.current.controller;

      await result.rebuild();

      expect(identical(firstController, result.current.controller), isTrue);
    });

    testWidgets('should detect scrolling activity', (tester) async {
      late ScrollingState scrollingState;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              scrollingState = useScrolling();

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: scrollingState.controller,
                  itemCount: 100,
                  itemBuilder: (context, index) => SizedBox(
                    height: 50,
                    child: Text('Item $index'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initially not scrolling
      expect(scrollingState.isScrolling, false);

      // Simulate scroll event by actually scrolling the ListView
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pump();

      expect(scrollingState.isScrolling, true);

      // Wait for timeout (default 150ms)
      await tester.pump(const Duration(milliseconds: 200));

      expect(scrollingState.isScrolling, false);
    });

    testWidgets('should reset timeout on continued scrolling', (tester) async {
      late ScrollingState scrollingState;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              scrollingState = useScrolling(const Duration(milliseconds: 100));

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: scrollingState.controller,
                  itemCount: 100,
                  itemBuilder: (context, index) => SizedBox(
                    height: 50,
                    child: Text('Item $index'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // First scroll
      await tester.drag(find.byType(ListView), const Offset(0, -50));
      await tester.pump();
      expect(scrollingState.isScrolling, true);

      // Wait 50ms (less than timeout)
      await tester.pump(const Duration(milliseconds: 50));

      // Second scroll resets the timer
      await tester.drag(find.byType(ListView), const Offset(0, -50));
      await tester.pump();
      expect(scrollingState.isScrolling, true);

      // Wait another 50ms (total 100ms from first scroll, 50ms from second)
      await tester.pump(const Duration(milliseconds: 50));
      expect(scrollingState.isScrolling, true); // Should still be scrolling

      // Wait the full timeout from second scroll
      await tester.pump(const Duration(milliseconds: 60));
      expect(scrollingState.isScrolling, false);
    });

    testWidgets('should handle custom timeout duration', (tester) async {
      const customTimeout = Duration(milliseconds: 300);
      late ScrollingState scrollingState;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              scrollingState = useScrolling(customTimeout);

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: scrollingState.controller,
                  itemCount: 100,
                  itemBuilder: (context, index) => SizedBox(
                    height: 50,
                    child: Text('Item $index'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Trigger scroll
      await tester.drag(find.byType(ListView), const Offset(0, -50));
      await tester.pump();
      expect(scrollingState.isScrolling, true);

      // Wait less than custom timeout
      await tester.pump(const Duration(milliseconds: 200));
      expect(scrollingState.isScrolling, true);

      // Wait past custom timeout
      await tester.pump(const Duration(milliseconds: 150));
      expect(scrollingState.isScrolling, false);
    });

    testWidgets('should clean up timer on unmount', (tester) async {
      var showWidget = true;
      late ScrollingState scrollingState;

      Widget buildTestWidget() => StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: showWidget
                  ? HookBuilder(
                      builder: (context) {
                        scrollingState = useScrolling();

                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            controller: scrollingState.controller,
                            itemCount: 100,
                            itemBuilder: (context, index) => SizedBox(
                              height: 50,
                              child: Text('Item $index'),
                            ),
                          ),
                        );
                      },
                    )
                  : const Text('Unmounted'),
            ),
          );

      await tester.pumpWidget(buildTestWidget());

      // Trigger scroll
      await tester.drag(find.byType(ListView), const Offset(0, -50));
      await tester.pump();
      expect(scrollingState.isScrolling, true);

      // Unmount the hook by changing the widget
      showWidget = false;
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should not throw after unmount
      await tester.pump(const Duration(milliseconds: 200));
    });
  });
}
