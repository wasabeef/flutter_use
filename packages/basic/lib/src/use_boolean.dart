import 'use_toggle.dart';

/// Flutter state hook that manages a boolean value with toggle functionality.
///
/// This is an alias for [useToggle] that provides a more semantic name
/// when working specifically with boolean values.
///
/// [initialValue] is the starting boolean value.
///
/// Returns a [ToggleState] object that provides access to the current value
/// and a toggle method.
///
/// Example:
/// ```dart
/// final boolState = useBoolean(false);
///
/// print(boolState.value); // false
///
/// // Toggle the value
/// boolState.toggle();
/// print(boolState.value); // true
///
/// // Set to specific value
/// boolState.toggle(false);
/// print(boolState.value); // false
/// ```
///
/// See also: [useToggle]
ToggleState useBoolean(bool initialValue) => useToggle(initialValue);
