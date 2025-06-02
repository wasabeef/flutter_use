# `useUserAccelerometer`

Tracks the state of device accelerometer with gravity removed.

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