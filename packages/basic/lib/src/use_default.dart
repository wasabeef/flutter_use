import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that manages a value with automatic fallback to a default.
///
/// When the state value is set to null, it automatically falls back to the [defaultValue].
///
/// [defaultValue] is the value to use when the state is set to null.
/// [initialValue] is the starting value for the state.
///
/// Returns a [DefaultState] object that provides access to the current value
/// and a setter that handles null values automatically.
///
/// Example:
/// ```dart
/// final defaultState = useDefault('Hello', 'World');
///
/// print(defaultState.value); // 'World'
///
/// defaultState.value = 'Flutter';
/// print(defaultState.value); // 'Flutter'
///
/// defaultState.value = null; // Falls back to default
/// print(defaultState.value); // 'Hello'
/// ```
DefaultState<T> useDefault<T>(T defaultValue, T initialValue) {
  final value = useState(initialValue);

  final getter = useCallback<T Function()>(
    () => value.value,
    const [],
  );

  final setter = useCallback<void Function(T?)>(
    (newValue) {
      value.value = newValue ??= defaultValue;
    },
    const [],
  );

  final state = useRef(DefaultState<T>(getter, setter));

  return state.value;
}

/// State manager that provides automatic fallback to a default value.
///
/// This class encapsulates a value that automatically falls back to a default
/// when set to null. It provides both getter and setter access to the underlying value.
@immutable
class DefaultState<T> {
  /// Creates a [DefaultState] with the provided getter and setter functions.
  const DefaultState(this._getter, this._setter);

  final T Function() _getter;
  final void Function(T?) _setter;

  /// The current value. Never null due to automatic fallback behavior.
  T get value => _getter();

  /// Sets the value. If [newValue] is null, the state falls back to the default value.
  set value(T? newValue) => _setter(newValue);
}
