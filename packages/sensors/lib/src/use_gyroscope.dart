import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device gyroscope using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
GyroscopeState useGyroscope() {
  final state = useState(GyroscopeState(fetched: false));
  final gyroscopeEventsChanged = useStream(gyroscopeEvents);

  final newState = GyroscopeState(
    fetched: gyroscopeEventsChanged.hasData,
    gyroscope: gyroscopeEventsChanged.data,
  );

  if (state.value != newState) {
    state.value = newState;
  }

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GyroscopeState &&
          runtimeType == other.runtimeType &&
          fetched == other.fetched &&
          _gyroscope.x == other._gyroscope.x &&
          _gyroscope.y == other._gyroscope.y &&
          _gyroscope.z == other._gyroscope.z;

  @override
  int get hashCode => fetched.hashCode ^ _gyroscope.hashCode;
}
