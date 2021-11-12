# `useBuildsCount`

Tracks component's builds count including the first build.

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
