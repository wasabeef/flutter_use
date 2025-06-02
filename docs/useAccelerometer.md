# `useAccelerometer`

Tracks the state of device accelerometer.

## Installation

Depends on [sensors_plus](https://pub.dev/packages/sensors_plus).

```yaml
dependencies:
  flutter_use_sensors: 
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