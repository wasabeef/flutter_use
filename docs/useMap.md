# `useMap`

Flutter state hook that tracks a value of a Map.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=325b4737e78d40463fc0f3d3cc317b35&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {

    final mapState = useMap({'hello': 'there'});

    return Column(
      children: [
        Text('${mapState.map}'),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => mapState.add(DateTime.now().toString(),
                  '${DateTime.now().microsecondsSinceEpoch}'),
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () =>
                  mapState.addAll({'add': 'all', 'data': 'data'}),
              child: const Text('Add all'),
            ),
            ElevatedButton(
              onPressed: () =>
                  mapState.replace({'hello': 'new', 'data': 'data'}),
              child: const Text('Replace'),
            ),
            ElevatedButton(
              onPressed: () => mapState.remove('hello'),
              child: const Text("Remove 'hello'"),
            ),
            ElevatedButton(
              onPressed: () => mapState.reset(),
              child: const Text('Reset'),
            ),
          ],
        ),
      ]
    );
  }
}
```
