import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that tracks a Set.
SetAction<E> useSet<E>(Set<E> initialSet) {
  final set = useState(initialSet);

  final value = useCallback<Set<E> Function()>(() {
    return set.value;
  }, const []);

  final add = useCallback<void Function(E element)>((element) {
    set.value = {
      ...set.value,
      ...{element}
    };
  }, const []);

  final addAll = useCallback<void Function(Set<E>)>((value) {
    set.value = {...set.value, ...value};
  }, const []);

  final replace = useCallback<void Function(Set<E>)>((newMap) {
    set.value = newMap;
  }, const []);

  final remove = useCallback<void Function(E element)>((element) {
    final removedSet = {...set.value};
    removedSet.remove(element);
    set.value = removedSet;
  }, const []);

  final reset = useCallback<VoidCallback>(() {
    set.value = initialSet;
  }, const []);

  final toggle = useCallback<void Function(E element)>((element) {
    final toggleSet = {...set.value};
    toggleSet.contains(element)
        ? toggleSet.remove(element)
        : toggleSet.add(element);
    set.value = toggleSet;
  }, const []);

  final state =
      useRef(SetAction<E>(value, add, addAll, replace, toggle, remove, reset));
  return state.value;
}

class SetAction<E> {
  const SetAction(
    this._set,
    this.add,
    this.addAll,
    this.replace,
    this.toggle,
    this.remove,
    this.reset,
  );

  final void Function(E element) add;
  final void Function(Set<E>) addAll;
  final void Function(Set<E>) replace;
  final void Function(E element) toggle;
  final void Function(E element) remove;
  final VoidCallback reset;
  final Set<E> Function() _set;

  Set<E> get set => _set();
}
