# `useFirstMountState`

Returns `true` if component is just mounted (on first build) and `false` otherwise.

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
    final isFirstMount = useFirstMountState();
    final update = useUpdate();

    return Column(
      children: [
        Text("This component is just mounted: ${isFirstMount ? 'YES' : 'NO'}"),
        ElevatedButton(
          onPressed: () => update(),
          child: const Text('Rebuild'),
        ),
      ]
    );
  }
}
```
