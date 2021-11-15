import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns an error dispatcher.
ErrorState useError() {
  final dispatcher = useRef<_ErrorDispatcher>((Error e) {});
  final state = useState(ErrorState(dispatcher.value));
  dispatcher.value = useCallback((e) {
    final newState = ErrorState(dispatcher.value, value: e);
    if (state.value != newState) state.value = newState;
  }, const []);

  useEffect(() {
    state.value = ErrorState(dispatcher.value);
  }, const []);

  return state.value;
}

typedef _ErrorDispatcher = void Function(Error e);

@immutable
class ErrorState {
  const ErrorState(this._dispatcher, {this.value});
  final Error? value;
  final _ErrorDispatcher _dispatcher;
  void dispatch(Error e) => _dispatcher(e);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorState &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          _dispatcher == other._dispatcher;

  @override
  int get hashCode => _dispatcher.hashCode ^ value.hashCode;
}
