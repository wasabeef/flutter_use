# `useOrientation`

Tracks screen orientation of user's device.

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final orientation = useOrientation();

    return Container(
      child: Text("Orientation: $orientation"),
    );
  }
}
```
