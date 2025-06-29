# `useUnmount`

Flutter lifecycle hook that calls a function when the component will unmount. Use useLifecycles if you need both a mount and unmount function.

## Installation

```yaml
dependencies:
  flutter_use:
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-unmount)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useUnmount(() => debugPrint('UNMOUNTED'));

    return Container();
  }
}
```
