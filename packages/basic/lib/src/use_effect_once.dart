import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A modified [useEffect](ref link) hook that only runs once.
/// [ref link](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useEffect.html)
void useEffectOnce(VoidCallback? Function() effect) {
  return useEffect(effect, const []);
}
