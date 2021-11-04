import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks battery status using [battery_plus](ref link).
/// [ref link](https://pub.dev/packages/battery_plus)
ValueNotifier<UseBatteryState> useBattery() {
  final state = useState(const UseBatteryState(fetched: false));
  final battery = useMemoized(() => Battery());
  final batteryStateChanged = useStream(battery.onBatteryStateChanged);
  final batteryLevel = useFuture(battery.batteryLevel);
  final isInBatterySaveMode = useFuture(battery.isInBatterySaveMode);

  final newState = UseBatteryState(
    fetched: batteryStateChanged.hasData ||
        batteryLevel.hasData ||
        isInBatterySaveMode.hasData,
    batteryLevel: batteryLevel.data,
    isInBatterySaveMode: isInBatterySaveMode.data,
    batteryState: batteryStateChanged.data,
  );

  if (state.value != newState) {
    state.value = newState;
  }

  return state;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UseBatteryState &&
          fetched == other.fetched &&
          _batteryLevel == other._batteryLevel &&
          _isInBatterySaveMode == other._isInBatterySaveMode &&
          _batteryState == other._batteryState;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      fetched.hashCode ^
      _batteryLevel.hashCode ^
      _isInBatterySaveMode.hashCode ^
      _batteryState.hashCode;
}
