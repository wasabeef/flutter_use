import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'use_update.dart';
import 'use_update_effect.dart';

/// Custom hook to track if widget is mounted.
///
/// Returns a function that can be called to check if the widget is still mounted.
bool Function() _useIsMounted() {
  final context = useContext();
  final isMountedRef = useRef(true);

  useEffect(
    () => () {
      isMountedRef.value = false;
    },
    const [],
  );

  return useCallback(
    () => isMountedRef.value && context.mounted,
    const [],
  );
}

/// Flutter state hook that manages a circular iteration over a list of states.
///
/// Allows forward and backward iteration through a list of states with
/// arbitrary position setting. The iteration wraps around at the boundaries.
///
/// [stateSet] is the list of states to iterate through. Defaults to an empty list.
///
/// Returns a [UseStateList] object that provides access to the current state,
/// navigation methods, and state manipulation functions.
///
/// Example:
/// ```dart
/// final stateList = useStateList(['loading', 'success', 'error']);
///
/// print(stateList.state); // 'loading' (first item)
/// print(stateList.currentIndex); // 0
///
/// // Navigate to next state
/// stateList.next();
/// print(stateList.state); // 'success'
///
/// // Navigate to previous state
/// stateList.prev();
/// print(stateList.state); // 'loading'
///
/// // Set specific state
/// stateList.setState('error');
/// print(stateList.state); // 'error'
/// print(stateList.currentIndex); // 2
///
/// // Set by index
/// stateList.setStateAt(1);
/// print(stateList.state); // 'success'
/// ```
UseStateList<T> useStateList<T>([List<T> stateSet = const []]) {
  final isMounted = _useIsMounted();
  final update = useUpdate();
  final index = useRef(0);

  // If new state list is shorter that before - switch to the last element
  // ignore: body_might_complete_normally_nullable
  useUpdateEffect(
    () {
      if (stateSet.length <= index.value) {
        index.value = stateSet.length - 1;
        update();
      }
      return null;
    },
    [stateSet.length],
  );

  final stateList = useCallback<List<T> Function()>(() => stateSet, const []);

  final currentIndex = useCallback<int Function()>(() => index.value, const []);

  final setStateAt = useCallback<void Function(int newIndex)>(
    (newIndex) {
      // do nothing on unmounted component
      if (!isMounted()) {
        return;
      }

      // do nothing on empty states list
      if (stateSet.isEmpty) {
        return;
      }

      // in case new index is equal current - do nothing
      if (newIndex == index.value) {
        return;
      }

      // it gives the ability to travel through the left and right borders.
      // 4ex: if list contains 5 elements, attempt to set index 9 will bring use to 5th element
      // in case of negative index it will set to the 0th.
      index.value = newIndex >= 0 ? newIndex % stateSet.length : 0;
      update();
    },
    const [],
  );

  final setState = useCallback<void Function(T state)>(
    (state) {
      // do nothing on unmounted component
      if (!isMounted()) {
        return;
      }

      final newIndex = stateSet.isNotEmpty ? stateSet.indexOf(state) : -1;

      if (newIndex == -1) {
        throw ArgumentError(
          'State $state is not a valid state (does not exist in state list)',
        );
      }

      index.value = newIndex;
      update();
    },
    const [],
  );

  final next = useCallback<VoidCallback>(
    () {
      setStateAt(index.value + 1);
    },
    const [],
  );

  final prev = useCallback<VoidCallback>(
    () {
      setStateAt(index.value - 1);
    },
    const [],
  );

  final state = useRef(
    UseStateList<T>(
      stateList,
      currentIndex,
      setStateAt,
      setState,
      next,
      prev,
    ),
  );
  return state.value;
}

/// State manager for circular iteration over a list of states.
///
/// This class provides methods to navigate through a predefined list of states
/// with circular navigation support, allowing forward/backward iteration
/// and arbitrary position setting.
class UseStateList<T> {
  /// Creates a [UseStateList] with the provided functions and callbacks.
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

  /// Sets the current state to the item at the specified index.
  ///
  /// If [newIndex] is greater than the list length, it wraps around using modulo.
  /// If [newIndex] is negative, it sets the index to 0.
  final void Function(int newIndex) setStateAt;

  /// Sets the current state to the specified value.
  ///
  /// Throws [ArgumentError] if [state] is not found in the state list.
  final void Function(T state) setState;

  /// Moves to the next state in the list.
  ///
  /// Wraps around to the first state if currently at the last state.
  final VoidCallback next;

  /// Moves to the previous state in the list.
  ///
  /// Wraps around to the last state if currently at the first state.
  final VoidCallback prev;

  /// The complete list of states.
  List<T> get list => _stateList();

  /// The current state value.
  T get state => _stateList()[currentIndex];

  /// The current index in the state list.
  int get currentIndex => _index();
}
