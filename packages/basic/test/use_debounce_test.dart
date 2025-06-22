import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useDebounce', () {
    testWidgets('should call function after delay', (tester) async {
      var called = false;
      await buildHook(
        (_) => useDebounce(
          () => called = true,
          const Duration(milliseconds: 100),
        ),
      );

      expect(called, false);
      await tester.pump(const Duration(milliseconds: 50));
      expect(called, false);
      await tester.pump(const Duration(milliseconds: 60));
      expect(called, true);
    });

    testWidgets('should reset timer when keys change', (tester) async {
      var called = false;
      var key = 0;

      final result = await buildHook(
        (props) => useDebounce(
          () => called = true,
          const Duration(milliseconds: 100),
          [props],
        ),
        initialProps: key,
      );

      expect(called, false);
      await tester.pump(const Duration(milliseconds: 50));
      expect(called, false);

      // Change key to reset timer
      key = 1;
      await result.rebuild(key);

      await tester.pump(const Duration(milliseconds: 60));
      expect(called, false); // Should not be called yet

      await tester.pump(const Duration(milliseconds: 50));
      expect(
        called,
        true,
      ); // Should be called after total 110ms from key change
    });

    testWidgets('should cancel on unmount', (tester) async {
      var called = false;
      final result = await buildHook(
        (_) => useDebounce(
          () => called = true,
          const Duration(milliseconds: 100),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      await result.unmount();
      await tester.pump(const Duration(milliseconds: 60));
      expect(called, false); // Should not be called after unmount
    });
  });
}
