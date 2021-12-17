import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Uses useFuture with an additional retry method to easily retry/refresh
/// the future function.
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

  final snapshotCallback = useCallback<SnapshotCallback<T>>(() {
    return snapshotRef.value;
  }, const []);

  final retry = useCallback(() {
    attempt.value++;
  }, [future, initialData, preserveState]);

  final state = useRef(FutureState(snapshotCallback, retry));

  return state.value;
}

typedef SnapshotCallback<T> = AsyncSnapshot<T> Function();

@immutable
class FutureState<T> {
  const FutureState(this._snapshot, this.retry);
  final SnapshotCallback<T> _snapshot;
  AsyncSnapshot<T> get snapshot => _snapshot();
  final VoidCallback retry;
}
