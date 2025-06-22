import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device accelerometer with gravity removed using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
UserAccelerometerState useUserAccelerometer() {
  final state = useRef(UserAccelerometerState(fetched: false));
  final userAccelerometerEventsChanged =
      useStream(useMemoized(() => userAccelerometerEvents));

  state.value = UserAccelerometerState(
    fetched: userAccelerometerEventsChanged.hasData,
    userAccelerometer: userAccelerometerEventsChanged.data,
  );

  return state.value;
}

/// State object containing current user accelerometer sensor data.
///
/// This immutable class holds the latest user accelerometer readings
/// from the device's motion sensors with gravity effects removed.
@immutable
class UserAccelerometerState {
  /// Creates a [UserAccelerometerState] with the provided sensor data.
  UserAccelerometerState({
    required this.fetched,
    UserAccelerometerEvent? userAccelerometer,
  }) : _userAccelerometer =
            userAccelerometer ?? UserAccelerometerEvent(0, 0, 0);

  /// Whether user accelerometer data has been successfully fetched from sensors.
  final bool fetched;

  final UserAccelerometerEvent _userAccelerometer;

  /// The current user accelerometer reading with gravity removed (x, y, z values).
  UserAccelerometerEvent get userAccelerometer => _userAccelerometer;
}
