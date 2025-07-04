# `useEffectOnce`

Flutter lifecycle hook that runs an effect only once.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-effect-once)

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
