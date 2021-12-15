# `useBuildsCount`

Tracks component's builds count including the first build.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)]((https://dartpad.dev/?id=d54979d95910abd48054547202e20c12&null_safety=true))

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
