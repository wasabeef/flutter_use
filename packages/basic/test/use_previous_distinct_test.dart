import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('usePreviousDistinct', () {
    testWidgets('should return null on first mount', (tester) async {
      final result = await buildHook((_) => usePreviousDistinct(1));
      expect(result.current, null);
    });

    testWidgets('should return previous value when value changes',
        (tester) async {
      var value = 1;
      final result = await buildHook(
        (props) => usePreviousDistinct(props as int),
        initialProps: value,
      );

      expect(result.current, null);

      value = 2;
      await result.rebuild(value);
      expect(result.current, 1);

      value = 3;
      await result.rebuild(value);
      expect(result.current, 2);
    });

    testWidgets('should not update when value stays the same', (tester) async {
      var value = 1;
      final result = await buildHook(
        (props) => usePreviousDistinct(props as int),
        initialProps: value,
      );

      expect(result.current, null);

      value = 2;
      await result.rebuild(value);
      expect(result.current, 1);

      // Same value
      await result.rebuild(value);
      expect(result.current, 1); // Should still be 1

      // Same value again
      await result.rebuild(value);
      expect(result.current, 1); // Should still be 1
    });

    testWidgets('should use custom compare function', (tester) async {
      var value = {'count': 1};
      final result = await buildHook(
        (props) => usePreviousDistinct(
          props as Map<String, int>,
          (prev, next) =>
              (prev as Map<String, int>)['count'] ==
              (next as Map<String, int>)['count'],
        ),
        initialProps: value,
      );

      expect(result.current, null);

      // Different object but same count
      value = {'count': 1};
      await result.rebuild(value);
      expect(result.current, null); // Should not update

      // Different count
      value = {'count': 2};
      await result.rebuild(value);
      expect(result.current?['count'], 1);
    });

    testWidgets('should handle null values', (tester) async {
      int? value;
      final result = await buildHook(
        (props) => usePreviousDistinct(props as int?),
        initialProps: value,
      );

      expect(result.current, null);

      value = 1;
      await result.rebuild(value);
      expect(result.current, null);

      value = null;
      await result.rebuild(value);
      expect(result.current, 1);
    });

    testWidgets('should work with complex objects', (tester) async {
      var value = [1, 2, 3];
      final result = await buildHook(
        (props) => usePreviousDistinct(
          props as List<int>,
          (prev, next) =>
              (prev as List<int>).length == (next as List<int>).length,
        ),
        initialProps: value,
      );

      expect(result.current, null);

      // Same length
      value = [4, 5, 6];
      await result.rebuild(value);
      expect(result.current, null); // Should not update

      // Different length
      value = [7, 8];
      await result.rebuild(value);
      expect(result.current, [1, 2, 3]);
    });
  });
}
