import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'use_update.dart';
import 'use_update_effect.dart';

/// Provides handles for circular iteration over states list.
/// Supports forward and backward iterations and arbitrary position set.
UseStateList<T> useStateList<T>([List<T> stateSet = const []]) {
  final isMounted = useIsMounted();
  final update = useUpdate();
  final index = useRef(0);

  // If new state list is shorter that before - switch to the last element
  // ignore: body_might_complete_normally_nullable
  useUpdateEffect(() {
    if (stateSet.length <= index.value) {
      index.value = stateSet.length - 1;
      update();
    }
  }, [stateSet.length]);

  final stateList = useCallback<List<T> Function()>(() => stateSet, const []);

  final currentIndex = useCallback<int Function()>(() => index.value, const []);

  final setStateAt = useCallback<void Function(int newIndex)>((int newIndex) {
    // do nothing on unmounted component
    if (!isMounted()) return;

    // do nothing on empty states list
    if (stateSet.isEmpty) return;

    // in case new index is equal current - do nothing
    if (newIndex == index.value) return;

    // it gives the ability to travel through the left and right borders.
    // 4ex: if list contains 5 elements, attempt to set index 9 will bring use to 5th element
    // in case of negative index it will set to the 0th.
    index.value = newIndex >= 0 ? newIndex % stateSet.length : 0;
    update();
  }, const []);

  final setState = useCallback<void Function(T state)>((T state) {
    // do nothing on unmounted component
    if (!isMounted()) return;

    final newIndex = stateSet.isNotEmpty ? stateSet.indexOf(state) : -1;

    if (newIndex == -1) {
      throw ArgumentError(
          "State $state is not a valid state (does not exist in state list)");
    }

    index.value = newIndex;
    update();
  }, const []);

  final next = useCallback<VoidCallback>(() {
    setStateAt(index.value + 1);
  }, const []);

  final prev = useCallback<VoidCallback>(() {
    setStateAt(index.value - 1);
  }, const []);

  final state = useRef(UseStateList<T>(
    stateList,
    currentIndex,
    setStateAt,
    setState,
    next,
    prev,
  ));
  return state.value;
}

class UseStateList<T> {
  const UseStateList(
    this._stateList,
    this._index,
    this.setStateAt,
    this.setState,
    this.next,
    this.prev,
  );
  final List<T> Function() _stateList;
  final int Function() _index;
  final void Function(int newIndex) setStateAt;
  final void Function(T state) setState;
  final VoidCallback next;
  final VoidCallback prev;

  List<T> get list => _stateList();
  T get state => _stateList()[currentIndex];
  int get currentIndex => _index();
}
