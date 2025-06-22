import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device accelerometer using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
AccelerometerState useAccelerometer() {
  final state = useRef(AccelerometerState(fetched: false));
  final accelerometerEventsChanged =
      useStream(useMemoized(() => accelerometerEvents));

  state.value = AccelerometerState(
    fetched: accelerometerEventsChanged.hasData,
    accelerometer: accelerometerEventsChanged.data,
  );

  return state.value;
}

/// State object containing current accelerometer sensor data.
///
/// This immutable class holds the latest accelerometer readings
/// from the device's motion sensors.
@immutable
class AccelerometerState {
  /// Creates an [AccelerometerState] with the provided sensor data.
  AccelerometerState({
    required this.fetched,
    AccelerometerEvent? accelerometer,
  }) : _accelerometer = accelerometer ?? AccelerometerEvent(0, 0, 0);

  /// Whether accelerometer data has been successfully fetched from sensors.
  final bool fetched;

  final AccelerometerEvent _accelerometer;

  /// The current accelerometer reading with x, y, z acceleration values.
  AccelerometerEvent get accelerometer => _accelerometer;
}
