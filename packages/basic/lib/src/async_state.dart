/// The state of an asynchronous operation.
///
/// Represents the current state of an async operation with loading status,
/// data, and error information.
///
/// [loading] indicates whether the operation is currently in progress.
/// [data] contains the result if the operation completed successfully.
/// [error] contains the error if the operation failed.
class AsyncState<T> {
  /// Creates an [AsyncState].
  ///
  /// All parameters are required to ensure explicit state definition.
  const AsyncState({
    required this.loading,
    required this.data,
    required this.error,
  });

  /// Creates an initial loading state.
  ///
  /// Convenient constructor for creating a state that indicates
  /// an async operation is in progress.
  const AsyncState.loading()
      : loading = true,
        data = null,
        error = null;

  /// Creates an initial idle state.
  ///
  /// Convenient constructor for creating a state that indicates
  /// no async operation is in progress and no data is available.
  const AsyncState.initial()
      : loading = false,
        data = null,
        error = null;

  /// Whether the async operation is currently loading.
  final bool loading;

  /// The data returned by the async operation, if successful.
  final T? data;

  /// The error thrown by the async operation, if any.
  final Object? error;

  /// Whether the async operation has completed successfully.
  bool get hasData => data != null && error == null;

  /// Whether the async operation has failed.
  bool get hasError => error != null;
}
