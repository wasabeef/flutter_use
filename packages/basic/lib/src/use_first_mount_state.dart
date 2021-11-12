import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns true if component is just mounted (on first build) and
/// false otherwise.
bool useFirstMountState() {
  final isFirst = useRef(true);

  if (isFirst.value) {
    isFirst.value = false;

    return true;
  }

  return isFirst.value;
}
