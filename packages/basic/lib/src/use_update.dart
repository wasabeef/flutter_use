import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that provides a function to force component re-builds.
///
/// This hook returns a callback function that, when called, forces the component
/// to rebuild. This is useful in scenarios where you need to trigger a rebuild
/// without changing any specific state value.
///
/// Returns a [VoidCallback] function that forces a rebuild when called.
///
/// Example:
/// ```dart
/// final forceUpdate = useUpdate();
///
/// // Call this to force a rebuild
/// void handleRefresh() {
///   // Do some non-reactive operations
///   cache.clear();
///
///   // Force rebuild to reflect changes
///   forceUpdate();
/// }
///
/// // Use in a button
/// ElevatedButton(
///   onPressed: forceUpdate,
///   child: Text('Refresh'),
/// )
/// ```
///
/// Note: This should be used sparingly. Most of the time, reactive state
/// management with other hooks like `useState` is preferred.
VoidCallback useUpdate() {
  final attempt = useState(0);
  return () => attempt.value++;
}
