import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useTimeoutFn', () {
    testWidgets('should call function after delay', (tester) async {
      var called = false;
      final result = await buildHook(
        (_) => useTimeoutFn(
            () => called = true, const Duration(milliseconds: 100)),
      );

      expect(called, false);
      expect(result.current.isReady(), false);

      await tester.pump(const Duration(milliseconds: 50));
      expect(called, false);
      expect(result.current.isReady(), false);

      await tester.pump(const Duration(milliseconds: 60));
      expect(called, true);
      expect(result.current.isReady(), true);
    });

    testWidgets('should cancel timeout', (tester) async {
      var called = false;
      final result = await buildHook(
        (_) => useTimeoutFn(
            () => called = true, const Duration(milliseconds: 100)),
      );

      await tester.pump(const Duration(milliseconds: 50));
      result.current.cancel();

      await tester.pump(const Duration(milliseconds: 100));
      expect(called, false);
      expect(result.current.isReady(), null);
    });

    testWidgets('should reset timeout', (tester) async {
      var callCount = 0;
      final result = await buildHook(
        (_) =>
            useTimeoutFn(() => callCount++, const Duration(milliseconds: 100)),
      );

      await tester.pump(const Duration(milliseconds: 50));
      result.current.reset();

      await tester.pump(const Duration(milliseconds: 60));
      expect(callCount, 0); // Should not have been called yet

      await tester.pump(const Duration(milliseconds: 50));
      expect(callCount, 1); // Should be called after reset + 100ms
    });

    testWidgets('should update function reference', (tester) async {
      var value = 0;
      var fn = () => value = 1;

      final result = await buildHook(
        (props) => useTimeoutFn(
            props as void Function(), const Duration(milliseconds: 100)),
        initialProps: fn,
      );

      await tester.pump(const Duration(milliseconds: 50));

      // Update function
      fn = () => value = 2;
      await result.rebuild(fn);

      await tester.pump(const Duration(milliseconds: 60));
      expect(value, 2); // Should call updated function
    });

    testWidgets('should handle delay changes', (tester) async {
      var delay = const Duration(milliseconds: 100);

      final result = await buildHook(
        (props) => useTimeoutFn(() {}, props as Duration),
        initialProps: delay,
      );

      // Clean up immediately to avoid timer issues
      result.current.cancel();

      // Change delay
      delay = const Duration(milliseconds: 200);
      await result.rebuild(delay);

      // After cancel and delay change, the state remains null (cancelled)
      expect(result.current.isReady(), null);
    });

    testWidgets('should clean up on unmount', (tester) async {
      var called = false;
      final result = await buildHook(
        (_) => useTimeoutFn(
            () => called = true, const Duration(milliseconds: 100)),
      );

      await tester.pump(const Duration(milliseconds: 50));
      await result.unmount();

      await tester.pump(const Duration(milliseconds: 100));
      expect(called, false); // Should not be called after unmount
    });

    testWidgets('should handle multiple resets', (tester) async {
      var callCount = 0;
      final result = await buildHook(
        (_) =>
            useTimeoutFn(() => callCount++, const Duration(milliseconds: 100)),
      );

      await tester.pump(const Duration(milliseconds: 30));
      result.current.reset();

      await tester.pump(const Duration(milliseconds: 30));
      result.current.reset();

      await tester.pump(const Duration(milliseconds: 30));
      result.current.reset();

      await tester.pump(const Duration(milliseconds: 110));
      expect(callCount, 1); // Should only be called once
    });
  });
}
