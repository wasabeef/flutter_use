import 'package:flutter_hooks/flutter_hooks.dart';

import 'use_first_mount_state.dart';

/// Tracks the previous distinct value of a variable, updating only when the
/// value actually changes according to the comparison function.
T? usePreviousDistinct<T>(T value, [Predicate<T>? compare]) {
  compare ??= (prev, next) => prev == next;
  final prevRef = useRef<T?>(null);
  final curRef = useRef<T>(value);
  final isFirstMount = useFirstMountState();

  if (!isFirstMount && !compare(curRef.value, value)) {
    prevRef.value = curRef.value;
    curRef.value = value;
  }

  return prevRef.value;
}

/// A predicate function that compares two values for equality.
///
/// This function receives the previous and next values and should return
/// true if they are considered equal, false if they are different.
/// Used by [usePreviousDistinct] to determine when to update the previous value.
///
/// Example:
/// ```dart
/// // Custom comparison for objects
/// bool userEquals(User prev, User next) {
///   return prev.id == next.id && prev.name == next.name;
/// }
///
/// final prevUser = usePreviousDistinct(currentUser, userEquals);
/// ```
typedef Predicate<T> = bool Function(T prev, T next);
