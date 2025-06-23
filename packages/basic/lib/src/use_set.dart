import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that manages a Set with reactive updates.
///
/// Provides methods to modify a set. The component re-builds when the set
/// changes through these methods. Direct modification of the set does not
/// trigger re-builds.
///
/// [initialSet] is the starting set value.
///
/// Returns a [SetAction] object that provides access to the current set
/// and all modification methods.
///
/// Example:
/// ```dart
/// final setActions = useSet<String>({'a', 'b', 'c'});
///
/// // Access the current set
/// print(setActions.set); // {'a', 'b', 'c'}
///
/// // Add elements
/// setActions.add('d');
/// setActions.addAll({'e', 'f'});
///
/// // Toggle elements (add if absent, remove if present)
/// setActions.toggle('a'); // removes 'a'
/// setActions.toggle('z'); // adds 'z'
///
/// // Remove elements
/// setActions.remove('b');
///
/// // Replace the entire set
/// setActions.replace({'x', 'y', 'z'});
///
/// // Reset to initial value
/// setActions.reset();
/// ```
SetAction<E> useSet<E>(Set<E> initialSet) {
  final set = useState(initialSet);

  final value = useCallback<Set<E> Function()>(
    () => set.value,
    const [],
  );

  final add = useCallback<void Function(E element)>(
    (element) {
      set.value = {
        ...set.value,
        ...{element},
      };
    },
    const [],
  );

  final addAll = useCallback<void Function(Set<E>)>(
    (value) {
      set.value = {...set.value, ...value};
    },
    const [],
  );

  final replace = useCallback<void Function(Set<E>)>(
    (newMap) {
      set.value = newMap;
    },
    const [],
  );

  final remove = useCallback<void Function(E element)>(
    (element) {
      final removedSet = {...set.value};
      removedSet.remove(element);
      set.value = removedSet;
    },
    const [],
  );

  final reset = useCallback<VoidCallback>(
    () {
      set.value = initialSet;
    },
    const [],
  );

  final toggle = useCallback<void Function(E element)>(
    (element) {
      final toggleSet = {...set.value};
      toggleSet.contains(element)
          ? toggleSet.remove(element)
          : toggleSet.add(element);
      set.value = toggleSet;
    },
    const [],
  );

  final state =
      useRef(SetAction<E>(value, add, addAll, replace, toggle, remove, reset));
  return state.value;
}

/// Provides reactive set manipulation methods.
///
/// This class contains all the methods needed to manipulate a set while
/// ensuring reactive updates that trigger widget rebuilds.
class SetAction<E> {
  /// Creates a [SetAction] with all the provided set manipulation functions.
  const SetAction(
    this._set,
    this.add,
    this.addAll,
    this.replace,
    this.toggle,
    this.remove,
    this.reset,
  );

  /// Adds an element to the set.
  final void Function(E element) add;

  /// Adds all elements from another set to this set.
  final void Function(Set<E>) addAll;

  /// Replaces the entire set with a new set.
  final void Function(Set<E>) replace;

  /// Toggles an element in the set (adds if absent, removes if present).
  final void Function(E element) toggle;

  /// Removes an element from the set.
  final void Function(E element) remove;

  /// Resets the set to its initial value.
  final VoidCallback reset;

  final Set<E> Function() _set;

  /// The current set value.
  Set<E> get set => _set();
}
