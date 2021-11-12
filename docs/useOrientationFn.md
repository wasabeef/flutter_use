# `useOrientationFn`

Calls given function changed screen orientation of user's device.

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
