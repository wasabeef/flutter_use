import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device accelerometer using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
ValueNotifier<AccelerometerState> useAccelerometer() {
  final state = useState(AccelerometerState(fetched: false));
  final accelerometerEventsChanged = useStream(accelerometerEvents);

  final newState = AccelerometerState(
    fetched: accelerometerEventsChanged.hasData,
    accelerometer: accelerometerEventsChanged.data,
  );

  if (state.value != newState) {
    state.value = newState;
  }

  return state;
}

@immutable
class AccelerometerState {
  AccelerometerState({
    required this.fetched,
    AccelerometerEvent? accelerometer,
  }) : _accelerometer = accelerometer ?? AccelerometerEvent(0, 0, 0);

  final bool fetched;

  final AccelerometerEvent _accelerometer;
  AccelerometerEvent get accelerometer => _accelerometer;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccelerometerState &&
          runtimeType == other.runtimeType &&
          fetched == other.fetched &&
          _accelerometer.x == other._accelerometer.x &&
          _accelerometer.y == other._accelerometer.y &&
          _accelerometer.z == other._accelerometer.z;

  @override
  int get hashCode => fetched.hashCode ^ _accelerometer.hashCode;
}
