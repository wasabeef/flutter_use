import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

/// Flutter hook that debounces a function call.
///
/// Delays the execution of a function until after the specified delay
/// has elapsed since the last time the function was scheduled to be called.
///
/// [fn] is the function to be debounced.
/// [delay] is the duration to wait before executing the function.
/// [keys] is an optional list of dependencies. The debounce timer resets
/// whenever any of these dependencies change, similar to useEffect.
///
/// Example:
/// ```dart
/// final searchController = TextEditingController();
///
/// useDebounce(() {
///   // This will only execute 500ms after the user stops typing
///   performSearch(searchController.text);
/// }, Duration(milliseconds: 500), [searchController.text]);
///
/// // Usage with a search field
/// TextField(
///   controller: searchController,
///   onChanged: (value) {
///     // The search will be debounced automatically
///   },
/// )
/// ```
///
/// See also: [useTimeoutFn] for the underlying timeout implementation.
void useDebounce(VoidCallback fn, Duration delay, [List<Object?>? keys]) {
  final timeout = useTimeoutFn(fn, delay);
  useEffect(() => timeout.reset, keys);
}
