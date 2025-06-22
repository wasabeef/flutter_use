import 'package:flutter/foundation.dart';
import 'package:flutter_use/flutter_use.dart';

/// Flutter lifecycle hook that executes a function when the component is mounted.
///
/// This hook runs the provided function once when the component is first mounted
/// (similar to React's useEffect with an empty dependency array). It's useful
/// for initialization logic that should only run once.
///
/// [fn] is the function to execute on mount.
///
/// Example:
/// ```dart
/// useMount(() {
///   print('Component mounted!');
///   // Initialize data, start timers, etc.
///   fetchInitialData();
/// });
/// ```
///
/// Note: If you need both mount and unmount functions, use [useLifecycles] instead.
///
/// See also:
/// - [useUnmount] for unmount-only logic
/// - [useLifecycles] for both mount and unmount logic
/// - [useEffectOnce] for the underlying implementation
void useMount(VoidCallback fn) => useEffectOnce(() {
      fn();
      return null;
    });
