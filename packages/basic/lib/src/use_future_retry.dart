import 'package:flutter/foundation.dart';
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
  final state = useRef(FutureState<T>(const AsyncSnapshot.nothing(), () {}));

  final snapshot = useFuture<T>(
    useMemoized(() => future, [attempt.value]),
    initialData: initialData,
    preserveState: preserveState,
  );

  final retry = useCallback(() {
    attempt.value++;
  }, [future, initialData, preserveState]);

  useEffect(() {
    state.value = FutureState<T>(snapshot, retry);
  });

  return state.value;
}

@immutable
class FutureState<T> {
  const FutureState(this.snapshot, this.retry);
  final AsyncSnapshot<T> snapshot;
  final VoidCallback retry;
}
