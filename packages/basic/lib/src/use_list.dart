import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that manages a list with reactive updates.
///
/// Provides methods to modify a list. The component re-builds when the list
/// changes through these methods. Direct modification of the list does not
/// trigger re-builds.
///
/// The actions object and its methods remain stable across builds.
///
/// [initialList] is the starting list value.
///
/// Returns a [ListAction] object that provides access to the current list
/// and all modification methods.
///
/// Example:
/// ```dart
/// final listActions = useList([1, 2, 3]);
///
/// // Access the current list
/// print(listActions.list); // [1, 2, 3]
///
/// // Add elements
/// listActions.add(4);
/// listActions.addAll([5, 6]);
///
/// // Remove elements
/// listActions.remove(2);
/// listActions.removeAt(0);
///
/// // Modify elements
/// listActions.first(10);
/// listActions.last(20);
///
/// // Reset to initial value
/// listActions.reset();
/// ```
ListAction<E> useList<E>(List<E> initialList) {
  final list = useState(initialList);

  final value = useCallback<List<E> Function()>(
    () => list.value,
    const [],
  );

  final first = useCallback<void Function(E value)>(
    (value) {
      final newList = [...list.value];
      newList.first = value;
      list.value = newList;
    },
    const [],
  );

  final last = useCallback<void Function(E value)>(
    (value) {
      final newList = [...list.value];
      newList.last = value;
      list.value = newList;
    },
    const [],
  );

  final length = useCallback<int Function()>(
    () => list.value.length,
    const [],
  );

  final add = useCallback<void Function(E value)>(
    (value) {
      final newList = [...list.value];
      newList.add(value);
      list.value = newList;
    },
    const [],
  );

  final addAll = useCallback<void Function(Iterable<E> iterable)>(
    (iterable) {
      final newList = [...list.value];
      newList.addAll(iterable);
      list.value = newList;
    },
    const [],
  );

  final sort = useCallback<void Function([int Function(E, E)? compare])>(
    ([
      int Function(E, E)? compare,
    ]) {
      final newList = [...list.value];
      newList.sort(compare);
      list.value = newList;
    },
    const [],
  );

  final shuffle = useCallback<void Function([Random? random])>(
    ([random]) {
      final newList = [...list.value];
      newList.shuffle(random);
      list.value = newList;
    },
    const [],
  );

  final indexOf = useCallback<int Function(E element, [int start])>(
    (
      element, [
      start = 0,
    ]) =>
        list.value.indexOf(element, start),
    const [],
  );

  final indexWhere =
      useCallback<int Function(bool Function(E element) test, [int start])>(
    (bool Function(E element) test, [start = 0]) =>
        list.value.indexWhere(test, start),
    const [],
  );

  final lastIndexWhere =
      useCallback<int Function(bool Function(E element) test, [int? start])>(
    (bool Function(E element) test, [start]) =>
        list.value.lastIndexWhere(test, start),
    const [],
  );

  final lastIndexOf = useCallback<int Function(E element, [int? start])>(
    (element, [start]) => list.value.lastIndexOf(element, start),
    const [],
  );

  final clear = useCallback<void Function()>(
    () {
      final newList = [...list.value];
      newList.clear();
      list.value = newList;
    },
    const [],
  );

  final insert = useCallback<void Function(int index, E element)>(
    (index, element) {
      final newList = [...list.value];
      newList.insert(index, element);
      list.value = newList;
    },
    const [],
  );

  final insertAll = useCallback<void Function(int index, Iterable<E> iterable)>(
    (index, iterable) {
      final newList = [...list.value];
      newList.insertAll(index, iterable);
      list.value = newList;
    },
    const [],
  );

  final setAll = useCallback<void Function(int index, Iterable<E> iterable)>(
    (index, iterable) {
      final newList = [...list.value];
      newList.setAll(index, iterable);
      list.value = newList;
    },
    const [],
  );

  final remove = useCallback<bool Function(Object? value)>(
    (value) {
      final newList = [...list.value];
      final removed = newList.remove(value);
      list.value = newList;
      return removed;
    },
    const [],
  );

  final removeAt = useCallback<E Function(int index)>(
    (index) {
      final newList = [...list.value];
      final removed = newList.removeAt(index);
      list.value = newList;
      return removed;
    },
    const [],
  );

  final removeLast = useCallback<E Function()>(
    () {
      final newList = [...list.value];
      final removed = newList.removeLast();
      list.value = newList;
      return removed;
    },
    const [],
  );

  final removeWhere = useCallback<void Function(bool Function(E element) test)>(
    (bool Function(E element) test) {
      final newList = [...list.value];
      newList.removeWhere(test);
      list.value = newList;
    },
    const [],
  );

  final sublist = useCallback<List<E> Function(int start, [int? end])>(
    (start, [end]) => list.value.sublist(start, end),
    const [],
  );

  final getRange = useCallback<Iterable<E> Function(int start, int end)>(
    (start, end) => list.value.getRange(start, end),
    const [],
  );

  final setRange = useCallback<
      void Function(
        int start,
        int end,
        Iterable<E> iterable, [
        int skipCount,
      ])>(
    (
      start,
      end,
      iterable, [
      skipCount = 0,
    ]) {
      final newList = [...list.value];
      newList.setRange(start, end, iterable, skipCount);
      list.value = newList;
    },
    const [],
  );

  final removeRange = useCallback<void Function(int start, int end)>(
    (start, end) {
      final newList = [...list.value];
      newList.removeRange(start, end);
      list.value = newList;
    },
    const [],
  );

  final fillRange =
      useCallback<void Function(int start, int end, [E? fillValue])>(
    (start, end, [fillValue]) {
      final newList = [...list.value];
      newList.fillRange(start, end, fillValue);
      list.value = newList;
    },
    const [],
  );

  final replaceRange =
      useCallback<void Function(int start, int end, Iterable<E> iterable)>(
    (start, end, iterable) {
      final newList = [...list.value];
      newList.replaceRange(start, end, iterable);
      list.value = newList;
    },
    const [],
  );

  final asMap = useCallback<Map<int, E> Function()>(
    () => list.value.asMap(),
    const [],
  );

  final reset = useCallback(
    () {
      list.value = initialList;
    },
    const [],
  );

  final state = useRef(
    ListAction<E>(
      value,
      first,
      last,
      length,
      add,
      addAll,
      sort,
      shuffle,
      indexOf,
      indexWhere,
      lastIndexWhere,
      lastIndexOf,
      clear,
      insert,
      insertAll,
      setAll,
      remove,
      removeAt,
      removeLast,
      removeWhere,
      sublist,
      getRange,
      setRange,
      removeRange,
      fillRange,
      replaceRange,
      reset,
      asMap,
    ),
  );
  return state.value;
}

/// Provides reactive list manipulation methods.
///
/// This class contains all the methods needed to manipulate a list while
/// ensuring reactive updates. It mirrors most of Dart's List API but with
/// reactive behavior that triggers widget rebuilds.
class ListAction<E> {
  /// Creates a [ListAction] with all the provided list manipulation functions.
  ListAction(
    this._list,
    this.first,
    this.last,
    this.length,
    this.add,
    this.addAll,
    this.sort,
    this.shuffle,
    this.indexOf,
    this.indexWhere,
    this.lastIndexWhere,
    this.lastIndexOf,
    this.clear,
    this.insert,
    this.insertAll,
    this.setAll,
    this.remove,
    this.removeAt,
    this.removeLast,
    this.removeWhere,
    this.sublist,
    this.getRange,
    this.setRange,
    this.removeRange,
    this.fillRange,
    this.replaceRange,
    this.reset,
    this.asMap,
  );

  /// Sets the first element of the list.
  final void Function(E value) first;

  /// Sets the last element of the list.
  final void Function(E value) last;

  /// Returns the length of the list.
  final int Function() length;

  /// Adds an element to the end of the list.
  final void Function(E value) add;

  /// Adds all elements of an iterable to the end of the list.
  final void Function(Iterable<E> iterable) addAll;

  /// Sorts the list according to the compare function.
  final void Function([int Function(E, E)? compare]) sort;

  /// Shuffles the elements of the list randomly.
  final void Function([Random? random]) shuffle;

  /// Returns the first index of the element in the list.
  final int Function(E element, [int start]) indexOf;

  /// Returns the first index where the test function returns true.
  final int Function(bool Function(E) test, [int start]) indexWhere;

  /// Returns the last index where the test function returns true.
  final int Function(bool Function(E) test, [int? start]) lastIndexWhere;

  /// Returns the last index of the element in the list.
  final int Function(E element, [int? start]) lastIndexOf;

  /// Removes all elements from the list.
  final void Function() clear;

  /// Inserts an element at the specified index.
  final void Function(int index, E element) insert;

  /// Inserts all elements of an iterable at the specified index.
  final void Function(int index, Iterable<E> iterable) insertAll;

  /// Overwrites elements with the elements of an iterable.
  final void Function(int index, Iterable<E> iterable) setAll;

  /// Removes the first occurrence of the value from the list.
  final bool Function(Object? value) remove;

  /// Removes the element at the specified index.
  final E Function(int index) removeAt;

  /// Removes and returns the last element of the list.
  final E Function() removeLast;

  /// Removes all elements that satisfy the test function.
  final void Function(bool Function(E element) test) removeWhere;

  /// Returns a new list containing elements from start to end.
  final List<E> Function(int start, [int? end]) sublist;

  /// Returns an iterable for the specified range.
  final Iterable<E> Function(int start, int end) getRange;

  /// Copies elements from an iterable into a range of the list.
  final void Function(int start, int end, Iterable<E> iterable, [int skipCount])
      setRange;

  /// Removes elements in the specified range.
  final void Function(int start, int end) removeRange;

  /// Sets elements in a range to a fill value.
  final void Function(int start, int end, [E? fillValue]) fillRange;

  /// Replaces elements in a range with elements from an iterable.
  final void Function(int start, int end, Iterable<E> replacements)
      replaceRange;

  /// Resets the list to its initial value.
  final VoidCallback reset;

  /// Returns a map where keys are indices and values are list elements.
  final Map<int, E> Function() asMap;

  final List<E> Function() _list;

  /// The current list value.
  List<E> get list => _list();
}
