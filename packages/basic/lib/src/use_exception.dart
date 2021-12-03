import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns an exception dispatcher.
ExceptionState useException() {
  final exception = useState<Exception?>(null);
  final dispatcher = useCallback<void Function(Exception e)>((e) {
    exception.value = e;
  }, const []);

  final getter = useCallback<Exception? Function()>(() {
    return exception.value;
  }, const []);
  final state = useRef(ExceptionState(dispatcher, getter));

  return state.value;
}

@immutable
class ExceptionState {
  const ExceptionState(this._dispatcher, this._getter);
  final Exception? Function() _getter;
  final void Function(Exception e) _dispatcher;

  void dispatch(Exception e) => _dispatcher(e);
  Exception? get value => _getter();
}
