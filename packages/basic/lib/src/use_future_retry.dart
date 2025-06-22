import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that manages a Future with retry functionality.
///
/// Extends the standard `useFuture` hook by adding a retry mechanism
/// that allows re-execution of the future.
///
/// [future] is the Future to execute. Can be null.
/// [initialData] is the initial data to use before the future completes.
/// [preserveState] determines whether to keep the previous data while retrying.
///
/// Returns a [FutureState] object that provides access to the current
/// [AsyncSnapshot] and a retry method.
///
/// Example:
/// ```dart
/// final futureState = useFutureRetry(
///   fetchUserData(userId),
///   initialData: null,
///   preserveState: true,
/// );
///
/// // Access the current state
/// if (futureState.snapshot.hasData) {
///   print('Data: ${futureState.snapshot.data}');
/// } else if (futureState.snapshot.hasError) {
///   print('Error: ${futureState.snapshot.error}');
///   // Retry on error
///   futureState.retry();
/// }
/// ```
FutureState<T> useFutureRetry<T>(
  Future<T>? future, {
  T? initialData,
  bool preserveState = true,
}) {
  final attempt = useState(0);
  final snapshotRef = useRef<AsyncSnapshot<T>>(const AsyncSnapshot.nothing());

  final snapshot = useFuture<T>(
    useMemoized(() => future, [attempt.value]),
    initialData: initialData,
    preserveState: preserveState,
  );
  snapshotRef.value = snapshot;

  final snapshotCallback = useCallback<SnapshotCallback<T>>(
    () => snapshotRef.value,
    const [],
  );

  final retry = useCallback(
    () {
      attempt.value++;
    },
    [future, initialData, preserveState],
  );

  final state = useRef(FutureState(snapshotCallback, retry));

  return state.value;
}

/// Callback type for getting the current AsyncSnapshot.
typedef SnapshotCallback<T> = AsyncSnapshot<T> Function();

/// State manager for a Future with retry functionality.
///
/// This class provides access to the current [AsyncSnapshot] state of a Future
/// and a method to retry the Future execution.
@immutable
class FutureState<T> {
  /// Creates a [FutureState] with the provided snapshot callback and retry function.
  const FutureState(this._snapshot, this.retry);

  final SnapshotCallback<T> _snapshot;

  /// The current AsyncSnapshot representing the state of the Future.
  ///
  /// This snapshot contains information about whether the Future is loading,
  /// has completed with data, or has completed with an error.
  AsyncSnapshot<T> get snapshot => _snapshot();

  /// Retries the Future execution.
  ///
  /// Calling this method will cause the Future to be re-executed,
  /// which is useful for handling failures or refreshing data.
  final VoidCallback retry;
}
