# `useBuildsCount`

Tracks component's builds count including the first build.

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
    final buildsCount = useBuildsCount();
    final update = useUpdate();

    return Column(
      children: [
        Text("Builds count: $buildsCount"),
        ElevatedButton(
          onPressed: () => update(),
          child: const Text('Rebuild'),
        ),
      ]
    );
  }
}
```
