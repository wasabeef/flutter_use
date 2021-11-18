import 'use_counter.dart';

/// Flutter state hook that tracks a numeric value.
/// useNumber is an alias for useCounter.
CounterActions useNumber(int initialValue, {int? min, int? max}) {
  return useCounter(initialValue, min: min, max: max);
}
