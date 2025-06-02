# `useEffectOnce`

Flutter lifecycle hook that runs an effect only once.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=adec4d3a92f52bc8a40dc55ff330d2ab&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffectOnce(() {
      print('Running effect once on mount');
      return () {
        print('Running clean-up of effect on unmount');
      };
    });

    return Container();
  }
}
```
