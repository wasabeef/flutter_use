# `useMount`

Flutter lifecycle hook that calls a function after the component is mounted. Use useLifecycles if you need both a mount and unmount function.

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
    useMount(() => debugPrint('MOUNTED'));

    return Container();
  }
}
```
