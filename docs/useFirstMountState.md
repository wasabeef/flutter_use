# `useFirstMountState`

Returns `true` if component is just mounted (on first build) and `false` otherwise.

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
