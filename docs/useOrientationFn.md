# `useOrientationFn`

Calls given function changed screen orientation of user's device.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-orientation-fn)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useOrientationFn((orientation) {
      debugPrint('Orientation: $orientation');
    });

    return Container();
  }
}
```
