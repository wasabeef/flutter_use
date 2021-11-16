// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Calls given function after specified duration.
/// Provides handles to cancel and/or reset the timeout.
TimeoutState useTimeoutFn(VoidCallback fn, Duration delay) {
  final isReady = useRef<bool?>(null);
  final timeout = useRef<Timer?>(null);
  final callback = useRef(fn);

  // update ref when function changes
  useEffect(() {
    callback.value = fn;
  }, [fn]);

  final getIsReady = useCallback<_IsReadyFunction>(() {
    return isReady.value;
  }, const []);

  final reset = useCallback(() {
    isReady.value = false;
    timeout.value?.cancel();
    timeout.value = Timer(delay, () {
      isReady.value = true;
      callback.value();
    });
  }, const []);

  final cancel = useCallback(() {
    isReady.value = null;
    timeout.value?.cancel();
  }, const []);

  final state = useRef(TimeoutState(getIsReady, reset, cancel));

  // set on mount, clear on unmount
  useEffect(() {
    reset();

    return cancel;
  }, [delay]);

  return state.value;
}

typedef _IsReadyFunction = bool? Function();

@immutable
class TimeoutState {
  const TimeoutState(this.isReady, this.cancel, this.reset);

  final _IsReadyFunction isReady;
  final VoidCallback cancel;
  final VoidCallback reset;
}
