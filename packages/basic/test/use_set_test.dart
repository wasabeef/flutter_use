import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useSet', () {
    testWidgets('should init set with initial value', (tester) async {
      final result = await buildHook((_) => useSet({1, 2, 3}));
      expect(result.current.set, {1, 2, 3});
    });

    testWidgets('should add element', (tester) async {
      final result = await buildHook((_) => useSet<int>({1, 2}));
      await act(() => result.current.add(3));
      expect(result.current.set, {1, 2, 3});
    });

    testWidgets('should not add duplicate element', (tester) async {
      final result = await buildHook((_) => useSet<int>({1, 2}));
      await act(() => result.current.add(2));
      expect(result.current.set, {1, 2});
    });

    testWidgets('should add multiple elements', (tester) async {
      final result = await buildHook((_) => useSet<int>({1}));
      await act(() => result.current.addAll({2, 3, 4}));
      expect(result.current.set, {1, 2, 3, 4});
    });

    testWidgets('should remove element', (tester) async {
      final result = await buildHook((_) => useSet({1, 2, 3}));
      await act(() => result.current.remove(2));
      expect(result.current.set, {1, 3});
    });

    testWidgets('should toggle element', (tester) async {
      final result = await buildHook((_) => useSet({1, 2, 3}));
      await act(() => result.current.toggle(2));
      expect(result.current.set, {1, 3});
      await act(() => result.current.toggle(2));
      expect(result.current.set, {1, 2, 3});
    });

    testWidgets('should replace entire set', (tester) async {
      final result = await buildHook((_) => useSet({1, 2, 3}));
      await act(() => result.current.replace({4, 5, 6}));
      expect(result.current.set, {4, 5, 6});
    });

    testWidgets('should reset to initial value', (tester) async {
      final result = await buildHook((_) => useSet({1, 2, 3}));
      await act(() => result.current.add(4));
      await act(() => result.current.remove(1));
      expect(result.current.set, {2, 3, 4});
      await act(() => result.current.reset());
      expect(result.current.set, {1, 2, 3});
    });

    testWidgets('should work with custom objects', (tester) async {
      final result = await buildHook((_) => useSet<String>({'a', 'b'}));
      await act(() => result.current.add('c'));
      expect(result.current.set, {'a', 'b', 'c'});
    });
  });
}
