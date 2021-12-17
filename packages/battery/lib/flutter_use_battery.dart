import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks battery status using [battery_plus](ref link).
/// [ref link](https://pub.dev/packages/battery_plus)
UseBatteryState useBattery() {
  final state = useRef(const UseBatteryState(fetched: false));
  final battery = useMemoized(() => Battery());
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

@immutable
class UseBatteryState {
  const UseBatteryState({
    required this.fetched,
    int? batteryLevel,
    bool? isInBatterySaveMode,
    BatteryState? batteryState,
  })  : _batteryLevel = batteryLevel ?? 0,
        _isInBatterySaveMode = isInBatterySaveMode ?? false,
        _batteryState = batteryState ?? BatteryState.unknown;

  final bool fetched;

  final int _batteryLevel;
  int get batteryLevel => _batteryLevel;

  final bool _isInBatterySaveMode;
  bool get isInBatterySaveMode => _isInBatterySaveMode;

  final BatteryState _batteryState;
  BatteryState get batteryState => _batteryState;
}
