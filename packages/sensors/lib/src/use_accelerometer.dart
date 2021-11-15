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

@immutable
class AccelerometerState {
  AccelerometerState({
    required this.fetched,
    AccelerometerEvent? accelerometer,
  }) : _accelerometer = accelerometer ?? AccelerometerEvent(0, 0, 0);

  final bool fetched;

  final AccelerometerEvent _accelerometer;
  AccelerometerEvent get accelerometer => _accelerometer;
}
