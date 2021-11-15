import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device gyroscope using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
GyroscopeState useGyroscope() {
  final state = useRef(GyroscopeState(fetched: false));
  final gyroscopeEventsChanged = useStream(useMemoized(() => gyroscopeEvents));

  state.value = GyroscopeState(
    fetched: gyroscopeEventsChanged.hasData,
    gyroscope: gyroscopeEventsChanged.data,
  );

  return state.value;
}

@immutable
class GyroscopeState {
  GyroscopeState({
    required this.fetched,
    GyroscopeEvent? gyroscope,
  }) : _gyroscope = gyroscope ?? GyroscopeEvent(0, 0, 0);

  final bool fetched;

  final GyroscopeEvent _gyroscope;
  GyroscopeEvent get gyroscope => _gyroscope;
}
