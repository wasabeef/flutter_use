import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useStateList', () {
    testWidgets('should init with first element', (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      expect(result.current.state, 'a');
      expect(result.current.currentIndex, 0);
    });

    testWidgets('should navigate next', (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      await act(() => result.current.next());
      expect(result.current.state, 'b');
      expect(result.current.currentIndex, 1);
    });

    testWidgets('should navigate prev', (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      await act(() => result.current.setStateAt(2));
      await act(() => result.current.prev());
      expect(result.current.state, 'b');
      expect(result.current.currentIndex, 1);
    });

    testWidgets('should wrap around when navigating next from last',
        (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      await act(() => result.current.setStateAt(2));
      await act(() => result.current.next());
      expect(result.current.state, 'a');
      expect(result.current.currentIndex, 0);
    });

    testWidgets('should not go negative when navigating prev from first',
        (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      await act(() => result.current.prev());
      expect(result.current.state, 'a');
      expect(result.current.currentIndex, 0);
    });

    testWidgets('should set state by value', (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      await act(() => result.current.setState('c'));
      expect(result.current.state, 'c');
      expect(result.current.currentIndex, 2);
    });

    testWidgets('should throw error for invalid state', (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      expect(
        () => result.current.setState('d'),
        throwsArgumentError,
      );
    });

    testWidgets('should handle empty list', (tester) async {
      final result = await buildHook((_) => useStateList<String>([]));
      expect(() => result.current.state, throwsRangeError);
    });

    testWidgets('should handle index wrapping with setStateAt', (tester) async {
      final result = await buildHook((_) => useStateList(['a', 'b', 'c']));
      await act(() => result.current.setStateAt(5)); // 5 % 3 = 2
      expect(result.current.state, 'c');
      expect(result.current.currentIndex, 2);
    });

    testWidgets('should adjust index when list shrinks', (tester) async {
      var list = ['a', 'b', 'c', 'd'];
      final result = await buildHook(
        (props) => useStateList(props as List<String>),
        initialProps: list,
      );

      await act(() => result.current.setStateAt(3));
      expect(result.current.state, 'd');

      // Shrink the list
      list = ['a', 'b'];
      await result.rebuild(list);

      expect(result.current.currentIndex, 1); // Should adjust to last index
      expect(result.current.state, 'b');
    });

    testWidgets('should get list', (tester) async {
      final list = ['a', 'b', 'c'];
      final result = await buildHook((_) => useStateList(list));
      expect(result.current.list, list);
    });
  });
}
