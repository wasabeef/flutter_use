# `useSet`

Flutter state hook that tracks a Set.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-set)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {

    final state = useSet({'hello'});

    return Column(
      children: [
        Text('${state.map}'),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => state.add(DateTime.now().toString()),
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () =>
              state.addAll({'add', 'all'}),
              child: const Text('Add all'),
            ),
            ElevatedButton(
              onPressed: () =>
              state.replace({'hello', 'new'}),
              child: const Text('Replace'),
            ),
            ElevatedButton(
              onPressed: () => state.toggle('hello'),
              child: const Text("Toggle 'hello'"),
            ),
            ElevatedButton(
              onPressed: () => state.remove('hello'),
              child: const Text("Remove 'hello'"),
            ),
            ElevatedButton(
              onPressed: () => state.reset(),
              child: const Text('Reset'),
            ),
          ],
        ),
      ]
    );
  }
}
```
