import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useOrientation', () {
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

    testWidgets('should return portrait orientation', (tester) async {
      final result = await buildHook(
        (_) => useOrientation(),
        wrapper: mediaQueryWrapper(Orientation.portrait),
      );

      expect(result.current, Orientation.portrait);
    });

    testWidgets('should return landscape orientation', (tester) async {
      final result = await buildHook(
        (_) => useOrientation(),
        wrapper: mediaQueryWrapper(Orientation.landscape),
      );

      expect(result.current, Orientation.landscape);
    });
  });
}
