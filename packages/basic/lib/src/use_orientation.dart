import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/src/use_orientation_fn.dart';

/// Tracks screen orientation of user's device.
Orientation useOrientation() {
  final context = useContext();
  final state = useRef(MediaQuery.of(context).orientation);
  useOrientationFn((orientation) {
    state.value = orientation;
  });
  return state.value;
}
