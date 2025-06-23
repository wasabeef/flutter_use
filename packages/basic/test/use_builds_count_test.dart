import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useBuildsCount', () {
    testWidgets('should return 1 on first build', (tester) async {
      final result = await buildHook((_) => useBuildsCount());
      expect(result.current, 1);
    });

    testWidgets('should increment on each rebuild', (tester) async {
      final result = await buildHook((_) => useBuildsCount());
      expect(result.current, 1);

      await result.rebuild();
      expect(result.current, 2);

      await result.rebuild();
      expect(result.current, 3);
    });

    testWidgets('should persist count between multiple rebuilds',
        (tester) async {
      final result = await buildHook((_) => useBuildsCount());

      for (var i = 1; i <= 5; i++) {
        expect(result.current, i);
        if (i < 5) {
          await result.rebuild();
        }
      }
    });

    testWidgets('should reset count on unmount and remount', (tester) async {
      final result = await buildHook((_) => useBuildsCount());
      expect(result.current, 1);

      await result.rebuild();
      expect(result.current, 2);

      await result.unmount();

      // Create a new instance
      final newResult = await buildHook((_) => useBuildsCount());
      expect(newResult.current, 1);
    });
  });
}
