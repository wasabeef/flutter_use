import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useCustomCompareEffect', () {
    testWidgets('should run effect on mount', (tester) async {
      var effectCount = 0;

      await buildHook(
        (_) => useCustomCompareEffect(
          () {
            effectCount++;
            return null;
          },
          [],
          (prev, next) => false, // Always different
        ),
      );

      expect(effectCount, 1);
    });

    testWidgets('should run effect when custom compare returns false',
        (tester) async {
      var effectCount = 0;
      var deps = [1, 2, 3];

      final result = await buildHook(
        (props) => useCustomCompareEffect(
          () {
            effectCount++;
            return null;
          },
          props as List<int>,
          (prev, next) => false, // Always different
        ),
        initialProps: deps,
      );

      expect(effectCount, 1);

      deps = [1, 2, 3]; // Same values
      await result.rebuild(deps);
      expect(effectCount, 1); // Should not run again on rebuild with same deps
    });

    testWidgets('should not run effect when custom compare returns true',
        (tester) async {
      var effectCount = 0;
      var deps = [1, 2, 3];

      final result = await buildHook(
        (props) => useCustomCompareEffect(
          () {
            effectCount++;
            return null;
          },
          props as List<int>,
          (prev, next) => true, // Always same
        ),
        initialProps: deps,
      );

      expect(effectCount, 1);

      deps = [4, 5, 6]; // Different values
      await result.rebuild(deps);
      expect(effectCount, 1); // Should not run because compare returns true
    });

    testWidgets('should use deep comparison', (tester) async {
      var effectCount = 0;
      var deps = [
        {'a': 1, 'b': 2},
      ];

      final result = await buildHook(
        (props) => useCustomCompareEffect(
          () {
            effectCount++;
            return null;
          },
          props as List<Map<String, int>>,
          (prev, next) {
            if (prev == null || next == null) {
              return false;
            }
            if (prev.length != next.length) {
              return false;
            }

            for (var i = 0; i < prev.length; i++) {
              final prevMap = prev[i] as Map<String, int>?;
              final nextMap = next[i] as Map<String, int>?;

              if (prevMap == null || nextMap == null) {
                return false;
              }
              if (prevMap.length != nextMap.length) {
                return false;
              }

              for (final key in prevMap.keys) {
                if (prevMap[key] != nextMap[key]) {
                  return false;
                }
              }
            }
            return true;
          },
        ),
        initialProps: deps,
      );

      expect(effectCount, 1);

      // New object with same values
      deps = [
        {'a': 1, 'b': 2},
      ];
      await result.rebuild(deps);
      expect(effectCount, 1); // Should not run because values are deep equal

      // Different values
      deps = [
        {'a': 1, 'b': 3},
      ];
      await result.rebuild(deps);
      expect(effectCount, 2); // Should run because values changed
    });

    testWidgets('should handle cleanup function', (tester) async {
      var cleanupCalled = false;
      var deps = [1];

      final result = await buildHook(
        (props) => useCustomCompareEffect(
          () => () => cleanupCalled = true,
          props as List<int>,
          (prev, next) => false, // Always different
        ),
        initialProps: deps,
      );

      deps = [2];
      await result.rebuild(deps);
      expect(cleanupCalled, true);
    });

    testWidgets('should handle null dependencies', (tester) async {
      var effectCount = 0;
      List<int>? deps;

      final result = await buildHook(
        (props) => useCustomCompareEffect(
          () {
            effectCount++;
            return null;
          },
          props as List<int>?,
          (prev, next) => prev == null && next == null,
        ),
        initialProps: deps,
      );

      expect(
        effectCount,
        1,
      ); // Runs once on initial mount with null dependencies

      await result.rebuild(deps);
      expect(
        effectCount,
        2,
      ); // Runs again on rebuild even with same null dependencies

      deps = [1, 2];
      await result.rebuild(deps);
      expect(effectCount, 3); // Should run because deps changed from null
    });
  });
}
