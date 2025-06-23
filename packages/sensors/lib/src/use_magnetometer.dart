import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device magnetometer using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
MagnetometerState useMagnetometer() {
  final state = useRef(MagnetometerState(fetched: false));
  final magnetometerEventsChanged =
      useStream(useMemoized(() => magnetometerEvents));

  state.value = MagnetometerState(
    fetched: magnetometerEventsChanged.hasData,
    magnetometer: magnetometerEventsChanged.data,
  );

  return state.value;
}

/// State object containing current magnetometer sensor data.
///
/// This immutable class holds the latest magnetometer readings
/// from the device's magnetic field sensors.
@immutable
class MagnetometerState {
  /// Creates a [MagnetometerState] with the provided sensor data.
  MagnetometerState({
    required this.fetched,
    MagnetometerEvent? magnetometer,
  }) : _magnetometer = magnetometer ?? MagnetometerEvent(0, 0, 0);

  /// Whether magnetometer data has been successfully fetched from sensors.
  final bool fetched;

  final MagnetometerEvent _magnetometer;

  /// The current magnetometer reading with x, y, z magnetic field values.
  MagnetometerEvent get magnetometer => _magnetometer;
}
