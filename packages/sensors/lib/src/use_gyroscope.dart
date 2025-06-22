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

/// State object containing current gyroscope sensor data.
///
/// This immutable class holds the latest gyroscope readings
/// from the device's motion sensors.
@immutable
class GyroscopeState {
  /// Creates a [GyroscopeState] with the provided sensor data.
  GyroscopeState({
    required this.fetched,
    GyroscopeEvent? gyroscope,
  }) : _gyroscope = gyroscope ?? GyroscopeEvent(0, 0, 0);

  /// Whether gyroscope data has been successfully fetched from sensors.
  final bool fetched;

  final GyroscopeEvent _gyroscope;

  /// The current gyroscope reading with x, y, z angular velocity values.
  GyroscopeEvent get gyroscope => _gyroscope;
}
