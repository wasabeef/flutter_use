import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Calls given function changed screen orientation of user's device.
void useOrientationFn(_OrientationCallback onStateChanged) {
  final context = useContext();
  use(
    _OrientationHook(
      MediaQuery.of(context).orientation,
      onStateChanged: onStateChanged,
    ),
  );
}

class _OrientationHook extends Hook<Orientation> {
  const _OrientationHook(
    this.currentValue, {
    this.onStateChanged,
  }) : super();

  final Orientation currentValue;
  final _OrientationCallback? onStateChanged;

  @override
  _OrientationState createState() => _OrientationState();
}

class _OrientationState extends HookState<Orientation, _OrientationHook>
    with
        // ignore: prefer_mixin
        WidgetsBindingObserver {
  late Orientation _state = hook.currentValue;

  @override
  void initHook() {
    super.initHook();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Orientation build(BuildContext context) {
    // `didChangeMetrics` is called before the orientation information is
    // updated, so handle it here.
    final orientation = MediaQuery.of(context).orientation;
    if (_state != orientation) {
      _state = orientation;
      hook.onStateChanged?.call(_state);
    }
    return _state;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }
}

typedef _OrientationCallback = void Function(
  Orientation orientation,
);
