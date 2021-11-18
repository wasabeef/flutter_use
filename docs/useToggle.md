# `useEffectOnce`

Flutter state hook that tracks value of a boolean.
`useBoolean` is an alias for `useToggle`.

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
    final state = useToggle();

    return Column(
      children: [
        Text("toggle: ${state.value ? 'ON' : 'OFF'}"),
        ElevatedButton(
          onPressed: () {
            toggleState.toggle();
          },
          child: const Text('Toggle'),
        ),
        ElevatedButton(
          onPressed: () {
            toggleState.toggle(true);
          },
          child: const Text('set ON'),
        ),
        ElevatedButton(
          onPressed: () {
            toggleState.toggle(false);
          },
          child: const Text('set OFF'),
        ),
      ]
    );
  }
}
```
