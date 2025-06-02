# `useUpdateEffect`

Flutter effect hook that ignores the first invocation (e.g. on mount). The signature is exactly the same as the `useEffect` hook.

## Installation

```yaml
dependencies:
  flutter_use:
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=724fee007fe78419fde61f185b83095b&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final buildsCount = useBuildsCount();
    final update = useUpdate();
    
    useUpdateEffect(() {
      debugPrint('count: $buildsCount'); // will only show 2 and beyond
      return () { // *OPTIONAL*
        // do something on unmount
      };
    }); // you can include deps array if necessary

    return Text('Count: $buildsCount');
  }
}
```
