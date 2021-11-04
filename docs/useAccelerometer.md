# `useAccelerometer`

Tracks the state of device accelerometer.

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
    final accelerometerState = useAccelerometer();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "accelerometerState: ${accelerometerState.value.accelerometer}"),
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