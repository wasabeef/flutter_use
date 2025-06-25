import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

void main() {
  group('useAsyncFn', () {
    testWidgets('should not execute automatically', (tester) async {
      var callCount = 0;
      late AsyncAction<String> action;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              action = useAsyncFn(() async {
                callCount++;
                return 'result';
              });
              return Container();
            },
          ),
        ),
      );

      // Should not be loading initially
      expect(action.loading, isFalse);
      expect(action.data, isNull);
      expect(action.error, isNull);
      expect(callCount, equals(0));
    });

    testWidgets('should execute when called', (tester) async {
      late AsyncAction<String> action;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              action = useAsyncFn(() async {
                await Future<void>.delayed(const Duration(milliseconds: 10));
                return 'success';
              });
              return TextButton(
                onPressed: () async {
                  await action.execute();
                },
                child: const Text('Execute'),
              );
            },
          ),
        ),
      );

      // Execute
      await tester.tap(find.text('Execute'));
      await tester.pump();

      // Should be loading
      expect(action.loading, isTrue);

      // Wait for completion
      await tester.pump(const Duration(milliseconds: 20));

      // Should have data
      expect(action.loading, isFalse);
      expect(action.data, equals('success'));
      expect(action.error, isNull);
      expect(action.hasData, isTrue);
      expect(action.hasError, isFalse);
    });

    testWidgets('should handle errors', (tester) async {
      late AsyncAction<String> action;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              action = useAsyncFn(() async {
                await Future<void>.delayed(const Duration(milliseconds: 10));
                throw Exception('error');
              });
              return TextButton(
                onPressed: () async {
                  try {
                    await action.execute();
                  } on Object {
                    // Expected error
                  }
                },
                child: const Text('Execute'),
              );
            },
          ),
        ),
      );

      // Execute and expect error
      await tester.tap(find.text('Execute'));
      await tester.pump();

      // Wait a bit for state to update
      await tester.pump(const Duration(milliseconds: 20));

      // Should have error state
      expect(action.loading, isFalse);
      expect(action.data, isNull);
      expect(action.error, isNotNull);
      expect(action.hasData, isFalse);
      expect(action.hasError, isTrue);
    });

    testWidgets('should handle multiple calls', (tester) async {
      var counter = 0;
      late AsyncAction<int> action;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              action = useAsyncFn(() async {
                counter++;
                await Future<void>.delayed(const Duration(milliseconds: 10));
                return counter;
              });
              return TextButton(
                onPressed: () async {
                  await action.execute();
                },
                child: const Text('Execute'),
              );
            },
          ),
        ),
      );

      // First call
      await tester.tap(find.text('Execute'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(action.data, equals(1));

      // Second call
      await tester.tap(find.text('Execute'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(action.data, equals(2));
    });

    testWidgets('should preserve previous data during new execution',
        (tester) async {
      late AsyncAction<String> action;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              action = useAsyncFn(() async {
                await Future<void>.delayed(const Duration(milliseconds: 10));
                return 'new data';
              });
              return TextButton(
                onPressed: () async {
                  await action.execute();
                },
                child: const Text('Execute'),
              );
            },
          ),
        ),
      );

      // First execution
      await tester.tap(find.text('Execute'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(action.data, equals('new data'));

      // Start second execution but don't wait for completion
      await tester.tap(find.text('Execute'));
      await tester.pump();

      // During loading, should still have previous data
      expect(action.loading, isTrue);
      expect(action.data, equals('new data')); // Previous data preserved
      expect(action.error, isNull); // Error cleared

      // Wait for completion to clean up timers
      await tester.pump(const Duration(milliseconds: 20));
    });

    testWidgets('should clear error on new execution', (tester) async {
      var shouldThrow = true;
      late AsyncAction<String> action;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              action = useAsyncFn(() async {
                await Future<void>.delayed(const Duration(milliseconds: 10));
                if (shouldThrow) {
                  throw Exception('error');
                }
                return 'success';
              });
              return TextButton(
                onPressed: () async {
                  try {
                    await action.execute();
                  } on Object {
                    // Handle error
                  }
                },
                child: const Text('Execute'),
              );
            },
          ),
        ),
      );

      // First execution - should fail
      await tester.tap(find.text('Execute'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(action.error, isNotNull);

      // Change to success case
      shouldThrow = false;

      // Second execution - should succeed and clear error
      await tester.tap(find.text('Execute'));
      await tester.pump();

      // Error should be cleared immediately when new execution starts
      expect(action.loading, isTrue);
      expect(action.error, isNull);

      await tester.pump(const Duration(milliseconds: 20));
      expect(action.data, equals('success'));
      expect(action.error, isNull);
    });

    testWidgets('should handle nullable return types', (tester) async {
      late AsyncAction<String?> action;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              action = useAsyncFn(() async {
                await Future<void>.delayed(const Duration(milliseconds: 10));
                return null;
              });
              return TextButton(
                onPressed: () async {
                  await action.execute();
                },
                child: const Text('Execute'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Execute'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));

      expect(action.loading, isFalse);
      expect(action.data, isNull);
      expect(action.error, isNull);
      expect(action.hasData, isFalse); // null data counts as no data
      expect(action.hasError, isFalse);
    });
  });

  group('AsyncAction', () {
    test('hasData should return false for null data', () {
      const action = AsyncAction<String>(
        loading: false,
        data: null,
        error: null,
        execute: _dummyExecute,
      );

      expect(action.hasData, isFalse);
      expect(action.hasError, isFalse);
    });

    test('hasData should return true for non-null data with no error', () {
      const action = AsyncAction<String>(
        loading: false,
        data: 'test',
        error: null,
        execute: _dummyExecute,
      );

      expect(action.hasData, isTrue);
      expect(action.hasError, isFalse);
    });

    test('hasError should return true when error is present', () {
      const action = AsyncAction<String>(
        loading: false,
        data: null,
        error: 'error',
        execute: _dummyExecute,
      );

      expect(action.hasData, isFalse);
      expect(action.hasError, isTrue);
    });

    test('hasData should return false when both data and error are present',
        () {
      const action = AsyncAction<String>(
        loading: false,
        data: 'test',
        error: 'error',
        execute: _dummyExecute,
      );

      expect(action.hasData, isFalse);
      expect(action.hasError, isTrue);
    });
  });

  group('AsyncState', () {
    test('initial constructor creates correct state', () {
      const state = AsyncState<String>.initial();

      expect(state.loading, isFalse);
      expect(state.data, isNull);
      expect(state.error, isNull);
      expect(state.hasData, isFalse);
      expect(state.hasError, isFalse);
    });

    test('loading constructor creates correct state', () {
      const state = AsyncState<String>.loading();

      expect(state.loading, isTrue);
      expect(state.data, isNull);
      expect(state.error, isNull);
      expect(state.hasData, isFalse);
      expect(state.hasError, isFalse);
    });

    test('hasData should work correctly with different states', () {
      const successState = AsyncState<String>(
        loading: false,
        data: 'test',
        error: null,
      );

      const errorState = AsyncState<String>(
        loading: false,
        data: null,
        error: 'error',
      );

      const bothState = AsyncState<String>(
        loading: false,
        data: 'test',
        error: 'error',
      );

      expect(successState.hasData, isTrue);
      expect(successState.hasError, isFalse);

      expect(errorState.hasData, isFalse);
      expect(errorState.hasError, isTrue);

      expect(bothState.hasData, isFalse);
      expect(bothState.hasError, isTrue);
    });
  });
}

Future<String> _dummyExecute() async => 'dummy';
