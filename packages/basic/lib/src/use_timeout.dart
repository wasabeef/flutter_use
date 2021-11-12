// ignore_for_file: file_names
import 'package:flutter_use/flutter_use.dart';

/// Re-builds the component after a specified duration.
/// Provides handles to cancel and/or reset the timeout.
TimeoutState useTimeout(Duration delay) {
  final update = useUpdate();
  return useTimeoutFn(update, delay);
}
