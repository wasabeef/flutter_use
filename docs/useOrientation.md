# `useOrientation`

Tracks screen orientation of user's device.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-orientation)

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
