# `useLifecycles`

Flutter lifecycle hook that call `mount` and `unmount` callbacks, when component is mounted and un-mounted, respectively.  
If you want to use hook that app lifecycles, recommended use to flutter_hooks v0.18.1+ [useAppLifecycleState](https://pub.dartlang.org/documentation/flutter_hooks/latest/flutter_hooks/useAppLifecycleState.html) or [useOnAppLifecycleStateChange](https://pub.dartlang.org/documentation/flutter_hooks/latest/flutter_hooks/useOnAppLifecycleStateChange.html)

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useLifecycles(
      mount: () {
        debugPrint('mounted');
      },
      unmount: () {
        debugPrint('unmounted');
      },
    );
    return Container();
  }
}
```
