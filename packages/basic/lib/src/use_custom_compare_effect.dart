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

/// A function that compares two lists of dependencies for equality.
///
/// This function receives the previous and next dependency lists and should
/// return true if they are considered equal, false otherwise. This allows
/// for custom comparison logic beyond simple reference equality.
///
/// Example:
/// ```dart
/// // Deep equality comparison for lists
/// bool deepEquals(List<Object?>? prev, List<Object?>? next) {
///   if (prev == null && next == null) return true;
///   if (prev == null || next == null) return false;
///   if (prev.length != next.length) return false;
///
///   for (int i = 0; i < prev.length; i++) {
///     if (!deepEqual(prev[i], next[i])) return false;
///   }
///   return true;
/// }
/// ```
typedef EqualFunction = bool Function(
  List<Object?>? prevKeys,
  List<Object?>? nextKeys,
);
