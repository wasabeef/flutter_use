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

@immutable
class UserAccelerometerState {
  UserAccelerometerState({
    required this.fetched,
    UserAccelerometerEvent? userAccelerometer,
  }) : _userAccelerometer =
            userAccelerometer ?? UserAccelerometerEvent(0, 0, 0);

  final bool fetched;

  final UserAccelerometerEvent _userAccelerometer;
  UserAccelerometerEvent get userAccelerometer => _userAccelerometer;
}
