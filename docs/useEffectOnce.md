# `useEffectOnce`

Flutter lifecycle hook that runs an effect only once.

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
    useEffectOnce(() {
      print('Running effect once on mount');
      return () {
        print('Running clean-up of effect on unmount');
      }
    });

    return Container();
  }
}
```
