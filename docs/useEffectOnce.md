# `useEffectOnce`

Flutter lifecycle hook that runs an effect only once.

## Usage

```dart
class Counter extends HookWidget {
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
