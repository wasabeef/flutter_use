import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns a function that forces component to re-build when called.
VoidCallback useUpdate() {
  final attempt = useState(0);
  return () => attempt.value++;
}
