# `useAccelerometer`

Tracks the state of device accelerometer.

## Installation

Depends on [sensors_plus](https://pub.dev/packages/sensors_plus).

```yaml
dependencies:
  flutter_use_sensors: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-accelerometer)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final accelerometerState = useAccelerometer();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "accelerometerState: ${accelerometerState.accelerometer}"),
          ],
        ),
      ),
    );
  }
}
```
## Reference

- **`fetched`**_`: bool`_ - whether device accelerometer state is fetched;
- **`accelerometer`**_`: AccelerometerEvent`_ - device accelerometer state changes.
  - **`x`** 
  - **`y`** 
  - **`z`** 