import 'package:flutter_hooks/flutter_hooks.dart';

/// A modified useEffect hook that accepts a comparator which is used for
/// comparison on dependencies instead of reference equality.
void useCustomCompareEffect(
  Dispose? Function() effect,
  List<Object?>? keys,
  EqualFunction keysEqual,
) {
  final ref = useRef(keys);

  if (ref.value == null || !keysEqual(keys, ref.value)) {
    ref.value = keys;
  }
  useEffect(effect, ref.value);
}

typedef EqualFunction = bool Function(
    List<Object?>? prevKeys, List<Object?>? nextKeys);
