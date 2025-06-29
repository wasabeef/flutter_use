# `useBoolean` and `useToggle`

Flutter state hook that tracks value of a boolean.
`useBoolean` is an alias for `useToggle`.

## Installation

```yaml
dependencies:
  flutter_use:
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-toggle)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final toggleState = useToggle();

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
