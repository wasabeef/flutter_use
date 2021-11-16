import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns an error dispatcher.
ErrorState useError() {
  final error = useState<Error?>(null);
  final dispatcher = useCallback<_Dispatcher>((e) {
    error.value = e;
  }, const []);

  final getter = useCallback<_GetFunction>(() {
    return error.value;
  }, const []);
  final state = useRef(ErrorState(dispatcher, getter));

  return state.value;
}

typedef _Dispatcher = void Function(Error e);
typedef _GetFunction = Error? Function();

@immutable
class ErrorState {
  const ErrorState(this._dispatcher, this._getter);
  final _GetFunction _getter;
  final _Dispatcher _dispatcher;

  void dispatch(Error e) => _dispatcher(e);
  Error? get value => _getter();
}
