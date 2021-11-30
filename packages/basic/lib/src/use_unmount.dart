import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

/// Flutter lifecycle hook that calls a function when the component will
/// unmount. Use useLifecycles if you need both a mount and unmount function.
void useUnmount(VoidCallback fn) {
  final fnRef = useRef(fn);

  // update the ref each build so if it change the newest callback will be invoked
  fnRef.value = fn;

  return useEffectOnce(() => () => fnRef.value());
}
