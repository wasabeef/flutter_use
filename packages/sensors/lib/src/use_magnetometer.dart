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

@immutable
class MagnetometerState {
  MagnetometerState({
    required this.fetched,
    MagnetometerEvent? magnetometer,
  }) : _magnetometer = magnetometer ?? MagnetometerEvent(0, 0, 0);

  final bool fetched;

  final MagnetometerEvent _magnetometer;
  MagnetometerEvent get magnetometer => _magnetometer;
}
