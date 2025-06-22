import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook for managing error states.
///
/// Provides a mechanism to store and dispatch errors.
///
/// Returns an [ErrorState] object that can dispatch errors and retrieve
/// the current error value.
///
/// Example:
/// ```dart
/// final errorState = useError();
///
/// // Dispatch an error
/// try {
///   // Some operation that might fail
///   throw ArgumentError('Invalid input');
/// } catch (e) {
///   if (e is Error) {
///     errorState.dispatch(e);
///   }
/// }
///
/// // Check for errors
/// if (errorState.value != null) {
///   print('Error occurred: ${errorState.value}');
/// }
/// ```
ErrorState useError() {
  final error = useState<Error?>(null);
  final dispatcher = useCallback<void Function(Error e)>(
    (e) {
      error.value = e;
    },
    const [],
  );

  final getter = useCallback<Error? Function()>(
    () => error.value,
    const [],
  );
  final state = useRef(ErrorState(dispatcher, getter));

  return state.value;
}

/// State manager for handling errors.
///
/// This class provides methods to dispatch errors and retrieve the current error state.
/// It maintains the latest error that was dispatched and provides access to it.
@immutable
class ErrorState {
  /// Creates an [ErrorState] with the provided dispatcher and getter functions.
  const ErrorState(this._dispatcher, this._getter);

  final Error? Function() _getter;
  final void Function(Error e) _dispatcher;

  /// Dispatches an error to be stored in the state.
  ///
  /// [e] is the error to store. This will replace any previously stored error.
  void dispatch(Error e) => _dispatcher(e);

  /// The current error value, or null if no error has been dispatched.
  Error? get value => _getter();
}
