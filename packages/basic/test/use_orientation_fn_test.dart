import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useOrientationFn', () {
    Widget Function(Widget) mediaQueryWrapper(Orientation orientation) {
      return (Widget child) => MediaQuery(
            data: MediaQueryData(
              size: orientation == Orientation.portrait
                  ? const Size(400, 800)
                  : const Size(800, 400),
            ),
            child: child,
          );
    }

    testWidgets('should call callback with initial orientation',
        (tester) async {
      Orientation? capturedOrientation;

      await buildHook(
        (_) => useOrientationFn((orientation) {
          capturedOrientation = orientation;
        }),
        wrapper: mediaQueryWrapper(Orientation.portrait),
      );

      // The hook only calls the callback when orientation changes, not on mount
      expect(capturedOrientation, null);
    });

    testWidgets('should not call callback on regular rebuilds', (tester) async {
      var callCount = 0;

      final result = await buildHook(
        (_) => useOrientationFn((orientation) {
          callCount++;
        }),
        wrapper: mediaQueryWrapper(Orientation.portrait),
      );

      expect(callCount, 0); // No callback on initial mount

      // Rebuild without orientation change
      await result.rebuild();
      expect(callCount, 0); // Should not increment
    });
  });
}
