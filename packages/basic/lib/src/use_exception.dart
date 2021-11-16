import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns an exception dispatcher.
ExceptionState useException() {
  final exception = useState<Exception?>(null);
  final dispatcher = useCallback<_Dispatcher>((e) {
    exception.value = e;
  }, const []);

  final getter = useCallback<_GetFunction>(() {
    return exception.value;
  }, const []);
  final state = useRef(ExceptionState(dispatcher, getter));

  return state.value;
}

typedef _Dispatcher = void Function(Exception e);
typedef _GetFunction = Exception? Function();

@immutable
class ExceptionState {
  const ExceptionState(this._dispatcher, this._getter);
  final _GetFunction _getter;
  final _Dispatcher _dispatcher;

  void dispatch(Exception e) => _dispatcher(e);
  Exception? get value => _getter();
}
