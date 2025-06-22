import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook for managing exception states.
///
/// Provides a mechanism to store and dispatch exceptions.
///
/// Returns an [ExceptionState] object that can dispatch exceptions and retrieve
/// the current exception value.
///
/// Example:
/// ```dart
/// final exceptionState = useException();
///
/// // Dispatch an exception
/// try {
///   // Some operation that might fail
///   throw Exception('Network error');
/// } catch (e) {
///   if (e is Exception) {
///     exceptionState.dispatch(e);
///   }
/// }
///
/// // Check for exceptions
/// if (exceptionState.value != null) {
///   print('Exception occurred: ${exceptionState.value}');
/// }
/// ```
ExceptionState useException() {
  final exception = useState<Exception?>(null);
  final dispatcher = useCallback<void Function(Exception e)>(
    (e) {
      exception.value = e;
    },
    const [],
  );

  final getter = useCallback<Exception? Function()>(
    () => exception.value,
    const [],
  );
  final state = useRef(ExceptionState(dispatcher, getter));

  return state.value;
}

/// State manager for handling exceptions.
///
/// This class provides methods to dispatch exceptions and retrieve the current exception state.
/// It maintains the latest exception that was dispatched and provides access to it.
@immutable
class ExceptionState {
  /// Creates an [ExceptionState] with the provided dispatcher and getter functions.
  const ExceptionState(this._dispatcher, this._getter);

  final Exception? Function() _getter;
  final void Function(Exception e) _dispatcher;

  /// Dispatches an exception to be stored in the state.
  ///
  /// [e] is the exception to store. This will replace any previously stored exception.
  void dispatch(Exception e) => _dispatcher(e);

  /// The current exception value, or null if no exception has been dispatched.
  Exception? get value => _getter();
}
