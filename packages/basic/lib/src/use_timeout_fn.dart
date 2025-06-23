import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that executes a function after a specified delay.
///
/// Schedules a function to be called after a timeout. The timeout starts when
/// the hook is initialized. The returned state object allows canceling or
/// resetting the timeout.
///
/// [fn] is the function to call after the timeout.
/// [delay] is the duration to wait before calling the function.
///
/// Returns a [TimeoutState] object that provides methods to check the timeout status,
/// cancel the timeout, or reset it.
///
/// Example:
/// ```dart
/// final timeoutState = useTimeoutFn(() {
///   print('Timeout executed!');
/// }, Duration(seconds: 3));
///
/// // Check if timeout is ready (has executed)
/// if (timeoutState.isReady() == true) {
///   print('Function has been called');
/// }
///
/// // Cancel the timeout
/// timeoutState.cancel();
///
/// // Reset the timeout (restart the countdown)
/// timeoutState.reset();
/// ```
TimeoutState useTimeoutFn(VoidCallback fn, Duration delay) {
  final isReady = useRef<bool?>(null);
  final timeout = useRef<Timer?>(null);
  final callback = useRef(fn);

  // update ref when function changes
  // ignore: body_might_complete_normally_nullable
  useEffect(
    () {
      callback.value = fn;
      return null;
    },
    [fn],
  );

  final getIsReady = useCallback<bool? Function()>(
    () => isReady.value,
    const [],
  );

  final reset = useCallback(
    () {
      isReady.value = false;
      timeout.value?.cancel();
      timeout.value = Timer(delay, () {
        isReady.value = true;
        callback.value();
      });
    },
    const [],
  );

  final cancel = useCallback(
    () {
      isReady.value = null;
      timeout.value?.cancel();
    },
    const [],
  );

  final state = useRef(TimeoutState(getIsReady, cancel, reset));

  // set on mount, clear on unmount
  useEffect(
    () {
      reset();

      return cancel;
    },
    [delay],
  );

  return state.value;
}

/// State manager for a timeout operation.
///
/// This class provides methods to check the timeout status and control
/// the timeout execution (cancel or reset).
@immutable
class TimeoutState {
  /// Creates a [TimeoutState] with the provided functions.
  const TimeoutState(this.isReady, this.cancel, this.reset);

  /// Returns the current status of the timeout.
  ///
  /// - `null`: Timeout has been cancelled or not started.
  /// - `false`: Timeout is running (waiting to execute).
  /// - `true`: Timeout has completed and the function has been called.
  final bool? Function() isReady;

  /// Cancels the timeout, preventing the function from being called.
  ///
  /// After calling this, `isReady()` will return `null`.
  final VoidCallback cancel;

  /// Resets the timeout, restarting the countdown from the beginning.
  ///
  /// This cancels any existing timeout and starts a new one with the same delay.
  /// After calling this, `isReady()` will return `false` until the timeout completes.
  final VoidCallback reset;
}
