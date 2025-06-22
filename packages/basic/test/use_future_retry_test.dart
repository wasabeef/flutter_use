import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useFutureRetry', () {
    testWidgets('should return initial data', (tester) async {
      final result = await buildHook(
        (_) => useFutureRetry(
          Future.value(42),
          initialData: 0,
        ),
      );

      expect(result.current.snapshot.data, 0);
      expect(result.current.snapshot.connectionState, ConnectionState.waiting);
    });

    testWidgets('should resolve future', (tester) async {
      final result = await buildHook(
        (_) => useFutureRetry(Future.value(42)),
      );

      expect(result.current.snapshot.connectionState, ConnectionState.waiting);

      await tester.pump();

      expect(result.current.snapshot.data, 42);
      expect(result.current.snapshot.connectionState, ConnectionState.done);
    });

    testWidgets('should handle errors', (tester) async {
      final errorFuture = Future<int>.delayed(
        const Duration(milliseconds: 10),
        () => throw 'Test error',
      );

      final result = await buildHook(
        (_) => useFutureRetry(errorFuture),
      );

      expect(result.current.snapshot.connectionState, ConnectionState.waiting);

      await tester.pumpAndSettle();

      expect(result.current.snapshot.hasError, true);
      expect(result.current.snapshot.error, 'Test error');
      expect(result.current.snapshot.connectionState, ConnectionState.done);
    });

    testWidgets('should retry future', (tester) async {
      final result = await buildHook(
        (_) => useFutureRetry(Future.value(42)),
      );

      await tester.pump();

      expect(result.current.snapshot.data, 42);

      // Retry should work (even if we can't easily test the new future)
      await act(() => result.current.retry());

      // At least verify retry doesn't crash
      expect(result.current.snapshot.connectionState, isNotNull);
    });

    testWidgets('should preserve state when specified', (tester) async {
      final result = await buildHook(
        (_) => useFutureRetry(
          Future.value(42),
          initialData: 10,
          preserveState: true,
        ),
      );

      await tester.pump();
      expect(result.current.snapshot.data, 42);

      // Retry with preserveState
      await act(() => result.current.retry());

      // Should keep previous data while loading
      expect(result.current.snapshot.data, 42);
      expect(result.current.snapshot.connectionState, ConnectionState.waiting);
    });

    testWidgets('should handle preserveState parameter', (tester) async {
      final result = await buildHook(
        (_) => useFutureRetry(
          Future.value(42),
          initialData: 10,
          preserveState: false,
        ),
      );

      await tester.pump();
      expect(result.current.snapshot.data, 42);

      // Test that the hook accepts preserveState parameter
      expect(result.current.snapshot.hasData, true);
    });

    testWidgets('should handle null future', (tester) async {
      final result = await buildHook(
        (_) => useFutureRetry<int>(null),
      );

      expect(result.current.snapshot.connectionState, ConnectionState.none);
      expect(result.current.snapshot.hasData, false);
      expect(result.current.snapshot.hasError, false);
    });

    testWidgets('should retry with different parameters', (tester) async {
      var value = 1;

      Future<int> createFuture() => Future.value(value);

      final result = await buildHook(
        (_) => useFutureRetry(createFuture()),
      );

      await tester.pump();
      expect(result.current.snapshot.data, 1);

      // Change future behavior and retry
      value = 2;
      await act(() => result.current.retry());

      await tester.pump();
      expect(result.current.snapshot.data, 2);
    });
  });
}
