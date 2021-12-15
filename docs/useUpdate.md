# `useUpdate`

Flutter utility hook that returns a function that forces component to re-build when called.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)]((https://dartpad.dev/?id=27a74d481219749f532776a8e73f3464&null_safety=true))

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final update = useUpdate();

    return Column(
      children: [
        Text("Now: ${DateTime.now()}"),
        ElevatedButton(
          onPressed: () => update(),
          child: const Text("Update"),
        ),
      ]
    );
  }
}
```
