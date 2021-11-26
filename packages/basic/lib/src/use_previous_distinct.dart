import 'package:flutter_hooks/flutter_hooks.dart';

import 'use_first_mount_state.dart';

/// Just like usePrevious but it will only update once the value actually
/// changes. This is important when other hooks are involved and you aren't
/// just interested in the previous props version, but want to know the
/// previous distinct value
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

typedef Predicate<T> = bool Function(T prev, T next);
