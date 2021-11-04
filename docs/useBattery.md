# `useAudio`

Tracks battery status.

## Installation

Required [battery_plus](https://pub.dev/packages/battery_plus).

```yaml
dependencies:
  battery_plus:
  flutter_use_battery: ^1.0.0
```

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final player = useAudio();
    return ElevatedButton(
      onPressed: () async {
        player.play();
        await player.seek(const Duration(seconds: 10));
        await player.pause();
      },
      child: const Text('Play'),
    );
  }
}
```
## Reference

- **`fetched`**_`: boo`_ - whether battery state is fetched;
- **`batteryLevel`**_`: int`_ - representing the system's battery charge level to a value between 0 and 100.
- **`isInBatterySaveMode`**_`: bool`_ - check if device is on battery save mode.
- **`batteryState`**_`: BatteryState`_ - battery state changes.
  - **`full`** - The battery is completely full of energy.
  - **`charging`** -The battery is currently storing energy.
  - **`discharging`** - The battery is currently losing energy.
  - **`unknown`** - The state of the battery is unknown.