# `useGyroscope`

Tracks the state of device gyroscope.

## Installation

Depends on [sensors_plus](https://pub.dev/packages/sensors_plus).

```yaml
dependencies:
  flutter_use_sensors: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-gyroscope)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final gyroscopeState = useGyroscope();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("gyroscope: ${gyroscopeState.gyroscope}"),
          ],
        ),
      ),
    );
  }
}
```
## Reference

- **`fetched`**_`: bool`_ - whether device gyroscope state is fetched;
- **`gyroscope`**_`: GyroscopeEvent`_ - device gyroscope state changes.
  - **`x`** 
  - **`y`** 
  - **`z`** 