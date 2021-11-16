import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that returns the default value when state is null.
DefaultState<T> useDefault<T>(T defaultValue, T initialValue) {
  final value = useState(initialValue);
  final getter = useCallback<T Function()>(() {
    return value.value;
  }, const []);

  final setter = useCallback<void Function(T?)>((newValue) {
    value.value = newValue ??= defaultValue;
  }, const []);

  final state = useRef(DefaultState<T>(getter, setter));
  return state.value;
}

class DefaultState<T> {
  DefaultState(this._getter, this._setter);

  final T Function() _getter;
  final void Function(T?) _setter;

  T get value => _getter();
  set value(T? newValue) => _setter(newValue);
}
