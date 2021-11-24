# `useList`

Tracks an array and provides methods to modify it.
To cause component re-build you have to use these methods instead of direct interaction with array - it won't cause re-build.

We can ensure that actions object and actions itself will not mutate or change between builds, so there is no need to add it to useEffect dependencies and safe to pass them down to children.

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

    final listState = useList([1, 2, 3, 4, 5]);

    return Column(
      children: [
        Text('${listState.list}'),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => listState.setAll(0, [6, 7, 8]),
              child: const Text('Set to [6, 7, 8] at index 0'),
            ),
            ElevatedButton(
              onPressed: () => listState.add(DateTime.now().millisecondsSinceEpoch),
              child: const Text('Push timestamp'),
            ),
            ElevatedButton(
              onPressed: () => listState.removeAt(1),
              child: const Text('Remove element at index 1'),
            ),
            ElevatedButton(
              onPressed: () => listState.sort((a, b) => a - b),
              child: const Text('Sort ascending'),
            ),
            ElevatedButton(
              onPressed: () => listState.sort((a, b) => b - a),
              child: const Text('Sort descending'),
            ),
            ElevatedButton(
              onPressed: () => listState.clear(),
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: () => listState.reset(),
              child: const Text('Reset'),
            ),
          ],
        ),
      ]
    );
  }
}
```
