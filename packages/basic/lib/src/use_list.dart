import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks an array and provides methods to modify it. To cause component
/// re-build you have to use these methods instead of direct interaction
/// with array - it won't cause re-build.
/// We can ensure that actions object and actions itself will not mutate or
/// change between builds, so there is no need to add it to useEffect
/// dependencies and safe to pass them down to children.
ListAction<E> useList<E>(List<E> initialList) {
  final list = useState(initialList);

  final value = useCallback<List<E> Function()>(() {
    return list.value;
  }, const []);

  final first = useCallback<void Function(E value)>((E value) {
    final newList = [...list.value];
    newList.first = value;
    list.value = newList;
  }, const []);

  final last = useCallback<void Function(E value)>((E value) {
    final newList = [...list.value];
    newList.last = value;
    list.value = newList;
  }, const []);

  final length = useCallback<int Function()>(() {
    return list.value.length;
  }, const []);

  final add = useCallback<void Function(E value)>((E value) {
    final newList = [...list.value];
    newList.add(value);
    list.value = newList;
  }, const []);

  final addAll =
      useCallback<void Function(Iterable<E> iterable)>((Iterable<E> iterable) {
    final newList = [...list.value];
    newList.addAll(iterable);
    list.value = newList;
  }, const []);

  final sort = useCallback<void Function([int Function(E, E)? compare])>((
      [int Function(E, E)? compare]) {
    final newList = [...list.value];
    newList.sort(compare);
    list.value = newList;
  }, const []);

  final shuffle =
      useCallback<void Function([Random? random])>(([Random? random]) {
    final newList = [...list.value];
    newList.shuffle(random);
    list.value = newList;
  }, const []);

  final indexOf = useCallback<int Function(E element, [int start])>((E element,
      [int start = 0]) {
    return list.value.indexOf(element, start);
  }, const []);

  final indexWhere =
      useCallback<int Function(bool Function(E element) test, [int start])>(
          (bool Function(E element) test, [int start = 0]) {
    return list.value.indexWhere(test, start);
  }, const []);

  final lastIndexWhere =
      useCallback<int Function(bool Function(E element) test, [int? start])>(
          (bool Function(E element) test, [int? start]) {
    return list.value.lastIndexWhere(test, start);
  }, const []);

  final lastIndexOf = useCallback<int Function(E element, [int? start])>(
      (E element, [int? start]) {
    return list.value.lastIndexOf(element, start);
  }, const []);

  final clear = useCallback<void Function()>(() {
    final newList = [...list.value];
    newList.clear();
    list.value = newList;
  }, const []);

  final insert =
      useCallback<void Function(int index, E element)>((int index, E element) {
    final newList = [...list.value];
    newList.insert(index, element);
    list.value = newList;
  }, const []);

  final insertAll = useCallback<void Function(int index, Iterable<E> iterable)>(
      (int index, Iterable<E> iterable) {
    final newList = [...list.value];
    newList.insertAll(index, iterable);
    list.value = newList;
  }, const []);

  final setAll = useCallback<void Function(int index, Iterable<E> iterable)>(
      (int index, Iterable<E> iterable) {
    final newList = [...list.value];
    newList.setAll(index, iterable);
    list.value = newList;
  }, const []);

  final remove = useCallback<bool Function(Object? value)>((Object? value) {
    final newList = [...list.value];
    final removed = newList.remove(value);
    list.value = newList;
    return removed;
  }, const []);

  final removeAt = useCallback<E Function(int index)>((int index) {
    final newList = [...list.value];
    final removed = newList.removeAt(index);
    list.value = newList;
    return removed;
  }, const []);

  final removeLast = useCallback<E Function()>(() {
    final newList = [...list.value];
    final removed = newList.removeLast();
    list.value = newList;
    return removed;
  }, const []);

  final removeWhere = useCallback<void Function(bool Function(E element) test)>(
      (bool Function(E element) test) {
    final newList = [...list.value];
    newList.removeWhere(test);
    list.value = newList;
  }, const []);

  final sublist = useCallback<List<E> Function(int start, [int? end])>(
      (int start, [int? end]) {
    return list.value.sublist(start, end);
  }, const []);

  final getRange = useCallback<Iterable<E> Function(int start, int end)>(
      (int start, int end) {
    return list.value.getRange(start, end);
  }, const []);

  final setRange = useCallback<
      void Function(int start, int end, Iterable<E> iterable,
          [int skipCount])>((int start, int end, Iterable<E> iterable,
      [int skipCount = 0]) {
    final newList = [...list.value];
    newList.setRange(start, end, iterable, skipCount);
    list.value = newList;
  }, const []);

  final removeRange =
      useCallback<void Function(int start, int end)>((int start, int end) {
    final newList = [...list.value];
    newList.removeRange(start, end);
    list.value = newList;
  }, const []);

  final fillRange =
      useCallback<void Function(int start, int end, [E? fillValue])>(
          (int start, int end, [E? fillValue]) {
    final newList = [...list.value];
    newList.fillRange(start, end, fillValue);
    list.value = newList;
  }, const []);

  final replaceRange =
      useCallback<void Function(int start, int end, Iterable<E> iterable)>(
          (int start, int end, Iterable<E> iterable) {
    final newList = [...list.value];
    newList.replaceRange(start, end, iterable);
    list.value = newList;
  }, const []);

  final asMap = useCallback<Map<int, E> Function()>(() {
    return list.value.asMap();
  }, const []);

  final reset = useCallback(() {
    list.value = initialList;
  }, const []);

  final state = useRef(ListAction<E>(
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
  ));
  return state.value;
}

class ListAction<E> {
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
  final void Function(E value) first;
  final void Function(E value) last;
  final int Function() length;
  final void Function(E value) add;
  final void Function(Iterable<E> iterable) addAll;
  final void Function([int Function(E, E)? compare]) sort;
  final void Function([Random? random]) shuffle;
  final int Function(E element, [int start]) indexOf;
  final int Function(bool Function(E) test, [int start]) indexWhere;
  final int Function(bool Function(E) test, [int? start]) lastIndexWhere;
  final int Function(E element, [int? start]) lastIndexOf;
  final void Function() clear;
  final void Function(int index, E element) insert;
  final void Function(int index, Iterable<E> iterable) insertAll;
  final void Function(int index, Iterable<E> iterable) setAll;
  final bool Function(Object? value) remove;
  final E Function(int index) removeAt;
  final E Function() removeLast;
  final void Function(bool Function(E element) test) removeWhere;
  final List<E> Function(int start, [int? end]) sublist;
  final Iterable<E> Function(int start, int end) getRange;
  final void Function(int start, int end, Iterable<E> iterable, [int skipCount])
      setRange;
  final void Function(int start, int end) removeRange;
  final void Function(int start, int end, [E? fillValue]) fillRange;
  final void Function(int start, int end, Iterable<E> replacements)
      replaceRange;
  final VoidCallback reset;
  final Map<int, E> Function() asMap;
  final List<E> Function() _list;

  List<E> get list => _list();
}
