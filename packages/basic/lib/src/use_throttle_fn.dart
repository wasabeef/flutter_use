import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

/// State object returned by [useThrottleFn].
class ThrottledFunction<T> {
  /// Creates a [ThrottledFunction].
  const ThrottledFunction({
    required this.call,
    required this.cancel,
    required this.isThrottled,
  });

  /// Calls the throttled function.
  ///
  /// If called multiple times within [duration], only the first call
  /// will execute immediately. Subsequent calls return null and are ignored
  /// until the duration has passed.
  final T? Function() call;

  /// Cancels any pending throttled execution.
  final void Function() cancel;

  /// Whether the function is currently throttled (waiting for duration to pass).
  final bool isThrottled;
}

/// Creates a throttled function that limits execution to at most once per [duration].
///
/// The function will execute immediately on the first call, then ignore
/// subsequent calls until [duration] has passed since the last execution.
///
/// Returns a [ThrottledFunction] that contains:
/// - [ThrottledFunction.call]: The throttled function to call
/// - [ThrottledFunction.cancel]: Cancels any pending execution
/// - [ThrottledFunction.isThrottled]: Whether currently throttled
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   final throttledSave = useThrottleFn<void>(
///     () => saveDataToServer(),
///     Duration(seconds: 1),
///   );
///
///   return Column(
///     children: [
///       if (throttledSave.isThrottled)
///         Text('Please wait before saving again...'),
///       ElevatedButton(
///         onPressed: throttledSave.call,
///         child: Text('Save'),
///       ),
///     ],
///   );
/// }
/// ```
ThrottledFunction<T> useThrottleFn<T>(
  T Function() fn,
  Duration duration,
) {
  final lastCall = useRef<DateTime?>(null);
  final timer = useRef<Timer?>(null);
  final isThrottled = useState(false);
  final fnRef = useRef(fn);

  // Update the function reference on each call
  fnRef.value = fn;

  final cancel = useCallback<void Function()>(
    () {
      timer.value?.cancel();
      timer.value = null;
      isThrottled.value = false;
    },
    const [],
  );

  final throttledFn = useCallback<T? Function()>(
    () {
      final now = DateTime.now();
      final last = lastCall.value;

      if (last == null || now.difference(last) >= duration) {
        // Execute immediately
        lastCall.value = now;
        isThrottled.value = true;

        // Set timer to reset throttle state
        timer.value?.cancel();
        timer.value = Timer(duration, () {
          isThrottled.value = false;
        });

        return fnRef.value();
      }

      // Return null when throttled
      return null;
    },
    const [],
  );

  useEffect(
    () => () {
      timer.value?.cancel();
    },
    [],
  );

  return ThrottledFunction(
    call: throttledFn,
    cancel: cancel,
    isThrottled: isThrottled.value,
  );
}
