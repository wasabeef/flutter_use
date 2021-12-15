import 'dart:math' as math;

import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that tracks a numeric value.
/// useNumber is an alias for useCounter.
CounterActions useCounter(int initialValue, {int? min, int? max}) {
  if (min != null && initialValue < min) {
    throw ArgumentError(
        "The initialValue must be equal to or greater than min value.");
  }

  if (max != null && initialValue > max) {
    throw ArgumentError(
        "The initialValue must be equal to or less than max value.");
  }

  final state = useState(initialValue);

  final get = useCallback<int Function()>(() {
    return state.value;
  }, const []);

  final inc = useCallback<void Function([int?])>(([value]) {
    if (max == null) {
      if (value == null) {
        state.value++;
      } else {
        state.value += value;
      }
    } else {
      if (value == null) {
        state.value = math.min(state.value + 1, max);
      } else {
        state.value = math.min(state.value + value, max);
      }
    }
  }, const []);

  final dec = useCallback<void Function([int?])>(([value]) {
    if (min == null) {
      if (value == null) {
        state.value--;
      } else {
        state.value -= value;
      }
    } else {
      if (value == null) {
        state.value = math.max(state.value - 1, min);
      } else {
        state.value = math.max(state.value - value, min);
      }
    }
  }, const []);

  final set = useCallback<void Function(int)>((value) {
    if (max == null) {
      state.value = value;
    } else {
      state.value = math.min(value, max);
    }
  }, const []);

  final reset = useCallback<void Function([int?])>(([value]) {
    if (value != null) {
      initialValue = value;

      if (min != null) {
        initialValue = math.max(value, min);
      }

      if (max != null) {
        initialValue = math.min(initialValue, max);
      }

      state.value = initialValue;
    } else {
      state.value = initialValue;
    }
  }, const []);

  final minValue = useCallback<int? Function()>(() {
    return min;
  }, const []);

  final maxValue = useCallback<int? Function()>(() {
    return max;
  }, const []);

  final action = useRef(CounterActions(
    get,
    inc,
    dec,
    set,
    reset,
    minValue,
    maxValue,
  ));
  return action.value;
}

class CounterActions {
  CounterActions(
    this.getter,
    this.inc,
    this.dec,
    this.setter,
    this.reset,
    this._min,
    this._max,
  );

  final void Function([int?]) inc;
  final void Function([int?]) dec;
  final int Function() getter;
  int get value => getter();
  final void Function(int) setter;
  final void Function([int?]) reset;
  final int? Function() _min;
  int? get min => _min();
  final int? Function() _max;
  int? get max => _max();
}
