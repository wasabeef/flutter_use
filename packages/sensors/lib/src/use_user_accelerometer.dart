import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Tracks the state of device accelerometer with gravity removed using [sensors_plus](ref link).
/// [ref link](https://pub.dev/packages/sensors_plus)
ValueNotifier<UserAccelerometerState> useUserAccelerometer() {
  final state = useState(UserAccelerometerState(fetched: false));
  final userAccelerometerEventsChanged = useStream(userAccelerometerEvents);

  final newState = UserAccelerometerState(
    fetched: userAccelerometerEventsChanged.hasData,
    userAccelerometer: userAccelerometerEventsChanged.data,
  );

  if (state.value != newState) {
    state.value = newState;
  }

  return state;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccelerometerState &&
          runtimeType == other.runtimeType &&
          fetched == other.fetched &&
          _userAccelerometer.x == other._userAccelerometer.x &&
          _userAccelerometer.y == other._userAccelerometer.y &&
          _userAccelerometer.z == other._userAccelerometer.z;

  @override
  int get hashCode => fetched.hashCode ^ _userAccelerometer.hashCode;
}
