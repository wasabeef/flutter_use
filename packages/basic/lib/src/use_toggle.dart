import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that tracks value of a boolean.
/// useBoolean is an alias for useToggle.
ToggleState useToggle(bool initialValue) {
  final toggle = useRef<_ToggleCallback>(({bool? value}) {});
  final state = useState(ToggleState(initialValue, toggle.value));

  toggle.value = useCallback(({value}) {
    final newState = ToggleState(value ?? !state.value.value, toggle.value);
    if (state.value != newState) state.value = newState;
  }, const []);

  useEffect(() {
    state.value = ToggleState(initialValue, toggle.value);
  }, const []);

  return state.value;
}

typedef _ToggleCallback = void Function({bool? value});

@immutable
class ToggleState {
  const ToggleState(this.value, this.toggle);
  final bool value;
  final _ToggleCallback toggle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToggleState &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          toggle == other.toggle;
  @override
  int get hashCode => value.hashCode;
}
