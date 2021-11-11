import 'use_toggle.dart';

/// Flutter state hook that tracks value of a bool.
/// useBoolean is an alias for useToggle.
ToggleState useBoolean(bool initialValue) {
  return useToggle(initialValue);
}
