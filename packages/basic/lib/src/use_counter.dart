import 'dart:math' as math;

import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that tracks a numeric value.
///
/// Creates a counter with increment, decrement, set, and reset operations.
/// The counter value can be constrained between optional [min] and [max] values.
///
/// [initialValue] is the starting value for the counter.
/// [min] is the optional minimum value the counter can reach.
/// [max] is the optional maximum value the counter can reach.
///
/// Returns a [CounterActions] object that provides methods to manipulate the counter.
///
/// Throws [ArgumentError] if [initialValue] is outside the [min]/[max] bounds.
///
/// Example:
/// ```dart
/// final counter = useCounter(0, min: 0, max: 10);
///
/// // Increment by 1
/// counter.inc();
///
/// // Increment by specific amount
/// counter.inc(5);
///
/// // Set to specific value
/// counter.setter(7);
///
/// // Get current value
/// print(counter.value); // 7
/// ```
///
/// useNumber is an alias for useCounter.
CounterActions useCounter(int initialValue, {int? min, int? max}) {
  if (min != null && initialValue < min) {
    throw ArgumentError(
      'The initialValue must be equal to or greater than min value.',
    );
  }

  if (max != null && initialValue > max) {
    throw ArgumentError(
      'The initialValue must be equal to or less than max value.',
    );
  }

  final state = useState(initialValue);

  final get = useCallback<int Function()>(
    () => state.value,
    const [],
  );

  final inc = useCallback<void Function([int?])>(
    ([value]) {
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
    },
    const [],
  );

  final dec = useCallback<void Function([int?])>(
    ([value]) {
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
    },
    const [],
  );

  final set = useCallback<void Function(int)>(
    (value) {
      if (max == null) {
        state.value = value;
      } else {
        state.value = math.min(value, max);
      }
    },
    const [],
  );

  final reset = useCallback<void Function([int?])>(
    ([value]) {
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
    },
    const [],
  );

  final minValue = useCallback<int? Function()>(
    () => min,
    const [],
  );

  final maxValue = useCallback<int? Function()>(
    () => max,
    const [],
  );

  final action = useRef(
    CounterActions(
      get,
      inc,
      dec,
      set,
      reset,
      minValue,
      maxValue,
    ),
  );
  return action.value;
}

/// Actions for manipulating a counter value.
///
/// This class provides methods to increment, decrement, set, and reset
/// a counter value while respecting optional min/max constraints.
class CounterActions {
  /// Creates a [CounterActions] instance with the provided functions.
  CounterActions(
    this.getter,
    this.inc,
    this.dec,
    this.setter,
    this.reset,
    this._min,
    this._max,
  );

  /// Increments the counter value.
  ///
  /// If no [value] is provided, increments by 1.
  /// If [value] is provided, increments by that amount.
  /// Respects the maximum constraint if set.
  final void Function([int?]) inc;

  /// Decrements the counter value.
  ///
  /// If no [value] is provided, decrements by 1.
  /// If [value] is provided, decrements by that amount.
  /// Respects the minimum constraint if set.
  final void Function([int?]) dec;

  /// Function to get the current counter value.
  final int Function() getter;

  /// The current value of the counter.
  int get value => getter();

  /// Sets the counter to a specific value.
  ///
  /// Respects the maximum constraint if set.
  final void Function(int) setter;

  /// Resets the counter to its initial value.
  ///
  /// If [value] is provided, resets to that value and updates the initial value.
  /// The new initial value will be clamped to min/max constraints if they exist.
  final void Function([int?]) reset;

  final int? Function() _min;

  /// The minimum value constraint, or null if no constraint is set.
  int? get min => _min();

  final int? Function() _max;

  /// The maximum value constraint, or null if no constraint is set.
  int? get max => _max();
}
