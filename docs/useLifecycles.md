# `useLifecycles`

Flutter lifecycle hook that call `mount` and `unmount` callbacks, when component is mounted and un-mounted, respectively.  
If you want to use hook that app lifecycles, recommended use to flutter_hooks v0.18.1+ [useAppLifecycleState](https://pub.dartlang.org/documentation/flutter_hooks/latest/flutter_hooks/useAppLifecycleState.html) or [useOnAppLifecycleStateChange](https://pub.dartlang.org/documentation/flutter_hooks/latest/flutter_hooks/useOnAppLifecycleStateChange.html)

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-lifecycles)

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
