# `useUpdate`

Flutter utility hook that returns a function that forces component to re-build when called.

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
    final update = useUpdate();

    return Column(
      children: [
        Text("count: ${DateTime.now()}"),
        ElevatedButton(
          onPressed: () => update(),
          child: const Text("Button"),
        ),
      ]
    );
  }
}
```
