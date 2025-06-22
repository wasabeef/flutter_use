import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useTimeout', () {
    testWidgets('should return pending state initially', (tester) async {
      final result = await buildHook(
        (_) => useTimeout(const Duration(milliseconds: 100)),
      );

      expect(result.current.isReady(), false);
    });

    testWidgets('should rebuild after timeout', (tester) async {
      var buildCount = 0;
      final result = await buildHook((_) {
        buildCount++;
        return useTimeout(const Duration(milliseconds: 100));
      });

      expect(buildCount, 1);
      expect(result.current.isReady(), false);

      await tester.pump(const Duration(milliseconds: 50));
      expect(buildCount, 1);
      expect(result.current.isReady(), false);

      await tester.pump(const Duration(milliseconds: 60));
      expect(buildCount, 2);
      expect(result.current.isReady(), true);
    });

    testWidgets('should cancel timeout', (tester) async {
      var buildCount = 0;
      final result = await buildHook((_) {
        buildCount++;
        return useTimeout(const Duration(milliseconds: 100));
      });

      expect(buildCount, 1);

      await act(() => result.current.cancel());

      await tester.pump(const Duration(milliseconds: 150));
      expect(buildCount, 1); // Should not rebuild
      expect(result.current.isReady(), null); // null indicates cancelled
    });

    testWidgets('should reset timeout', (tester) async {
      var buildCount = 0;
      final result = await buildHook((_) {
        buildCount++;
        return useTimeout(const Duration(milliseconds: 100));
      });

      expect(buildCount, 1);

      await tester.pump(const Duration(milliseconds: 50));
      await act(() => result.current.reset());

      await tester.pump(const Duration(milliseconds: 60));
      expect(buildCount, 1); // Should not have rebuilt yet

      await tester.pump(const Duration(milliseconds: 50));
      expect(buildCount, 2); // Should rebuild after reset + 100ms
    });

    testWidgets('should clean up on unmount', (tester) async {
      var buildCount = 0;
      final result = await buildHook((_) {
        buildCount++;
        return useTimeout(const Duration(milliseconds: 100));
      });

      await result.unmount();

      await tester.pump(const Duration(milliseconds: 150));
      expect(buildCount, 1); // Should not rebuild after unmount
    });
  });
}
