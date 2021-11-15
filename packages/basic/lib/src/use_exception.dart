import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns an exception dispatcher.
ExceptionState useException() {
  final dispatcher = useRef<_ExceptionDispatcher>((Exception e) {});
  final state = useState(ExceptionState(dispatcher.value));
  dispatcher.value = useCallback((e) {
    final newState = ExceptionState(dispatcher.value, value: e);
    if (state.value != newState) state.value = newState;
  }, const []);

  useEffect(() {
    state.value = ExceptionState(dispatcher.value);
  }, const []);

  return state.value;
}

typedef _ExceptionDispatcher = void Function(Exception e);

@immutable
class ExceptionState {
  const ExceptionState(this._dispatcher, {this.value});
  final Exception? value;
  final _ExceptionDispatcher _dispatcher;
  void dispatch(Exception e) => _dispatcher(e);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExceptionState &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          _dispatcher == other._dispatcher;

  @override
  int get hashCode => _dispatcher.hashCode ^ value.hashCode;
}
