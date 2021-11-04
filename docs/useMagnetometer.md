# `useMagnetometer`

Tracks the state of device magnetometer.

## Installation

Required [sensors_plus](https://pub.dev/packages/sensors_plus).

```yaml
dependencies:
  sensors_plus:
  flutter_use_sensors: ^0.0.2
```

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final magnetometerState = useMagnetometer();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("magnetometer: ${magnetometerState.value.magnetometer}"),
          ],
        ),
      ),
    );
  }
}
```
## Reference

- **`fetched`**_`: bool`_ - whether device magnetometer state is fetched;
- **`magnetometer`**_`: MagnetometerEvent`_ - device magnetometer state changes.
  - **`x`** 
  - **`y`** 
  - **`z`** 