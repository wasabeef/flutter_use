# `useMount`

Flutter lifecycle hook that calls a function after the component is mounted. Use useLifecycles if you need both a mount and unmount function.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-mount)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useMount(() => debugPrint('MOUNTED'));

    return Container();
  }
}
```
