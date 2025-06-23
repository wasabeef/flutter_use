import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A declarative interval hook based on [Dan Abramov's article](ref link).
///  The interval can be paused by setting the delay to `null`.
/// [ref link](https://overreacted.io/making-setinterval-declarative-with-react-hooks)
void useInterval(
  VoidCallback callback, [
  Duration? delay = const Duration(milliseconds: 100),
]) {
  final savedCallback = useRef<VoidCallback>(() => {});

  // ignore: body_might_complete_normally_nullable
  useEffect(() {
    savedCallback.value = callback;
  });

  // ignore: body_might_complete_normally_nullable
  useEffect(
    () {
      if (delay != null) {
        final timer = Timer.periodic(delay, (time) {
          savedCallback.value();
        });
        return timer.cancel;
      }
      return null;
    },
    [delay],
  );
}
