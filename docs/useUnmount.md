# `useUnmount`

Flutter lifecycle hook that calls a function when the component will unmount. Use useLifecycles if you need both a mount and unmount function.

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
    useUnmount(() => debugPrint('UNMOUNTED'));

    return Container();
  }
}
```
