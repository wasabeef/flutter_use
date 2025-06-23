import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter lifecycle hook that calls mount and unmount callbacks when component
/// is mounted and unmounted, respectively.
/// For app lifecycle hooks, see flutter_hooks v0.18.1+ [useAppLifecycleState](ref link1) or [useOnAppLifecycleStateChange](ref link2)
/// [ref link1](https://pub.dartlang.org/documentation/flutter_hooks/latest/flutter_hooks/useAppLifecycleState.html)
/// [ref link2](https://pub.dartlang.org/documentation/flutter_hooks/latest/flutter_hooks/useOnAppLifecycleStateChange.html)
void useLifecycles({VoidCallback? mount, VoidCallback? unmount}) {
  useEffect(
    () {
      mount?.call();
      return () => unmount?.call();
    },
    const [],
  );
}
