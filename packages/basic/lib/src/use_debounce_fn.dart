import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

/// A debounced function that delays invoking [fn] until after [delay] milliseconds
/// have elapsed since the last time the debounced function was invoked.
///
/// This hook is useful for implementing search-as-you-type, auto-save, and other
/// scenarios where you want to delay execution until the user has stopped typing.
///
/// **Type Safety Note**: This version accepts up to 10 dynamic arguments.
/// For better type safety, consider using [useDebounceFn1] for single-argument functions.
///
/// **Null Argument Handling**: Arguments that are `null` will be filtered out.
/// If your function needs to handle `null` values, use the typed variants instead.
///
/// Example:
/// ```dart
/// final search = useDebounceFn(
///   () => searchAPI(query), // Capture variables from closure for type safety
///   500, // 500ms delay
/// );
///
/// // Or for single arguments, use the type-safe version:
/// final searchTyped = useDebounceFn1<String>(
///   (String query) async => await searchAPI(query),
///   500,
/// );
/// ```
DebouncedFunction<T> useDebounceFn<T>(
  T Function() fn,
  int delay, {
  List<Object?> keys = const [],
  bool leading = false,
}) {
  final timer = useRef<Timer?>(null);
  final lastArgs = useRef<List<dynamic>>([]);
  final lastInvokeTime = useRef<DateTime?>(null);

  useEffect(
    () => () {
      timer.value?.cancel();
    },
    [],
  );

  final debounced = useCallback(
    () {
      final now = DateTime.now();
      final timeSinceLastInvoke = lastInvokeTime.value == null
          ? delay
          : now.difference(lastInvokeTime.value!).inMilliseconds;

      timer.value?.cancel();

      // If leading is true and enough time has passed, invoke immediately
      if (leading && timeSinceLastInvoke >= delay) {
        lastInvokeTime.value = now;
        Function.apply(fn, lastArgs.value);
      }

      timer.value = Timer(Duration(milliseconds: delay), () {
        lastInvokeTime.value = DateTime.now();
        Function.apply(fn, lastArgs.value);
      });
    },
    [...keys, delay, leading],
  );

  final debouncedFunction = useCallback(
    ([
      dynamic arg1,
      dynamic arg2,
      dynamic arg3,
      dynamic arg4,
      dynamic arg5,
      dynamic arg6,
      dynamic arg7,
      dynamic arg8,
      dynamic arg9,
      dynamic arg10,
    ]) {
      final args = [
        if (arg1 != null) arg1,
        if (arg2 != null) arg2,
        if (arg3 != null) arg3,
        if (arg4 != null) arg4,
        if (arg5 != null) arg5,
        if (arg6 != null) arg6,
        if (arg7 != null) arg7,
        if (arg8 != null) arg8,
        if (arg9 != null) arg9,
        if (arg10 != null) arg10,
      ];
      lastArgs.value = args;
      debounced();
    },
    [...keys, delay],
  );

  final cancel = useCallback(
    () {
      timer.value?.cancel();
    },
    [],
  );

  final flush = useCallback(
    () {
      timer.value?.cancel();
      Function.apply(fn, lastArgs.value);
    },
    [...keys],
  );

  return DebouncedFunction<T>(
    call: debouncedFunction,
    cancel: cancel,
    flush: flush,
    isPending: useCallback(() => timer.value?.isActive ?? false, []),
  );
}

/// A function that has been debounced.
class DebouncedFunction<T> {
  /// Creates a [DebouncedFunction].
  const DebouncedFunction({
    required this.call,
    required this.cancel,
    required this.flush,
    required this.isPending,
  });

  /// Calls the debounced function.
  final void Function([
    dynamic arg1,
    dynamic arg2,
    dynamic arg3,
    dynamic arg4,
    dynamic arg5,
    dynamic arg6,
    dynamic arg7,
    dynamic arg8,
    dynamic arg9,
    dynamic arg10,
  ]) call;

  /// Cancels any pending function invocations.
  final void Function() cancel;

  /// Immediately invokes any pending function call.
  final void Function() flush;

  /// Returns true if there is a pending function call.
  final bool Function() isPending;
}

/// A strongly-typed version of [useDebounceFn] for functions with specific signatures.
///
/// This provides better type safety at the cost of being less flexible.
/// Function callback with one argument.
typedef VoidCallback1<T> = void Function(T arg);

/// Function callback with two arguments.
typedef VoidCallback2<T1, T2> = void Function(T1 arg1, T2 arg2);

/// Function callback with three arguments.
typedef VoidCallback3<T1, T2, T3> = void Function(T1 arg1, T2 arg2, T3 arg3);

/// Creates a debounced function with a single argument.
DebouncedFunction1<T> useDebounceFn1<T>(
  VoidCallback1<T> fn,
  int delay, {
  List<Object?> keys = const [],
}) {
  final timer = useRef<Timer?>(null);
  final lastArg = useRef<T?>(null);

  useEffect(
    () => () {
      timer.value?.cancel();
    },
    [],
  );

  final call = useCallback<void Function(T)>(
    (arg) {
      timer.value?.cancel();
      lastArg.value = arg;

      timer.value = Timer(Duration(milliseconds: delay), () {
        fn(lastArg.value as T);
      });
    },
    [...keys, delay],
  );

  final cancel = useCallback(
    () {
      timer.value?.cancel();
    },
    [],
  );

  final flush = useCallback(
    () {
      timer.value?.cancel();
      fn(lastArg.value as T);
    },
    [...keys],
  );

  return DebouncedFunction1<T>(
    call: call,
    cancel: cancel,
    flush: flush,
    isPending: useCallback(() => timer.value?.isActive ?? false, []),
  );
}

/// A strongly-typed debounced function with a single argument.
class DebouncedFunction1<T> {
  /// Creates a [DebouncedFunction1].
  const DebouncedFunction1({
    required this.call,
    required this.cancel,
    required this.flush,
    required this.isPending,
  });

  /// Calls the debounced function.
  final void Function(T arg) call;

  /// Cancels any pending function invocations.
  final void Function() cancel;

  /// Immediately invokes any pending function call.
  final void Function() flush;

  /// Returns true if there is a pending function call.
  final bool Function() isPending;
}
