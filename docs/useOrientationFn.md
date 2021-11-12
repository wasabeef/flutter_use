# `useOrientationFn`

Calls given function changed screen orientation of user's device.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

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
