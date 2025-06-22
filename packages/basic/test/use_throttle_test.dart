import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useThrottle', () {
    testWidgets('should return initial value immediately', (tester) async {
      final result = await buildHook(
        (_) => useThrottle('initial', const Duration(milliseconds: 100)),
      );

      expect(result.current, 'initial');
    });

    testWidgets('should update immediately on first change', (tester) async {
      const duration = Duration(milliseconds: 100);

      final result = await buildHook(
        (value) => useThrottle(value as String, duration),
        initialProps: 'initial',
      );

      expect(result.current, 'initial');

      // First update should be immediate
      await result.rebuild('updated');
      // Wait a bit for the effect to process
      await tester.pump();
      expect(result.current, 'updated');
    });

    testWidgets('should throttle rapid updates', (tester) async {
      const duration = Duration(milliseconds: 100);

      final result = await buildHook(
        (value) => useThrottle(value as String, duration),
        initialProps: 'initial',
      );

      expect(result.current, 'initial');

      // First update is immediate
      await result.rebuild('update1');
      expect(result.current, 'update1');

      // Rapid updates should be throttled
      await result.rebuild('update2');
      expect(result.current, 'update1'); // Still the first update

      await result.rebuild('update3');
      expect(result.current, 'update1'); // Still the first update

      // Wait for throttle duration to allow the timer to fire
      await tester.pump(duration + const Duration(milliseconds: 10));
      expect(result.current, 'update3'); // Now shows the latest value
    });

    testWidgets('should handle multiple throttle cycles', (tester) async {
      const duration = Duration(milliseconds: 50);

      final result = await buildHook(
        (value) => useThrottle(value as int, duration),
        initialProps: 0,
      );

      expect(result.current, 0);

      // First cycle
      await result.rebuild(1);
      expect(result.current, 1);

      await result.rebuild(2);
      expect(result.current, 1); // Throttled

      await tester.pump(duration + const Duration(milliseconds: 10));
      expect(result.current, 2);

      // Second cycle - after enough time has passed, next update should be immediate
      await result.rebuild(3);
      expect(result.current, 3); // Immediate again

      await result.rebuild(4);
      expect(result.current, 3); // Throttled

      await tester.pump(duration + const Duration(milliseconds: 10));
      expect(result.current, 4);
    });

    testWidgets('should clean up timer on unmount', (tester) async {
      const duration = Duration(milliseconds: 100);

      final result = await buildHook(
        (value) => useThrottle(value as String, duration),
        initialProps: 'initial',
      );

      await result.rebuild('update1');
      await result.rebuild('update2');

      // Unmount before throttle completes
      await result.unmount();

      // Should not throw after unmount
      await tester.pump(duration);
    });
  });
}
