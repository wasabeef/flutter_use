import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that manages a boolean value.
///
/// Provides a toggle method that flips the current value or sets it to a
/// specific value.
///
/// [initialValue] is the starting boolean value.
///
/// Returns a [ToggleState] object that provides access to the current value
/// and a toggle method.
///
/// Example:
/// ```dart
/// final toggleState = useToggle(false);
///
/// print(toggleState.value); // false
///
/// // Toggle the value
/// toggleState.toggle();
/// print(toggleState.value); // true
///
/// // Set to specific value
/// toggleState.toggle(false);
/// print(toggleState.value); // false
/// ```
///
/// useBoolean is an alias for useToggle.
ToggleState useToggle(bool initialValue) {
  final toggle = useState(initialValue);

  final setter = useCallback<void Function([bool?])>(
    ([value]) {
      toggle.value = value ?? !toggle.value;
    },
    const [],
  );

  final getter = useCallback<bool Function()>(
    () => toggle.value,
    const [],
  );

  final state = useState(ToggleState(getter, setter));

  return state.value;
}

/// State manager for a boolean value with toggle functionality.
///
/// This class provides access to a boolean value and methods to toggle it
/// either by flipping the current value or setting it to a specific value.
@immutable
class ToggleState {
  /// Creates a [ToggleState] with the provided getter and setter functions.
  const ToggleState(this._getter, this._setter);

  final bool Function() _getter;
  final void Function([bool?]) _setter;

  /// The current boolean value.
  bool get value => _getter();

  /// Toggles the boolean value.
  ///
  /// If [value] is provided, sets the state to that value.
  /// If [value] is null, flips the current value (true becomes false, false becomes true).
  void toggle([bool? value]) => _setter(value);
}
