# `useUpdateEffect`

Flutter effect hook that ignores the first invocation (e.g. on mount). The signature is exactly the same as the `useEffect` hook.

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
