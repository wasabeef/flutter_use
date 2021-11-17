# `useSet`

Flutter state hook that tracks a Set.

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
