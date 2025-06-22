import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks battery status using [battery_plus](ref link).
/// [ref link](https://pub.dev/packages/battery_plus)
UseBatteryState useBattery() {
  final state = useRef(const UseBatteryState(fetched: false));
  final battery = useMemoized(Battery.new);
  final batteryStateChanged = useStream(battery.onBatteryStateChanged);
  final batteryLevel = useFuture(battery.batteryLevel);
  final isInBatterySaveMode = useFuture(battery.isInBatterySaveMode);

  state.value = UseBatteryState(
    fetched: batteryStateChanged.hasData ||
        batteryLevel.hasData ||
        isInBatterySaveMode.hasData,
    batteryLevel: batteryLevel.data,
    isInBatterySaveMode: isInBatterySaveMode.data,
    batteryState: batteryStateChanged.data,
  );

  return state.value;
}

/// State object containing current battery information.
///
/// This immutable class holds all the battery-related data including
/// battery level, charging state, and power save mode status.
@immutable
class UseBatteryState {
  /// Creates a [UseBatteryState] with the provided battery information.
  const UseBatteryState({
    required this.fetched,
    int? batteryLevel,
    bool? isInBatterySaveMode,
    BatteryState? batteryState,
  })  : _batteryLevel = batteryLevel ?? 0,
        _isInBatterySaveMode = isInBatterySaveMode ?? false,
        _batteryState = batteryState ?? BatteryState.unknown;

  /// Whether battery data has been successfully fetched from the system.
  final bool fetched;

  final int _batteryLevel;

  /// The current battery level as a percentage (0-100).
  int get batteryLevel => _batteryLevel;

  final bool _isInBatterySaveMode;

  /// Whether the device is currently in battery save mode.
  bool get isInBatterySaveMode => _isInBatterySaveMode;

  final BatteryState _batteryState;

  /// The current charging state of the battery.
  BatteryState get batteryState => _batteryState;
}
