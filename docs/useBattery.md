# `useBattery`

Tracks battery status.

## Installation

Depends on [battery_plus](https://pub.dev/packages/battery_plus).

```yaml
dependencies:
  flutter_use_battery: 
```

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final battery = useBattery();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("-- Battery --"),
            Text("fetched: ${battery.fetched}"),
            Text("batteryState: ${battery.batteryState}"),
            Text("level: ${battery.batteryLevel}"),
            Text("isInBatterySaveMode: ${battery.isInBatterySaveMode}"),
          ],
        ),
      ),
    );
  }
}
```
## Reference

- **`fetched`**_`: bool`_ - whether battery state is fetched;
- **`batteryLevel`**_`: int`_ - representing the system's battery charge level to a value between 0 and 100.
- **`isInBatterySaveMode`**_`: bool`_ - check if device is on battery save mode.
- **`batteryState`**_`: BatteryState`_ - battery state changes.
  - **`full`** - The battery is completely full of energy.
  - **`charging`** -The battery is currently storing energy.
  - **`discharging`** - The battery is currently losing energy.
  - **`unknown`** - The state of the battery is unknown.