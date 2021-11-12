import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/src/use_first_mount_state.dart';

/// Flutter effect hook that ignores the first invocation (e.g. on mount).
/// The signature is exactly the same as the useEffect hook.
void useUpdateEffect(VoidCallback? Function() effect, [List<Object?>? keys]) {
  final isFirstMount = useFirstMountState();

  useEffect(() {
    if (!isFirstMount) {
      return effect();
    }
  }, keys);
}
