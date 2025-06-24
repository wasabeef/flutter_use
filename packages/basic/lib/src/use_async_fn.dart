import 'package:flutter_hooks/flutter_hooks.dart';

import 'async_state.dart';

/// Flutter hook that manages the state of an asynchronous function with manual execution control.
///
/// Unlike automatic async hooks, this hook does not execute the async function automatically.
/// Instead, it returns an [AsyncAction] that provides an `execute` method to trigger
/// the async operation when needed, along with state information.
///
/// This is particularly useful for operations that should be triggered by user actions,
/// such as form submissions, API calls initiated by button presses, or any async
/// operation that needs manual control over when it executes.
///
/// [asyncFunction] is the asynchronous function to be executed manually. It should
/// return a [Future<T>] and will be called when [AsyncAction.execute] is invoked.
///
/// Returns an [AsyncAction<T>] object that contains:
/// - [loading]: indicates if the operation is in progress
/// - [data]: the result if the operation completed successfully
/// - [error]: the error if the operation failed
/// - [execute]: method to trigger the async operation
/// - [hasData]: getter indicating successful completion
/// - [hasError]: getter indicating failure
///
/// The async function execution is not cancelled if the widget is unmounted,
/// but the state updates will be ignored if they occur after unmounting.
///
/// Example:
/// ```dart
/// final loginAction = useAsyncFn(() async {
///   return await authService.login(email, password);
/// });
///
/// ElevatedButton(
///   onPressed: loginAction.loading
///       ? null
///       : () async {
///           try {
///             final user = await loginAction.execute();
///             // Handle successful login
///             Navigator.pushReplacementNamed(context, '/home');
///           } catch (e) {
///             // Handle login error
///             ScaffoldMessenger.of(context).showSnackBar(
///               SnackBar(content: Text('Login failed: $e')),
///             );
///           }
///         },
///   child: loginAction.loading
///       ? CircularProgressIndicator()
///       : Text('Login'),
/// )
/// ```
///
/// Example with conditional execution:
/// ```dart
/// final submitAction = useAsyncFn(() async {
///   return await api.submitForm(formData);
/// });
///
/// // Only execute if form is valid
/// if (formIsValid && !submitAction.loading) {
///   await submitAction.execute();
/// }
/// ```
///
/// See also:
///  * [useAsync], for automatically executed async operations
///  * [useFuture] from flutter_hooks, for simpler future handling
///  * [AsyncAction], the returned state and action object
AsyncAction<T> useAsyncFn<T>(
  Future<T> Function() asyncFunction,
) {
  final state = useState<AsyncState<T>>(
    const AsyncState.initial(),
  );

  final execute = useCallback(
    () async {
      state.value = AsyncState<T>(
        loading: true,
        data: state.value.data,
        error: null,
      );

      try {
        final result = await asyncFunction();
        state.value = AsyncState<T>(
          loading: false,
          data: result,
          error: null,
        );
        return result;
      } on Object catch (e) {
        state.value = AsyncState<T>(
          loading: false,
          data: null,
          error: e,
        );
        rethrow;
      }
    },
    [],
  );

  return AsyncAction<T>(
    loading: state.value.loading,
    data: state.value.data,
    error: state.value.error,
    execute: execute,
  );
}

/// State and action container for manually controlled async operations.
///
/// This class encapsulates both the current state of an async operation
/// and the method to execute it. It provides a consistent interface for
/// handling async operations that need manual triggering.
///
/// The state includes loading status, data, and error information, while
/// the execute method allows triggering the async operation when needed.
/// This pattern is useful for user-initiated actions like form submissions,
/// API calls, or any operation that should not run automatically.
class AsyncAction<T> {
  /// Creates an [AsyncAction] with the specified state and execution function.
  ///
  /// [loading] indicates whether the async operation is currently in progress.
  /// [data] contains the result if the operation completed successfully.
  /// [error] contains any error that occurred during execution.
  /// [execute] is the function to call to trigger the async operation.
  const AsyncAction({
    required this.loading,
    required this.data,
    required this.error,
    required this.execute,
  });

  /// Whether the async operation is currently loading.
  ///
  /// This is true from the moment [execute] is called until the operation
  /// completes (either successfully or with an error).
  final bool loading;

  /// The data returned by the async operation, if successful.
  ///
  /// This will be null if the operation hasn't completed yet, failed,
  /// or returned null as a valid result.
  final T? data;

  /// The error thrown by the async operation, if any.
  ///
  /// This will be null if the operation hasn't been executed yet,
  /// is still in progress, or completed successfully.
  final Object? error;

  /// Executes the async operation and returns the result.
  ///
  /// Calling this method will set [loading] to true, clear any previous
  /// [error], and execute the async function. Upon completion, [loading]
  /// will be set to false and either [data] or [error] will be updated.
  ///
  /// Returns a [Future<T>] that completes with the operation result.
  /// If the operation fails, the returned future will also fail with
  /// the same error.
  final Future<T> Function() execute;

  /// Whether the async operation has completed successfully.
  ///
  /// Returns true only if [data] is not null and [error] is null.
  /// Note that if T is nullable and the operation successfully returns null,
  /// this will return false.
  bool get hasData => data != null && error == null;

  /// Whether the async operation has failed.
  ///
  /// Returns true if [error] is not null, indicating that the last
  /// execution attempt resulted in an error.
  bool get hasError => error != null;
}
