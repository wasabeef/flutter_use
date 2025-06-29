# `useBuildsCount`

Tracks component's builds count including the first build.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-builds-count)

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
