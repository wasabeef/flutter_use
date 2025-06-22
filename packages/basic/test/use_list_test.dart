import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useList', () {
    testWidgets('should init list with initial value', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      expect(result.current.list, [1, 2, 3]);
    });

    testWidgets('should add element', (tester) async {
      final result = await buildHook((_) => useList<int>([1, 2]));
      await act(() => result.current.add(3));
      expect(result.current.list, [1, 2, 3]);
    });

    testWidgets('should add multiple elements', (tester) async {
      final result = await buildHook((_) => useList<int>([1]));
      await act(() => result.current.addAll([2, 3, 4]));
      expect(result.current.list, [1, 2, 3, 4]);
    });

    testWidgets('should remove element', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      await act(() => result.current.remove(2));
      expect(result.current.list, [1, 3]);
    });

    testWidgets('should remove element at index', (tester) async {
      final result = await buildHook((_) => useList(['a', 'b', 'c']));
      await act(() => result.current.removeAt(1));
      expect(result.current.list, ['a', 'c']);
    });

    testWidgets('should remove last element', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      await act(() => result.current.removeLast());
      expect(result.current.list, [1, 2]);
    });

    testWidgets('should clear list', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      await act(() => result.current.clear());
      expect(result.current.list, <int>[]);
    });

    testWidgets('should insert element at index', (tester) async {
      final result = await buildHook((_) => useList([1, 3]));
      await act(() => result.current.insert(1, 2));
      expect(result.current.list, [1, 2, 3]);
    });

    testWidgets('should sort list', (tester) async {
      final result = await buildHook((_) => useList([3, 1, 2]));
      await act(() => result.current.sort());
      expect(result.current.list, [1, 2, 3]);
    });

    testWidgets('should sort with comparator', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      await act(() => result.current.sort((a, b) => b.compareTo(a)));
      expect(result.current.list, [3, 2, 1]);
    });

    testWidgets('should reset to initial value', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      await act(() => result.current.clear());
      expect(result.current.list, <int>[]);
      await act(() => result.current.reset());
      expect(result.current.list, [1, 2, 3]);
    });

    testWidgets('should update first element', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      await act(() => result.current.first(10));
      expect(result.current.list, [10, 2, 3]);
    });

    testWidgets('should update last element', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      await act(() => result.current.last(10));
      expect(result.current.list, [1, 2, 10]);
    });

    testWidgets('should get length', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3]));
      expect(result.current.length(), 3);
    });

    testWidgets('should find index of element', (tester) async {
      final result = await buildHook((_) => useList(['a', 'b', 'c', 'b']));
      expect(result.current.indexOf('b'), 1);
      expect(result.current.indexOf('b', 2), 3);
      expect(result.current.indexOf('d'), -1);
    });

    testWidgets('should find index where', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3, 4]));
      expect(result.current.indexWhere((e) => e > 2), 2);
      expect(result.current.indexWhere((e) => e > 10), -1);
    });

    testWidgets('should remove where', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3, 4, 5]));
      await act(() => result.current.removeWhere((e) => e % 2 == 0));
      expect(result.current.list, [1, 3, 5]);
    });

    testWidgets('should get sublist', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3, 4, 5]));
      expect(result.current.sublist(1, 4), [2, 3, 4]);
    });

    testWidgets('should fill range', (tester) async {
      final result = await buildHook((_) => useList([1, 2, 3, 4, 5]));
      await act(() => result.current.fillRange(1, 4, 0));
      expect(result.current.list, [1, 0, 0, 0, 5]);
    });

    testWidgets('should convert to map', (tester) async {
      final result = await buildHook((_) => useList(['a', 'b', 'c']));
      expect(result.current.asMap(), {0: 'a', 1: 'b', 2: 'c'});
    });
  });
}
