# `useUserAccelerometer`

Tracks the state of device accelerometer with gravity removed.

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
    final userAccelerometerState = useUserAccelerometer();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "userAccelerometerState: ${userAccelerometerState.userAccelerometer}"),
          ],
        ),
      ),
    );
  }
}
```
## Reference

- **`fetched`**_`: bool`_ - whether device accelerometer with gravity removed state is fetched;
- **`userAccelerometer`**_`: UserAccelerometerEvent`_ - device accelerometer with gravity removed state changes.
  - **`x`** 
  - **`y`** 
  - **`z`** 