import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

void main() {
  group('useAsync', () {
    testWidgets('should handle successful async operation', (tester) async {
      late AsyncState<String> state;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              state = useAsync(() async {
                await Future<void>.delayed(const Duration(milliseconds: 10));
                return 'success';
              });
              return Container();
            },
          ),
        ),
      );

      // Initially loading
      expect(state.loading, isTrue);
      expect(state.data, isNull);
      expect(state.error, isNull);

      // Wait for completion
      await tester.pump(const Duration(milliseconds: 20));

      // Should have data
      expect(state.loading, isFalse);
      expect(state.data, equals('success'));
      expect(state.error, isNull);
      expect(state.hasData, isTrue);
      expect(state.hasError, isFalse);
    });

    testWidgets('should handle failed async operation', (tester) async {
      late AsyncState<String> state;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              state = useAsync(() async {
                await Future<void>.delayed(const Duration(milliseconds: 10));
                throw Exception('error');
              });
              return Container();
            },
          ),
        ),
      );

      // Initially loading
      expect(state.loading, isTrue);
      expect(state.data, isNull);
      expect(state.error, isNull);

      // Wait for completion
      await tester.pump(const Duration(milliseconds: 20));

      // Should have error
      expect(state.loading, isFalse);
      expect(state.data, isNull);
      expect(state.error, isNotNull);
      expect(state.hasData, isFalse);
      expect(state.hasError, isTrue);
    });

    testWidgets('should re-execute when keys change', (tester) async {
      var counter = 0;
      late AsyncState<int> state;
      var key = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => HookBuilder(
              builder: (context) {
                state = useAsync(
                  () async {
                    counter++;
                    await Future<void>.delayed(
                      const Duration(milliseconds: 10),
                    );
                    return counter;
                  },
                  keys: [key],
                );
                return TextButton(
                  onPressed: () {
                    setState(() {
                      key = 2;
                    });
                  },
                  child: const Text('Change key'),
                );
              },
            ),
          ),
        ),
      );

      // Wait for first execution
      await tester.pump(const Duration(milliseconds: 20));
      expect(state.data, equals(1));

      // Change key
      await tester.tap(find.text('Change key'));
      await tester.pump();

      // Wait for second execution
      await tester.pump(const Duration(milliseconds: 20));
      expect(state.data, equals(2));
    });

    testWidgets('should cancel previous operation when keys change',
        (tester) async {
      var executionCount = 0;
      late AsyncState<int> state;
      var key = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => HookBuilder(
              builder: (context) {
                state = useAsync(
                  () async {
                    final currentExecution = ++executionCount;
                    await Future<void>.delayed(
                      const Duration(milliseconds: 50),
                    );
                    return currentExecution;
                  },
                  keys: [key],
                );
                return TextButton(
                  onPressed: () {
                    setState(() {
                      key = 2;
                    });
                  },
                  child: const Text('Change key'),
                );
              },
            ),
          ),
        ),
      );

      // Start first operation
      expect(state.loading, isTrue);

      // Change key before first operation completes
      await tester.pump(const Duration(milliseconds: 10));
      await tester.tap(find.text('Change key'));
      await tester.pump();

      // Wait for second operation to complete
      await tester.pump(const Duration(milliseconds: 60));

      // Both operations executed, but only the second one's result should be in state
      expect(executionCount, equals(2));
      expect(state.data, equals(2));
    });
  });
}
