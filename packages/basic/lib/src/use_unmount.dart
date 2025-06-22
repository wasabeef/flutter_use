import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

/// Flutter lifecycle hook that executes a function when the component is unmounted.
///
/// This hook runs the provided function when the component is about to be unmounted
/// (destroyed). It's useful for cleanup logic such as canceling timers, closing
/// streams, or removing listeners.
///
/// [fn] is the function to execute on unmount. The function reference is updated
/// on each build, so the latest version will always be called.
///
/// Example:
/// ```dart
/// useUnmount(() {
///   print('Component unmounting!');
///   // Cleanup: cancel timers, close streams, remove listeners
///   timer?.cancel();
///   subscription?.cancel();
/// });
/// ```
///
/// Note: If you need both mount and unmount functions, use [useLifecycles] instead.
///
/// See also:
/// - [useMount] for mount-only logic
/// - [useLifecycles] for both mount and unmount logic
/// - [useEffectOnce] for the underlying implementation
void useUnmount(VoidCallback fn) {
  final fnRef = useRef(fn);

  // update the ref each build so if it change the newest callback will be invoked
  fnRef.value = fn;

  return useEffectOnce(() => () => fnRef.value());
}
