import 'use_counter.dart';

/// Flutter state hook that manages a numeric value with increment/decrement operations.
///
/// This is an alias for [useCounter] that provides a more semantic name
/// when working specifically with numeric values and mathematical operations.
///
/// [initialValue] is the starting numeric value.
/// [min] is the optional minimum value the number can reach.
/// [max] is the optional maximum value the number can reach.
///
/// Returns a [CounterActions] object that provides methods to manipulate the number.
///
/// Throws [ArgumentError] if [initialValue] is outside the [min]/[max] bounds.
///
/// Example:
/// ```dart
/// final number = useNumber(5, min: 0, max: 10);
///
/// print(number.value); // 5
///
/// // Increment/decrement
/// number.inc(); // 6
/// number.dec(); // 5
/// number.inc(3); // 8
///
/// // Set value
/// number.setter(2); // 2
///
/// // Reset
/// number.reset(); // back to 5
/// ```
///
/// See also: [useCounter]
CounterActions useNumber(int initialValue, {int? min, int? max}) =>
    useCounter(initialValue, min: min, max: max);
