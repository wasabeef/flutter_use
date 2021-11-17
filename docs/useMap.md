# `useMap`

Flutter state hook that tracks a value of an object.

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
