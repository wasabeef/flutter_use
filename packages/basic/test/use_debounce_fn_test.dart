import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

void main() {
  group('useDebounceFn', () {
    testWidgets('should debounce function calls', (tester) async {
      var callCount = 0;
      late DebouncedFunction<void> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn(
                () {
                  callCount++;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call multiple times rapidly
      debouncedFn.call();
      debouncedFn.call();
      debouncedFn.call();

      // Should not have been called yet
      expect(callCount, equals(0));

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 60));

      // Should have been called once
      expect(callCount, equals(1));
    });

    testWidgets('should cancel pending calls', (tester) async {
      var callCount = 0;
      late DebouncedFunction<void> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn(
                () {
                  callCount++;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call and then cancel
      debouncedFn.call();
      debouncedFn.cancel();

      // Wait for what would have been the debounce
      await tester.pump(const Duration(milliseconds: 60));

      // Should not have been called
      expect(callCount, equals(0));
    });

    testWidgets('should flush pending calls', (tester) async {
      var callCount = 0;
      late DebouncedFunction<void> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn(
                () {
                  callCount++;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call and then flush
      debouncedFn.call();
      debouncedFn.flush();

      // Should have been called immediately
      expect(callCount, equals(1));
    });

    testWidgets('should track pending state', (tester) async {
      late DebouncedFunction<void> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn(() {}, 50);
              return Container();
            },
          ),
        ),
      );

      // Initially no pending calls
      expect(debouncedFn.isPending(), isFalse);

      // Call function
      debouncedFn.call();
      expect(debouncedFn.isPending(), isTrue);

      // Cancel
      debouncedFn.cancel();
      expect(debouncedFn.isPending(), isFalse);
    });

    testWidgets('should pass arguments correctly', (tester) async {
      String? receivedArg;
      late DebouncedFunction1<String> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn1<String>(
                (arg) {
                  receivedArg = arg;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call with argument
      debouncedFn.call('test');

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 60));

      // Should have received the argument
      expect(receivedArg, equals('test'));
    });

    testWidgets('should use the latest arguments', (tester) async {
      String? receivedArg;
      late DebouncedFunction1<String> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn1<String>(
                (arg) {
                  receivedArg = arg;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call multiple times with different arguments
      debouncedFn.call('first');
      debouncedFn.call('second');
      debouncedFn.call('third');

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 60));

      // Should have received the last argument
      expect(receivedArg, equals('third'));
    });

    testWidgets('should respect delay changes', (tester) async {
      var callCount = 0;
      late DebouncedFunction<void> debouncedFn;
      var delay = 50;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => HookBuilder(
              builder: (context) {
                debouncedFn = useDebounceFn(
                  () {
                    callCount++;
                  },
                  delay,
                );
                return TextButton(
                  onPressed: () {
                    setState(() {
                      delay = 20;
                    });
                  },
                  child: const Text('Change delay'),
                );
              },
            ),
          ),
        ),
      );

      // Call with initial delay (50ms)
      debouncedFn.call();

      // Wait less than initial delay
      await tester.pump(const Duration(milliseconds: 30));

      // Should not have been called yet
      expect(callCount, equals(0));

      // Wait for the rest of the delay
      await tester.pump(const Duration(milliseconds: 30));

      // Should have been called once
      expect(callCount, equals(1));

      // Change delay (shorter)
      await tester.tap(find.text('Change delay'));
      await tester.pump();

      // Call again with new delay
      debouncedFn.call();

      // Wait for new shorter delay
      await tester.pump(const Duration(milliseconds: 30));

      // Should have been called again
      expect(callCount, equals(2));
    });

    testWidgets('should cleanup on unmount', (tester) async {
      var callCount = 0;
      late DebouncedFunction<void> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn(
                () {
                  callCount++;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call function
      debouncedFn.call();

      // Unmount before debounce completes
      await tester.pumpWidget(Container());

      // Wait for what would have been the debounce
      await tester.pump(const Duration(milliseconds: 60));

      // Should not have been called
      expect(callCount, equals(0));
    });
  });

  group('useDebounceFn1', () {
    testWidgets('should provide type-safe single argument debouncing',
        (tester) async {
      int? receivedValue;
      late DebouncedFunction1<int> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn1<int>(
                (value) {
                  receivedValue = value;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call with typed argument
      debouncedFn.call(42);

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 60));

      // Should have received the typed value
      expect(receivedValue, equals(42));
    });

    testWidgets('should handle null arguments properly', (tester) async {
      int? receivedValue;
      var wasCalled = false;
      late DebouncedFunction1<int?> debouncedFn;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              debouncedFn = useDebounceFn1<int?>(
                (value) {
                  wasCalled = true;
                  receivedValue = value;
                },
                50,
              );
              return Container();
            },
          ),
        ),
      );

      // Call with null
      debouncedFn.call(null);

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 60));

      // Should have been called with null
      expect(wasCalled, isTrue);
      expect(receivedValue, isNull);
    });
  });
}
