# `useMount`

Flutter lifecycle hook that calls a function after the component is mounted. Use useLifecycles if you need both a mount and unmount function.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=aa25e9bc3913779fcc795bef2bdc8d39&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useMount(() => debugPrint('MOUNTED'));

    return Container();
  }
}
```
