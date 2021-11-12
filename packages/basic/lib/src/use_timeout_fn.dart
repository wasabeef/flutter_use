// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Calls given function after specified duration.
/// Provides handles to cancel and/or reset the timeout.
TimeoutState useTimeoutFn(VoidCallback fn, Duration delay) {
  final timer = useRef<Timer?>(null);
  final callback = useRef(fn);
  final state = useRef(const TimeoutState(isReady: null));

  // update ref when function changes
  useEffect(() {
    callback.value = fn;
  }, [fn]);

  final reset = useCallback(() {
    state.value = state.value.copyWith(isReady: false);
    timer.value?.cancel();
    timer.value = Timer(delay, () {
      state.value = state.value.copyWith(isReady: true);
      callback.value();
    });
  }, const []);

  final cancel = useCallback(() {
    state.value = state.value.copyWith(isReady: null);
    timer.value?.cancel();
  }, const []);

  // set on mount, clear on unmount
  useEffect(() {
    state.value = TimeoutState(cancel: cancel, reset: reset, isReady: null);
    reset();

    return cancel;
  }, [delay]);

  return state.value;
}

@immutable
class TimeoutState {
  const TimeoutState({
    required this.isReady,
    VoidCallback? cancel,
    VoidCallback? reset,
  })  : _cancel = cancel,
        _reset = reset;

  final bool? isReady;
  final VoidCallback? _cancel;
  final VoidCallback? _reset;

  void cancel() => _cancel?.call();

  void reset() => _reset?.call();

  TimeoutState copyWith({
    VoidCallback? cancel,
    VoidCallback? reset,
    required bool? isReady,
  }) =>
      TimeoutState(
        cancel: cancel ?? _cancel,
        reset: reset ?? _reset,
        isReady: isReady,
      );
}
