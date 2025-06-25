import 'package:flutter_hooks/flutter_hooks.dart';

import 'async_state.dart';

/// Flutter state hook that manages asynchronous operations with loading, data, and error states.
///
/// This hook simplifies handling asynchronous operations by providing a unified
/// state that includes loading status, data, and error information. The async function
/// is automatically executed when the hook is first created and re-executed whenever
/// the dependency keys change.
///
/// [asyncFunction] is the asynchronous function to execute. It should return a [Future<T>].
/// [keys] is an optional list of dependencies. When any value in this list changes,
/// the async function will be re-executed. Defaults to an empty list.
///
/// Returns an [AsyncState<T>] object containing the current state of the async operation.
/// The state includes [loading], [data], [error], [hasData], and [hasError] properties.
///
/// The async function is automatically cancelled if the widget is unmounted or if
/// the keys change before the operation completes.
///
/// Example:
/// ```dart
/// final userState = useAsync(() => fetchUserData());
///
/// if (userState.loading) {
///   return CircularProgressIndicator();
/// } else if (userState.hasError) {
///   return Text('Error: ${userState.error}');
/// } else if (userState.hasData) {
///   return Text('User: ${userState.data}');
/// }
/// ```
///
/// Example with dependencies:
/// ```dart
/// final dataState = useAsync(
///   () => fetchUserData(userId),
///   keys: [userId], // Re-fetch when userId changes
/// );
/// ```
///
/// See also:
///  * [useFuture] from flutter_hooks, for simpler future handling
AsyncState<T> useAsync<T>(
  Future<T> Function() asyncFunction, {
  List<Object?> keys = const [],
}) {
  final state = useState<AsyncState<T>>(
    const AsyncState.loading(),
  );

  useEffect(
    () {
      var cancelled = false;

      void execute() async {
        state.value = AsyncState<T>(
          loading: true,
          data: state.value.data,
          error: null,
        );

        try {
          final result = await asyncFunction();
          if (!cancelled) {
            state.value = AsyncState<T>(
              loading: false,
              data: result,
              error: null,
            );
          }
        } on Object catch (e) {
          if (!cancelled) {
            state.value = AsyncState<T>(
              loading: false,
              data: null,
              error: e,
            );
          }
        }
      }

      execute();

      return () {
        cancelled = true;
      };
    },
    keys,
  );

  return state.value;
}
