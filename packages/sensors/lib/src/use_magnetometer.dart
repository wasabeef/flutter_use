import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device magnetometer using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
MagnetometerState useMagnetometer() {
  final state = useState(MagnetometerState(fetched: false));
  final magnetometerEventsChanged = useStream(magnetometerEvents);

  final newState = MagnetometerState(
    fetched: magnetometerEventsChanged.hasData,
    magnetometer: magnetometerEventsChanged.data,
  );

  if (state.value != newState) {
    state.value = newState;
  }

  return state.value;
}

@immutable
class MagnetometerState {
  MagnetometerState({
    required this.fetched,
    MagnetometerEvent? magnetometer,
  }) : _magnetometer = magnetometer ?? MagnetometerEvent(0, 0, 0);

  final bool fetched;

  final MagnetometerEvent _magnetometer;
  MagnetometerEvent get magnetometer => _magnetometer;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagnetometerState &&
          runtimeType == other.runtimeType &&
          fetched == other.fetched &&
          _magnetometer.x == other._magnetometer.x &&
          _magnetometer.y == other._magnetometer.y &&
          _magnetometer.z == other._magnetometer.z;

  @override
  int get hashCode => fetched.hashCode ^ _magnetometer.hashCode;
}
