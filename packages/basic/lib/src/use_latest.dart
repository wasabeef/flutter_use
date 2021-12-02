import 'package:flutter_hooks/flutter_hooks.dart';

/// React state hook that returns the latest state as described in
/// the [React hooks FAQ](ref link). This is mostly useful to get access to the
/// latest value of some props or state inside an asynchronous callback,
/// instead of that value at the time the callback was created from.
/// [ref link](https://reactjs.org/docs/hooks-faq.html#why-am-i-seeing-stale-props-or-state-inside-my-function)
T useLatest<T>(T value) {
  final ref = useRef(value);
  ref.value = value;
  return ref.value;
}
