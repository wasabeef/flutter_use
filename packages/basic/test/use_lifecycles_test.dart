import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useLifecycles', () {
    testWidgets('should call mount on mount', (tester) async {
      var mountCalled = false;
      var unmountCalled = false;

      await buildHook(
        (_) => useLifecycles(
          mount: () => mountCalled = true,
          unmount: () => unmountCalled = true,
        ),
      );

      expect(mountCalled, true);
      expect(unmountCalled, false);
    });

    testWidgets('should call unmount on unmount', (tester) async {
      var mountCalled = false;
      var unmountCalled = false;

      final result = await buildHook(
        (_) => useLifecycles(
          mount: () => mountCalled = true,
          unmount: () => unmountCalled = true,
        ),
      );

      expect(mountCalled, true);
      expect(unmountCalled, false);

      await result.unmount();
      expect(unmountCalled, true);
    });

    testWidgets('should not call callbacks on rebuild', (tester) async {
      var mountCount = 0;
      var unmountCount = 0;

      final result = await buildHook(
        (_) => useLifecycles(
          mount: () => mountCount++,
          unmount: () => unmountCount++,
        ),
      );

      expect(mountCount, 1);
      expect(unmountCount, 0);

      await result.rebuild();
      expect(mountCount, 1); // Should not increment
      expect(unmountCount, 0);

      await result.rebuild();
      expect(mountCount, 1); // Should still not increment
      expect(unmountCount, 0);
    });

    testWidgets('should handle null mount callback', (tester) async {
      var unmountCalled = false;

      final result = await buildHook(
        (_) => useLifecycles(
          unmount: () => unmountCalled = true,
        ),
      );

      await result.unmount();
      expect(unmountCalled, true);
    });

    testWidgets('should handle null unmount callback', (tester) async {
      var mountCalled = false;

      final result = await buildHook(
        (_) => useLifecycles(
          mount: () => mountCalled = true,
        ),
      );

      expect(mountCalled, true);
      await result.unmount(); // Should not throw
    });

    testWidgets('should handle both null callbacks', (tester) async {
      final result = await buildHook((_) => useLifecycles());
      await result.unmount(); // Should not throw
    });
  });
}
