# `usePreviousDistinct`

Just like `usePrevious` but it will only update once the value actually changes. This is important when other hooks are involved and you aren't just interested in the previous props version, but want to know the previous distinct value

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=86e0e29f8198095dbd0d68a736c671bb&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {

    final count = useCounter(0);
    final unrelatedCount = useCounter(0);
    final prevCount = usePreviousDistinct(count.value);

    return Column(
      children: [
        Text("Now: ${count.value}, before: $prevCount"),
        ElevatedButton(
          onPressed: () => count.inc(),
          child: const Text('Increment'),
        ),
        Text("Unrelated: ${unrelatedCount.value}"),
        ElevatedButton(
          onPressed: () => unrelatedCount.inc(),
          child: const Text('Increment Unrelated'),
        ),
      ]
    );
  }
}
```

## Reference
```dart
T? usePreviousDistinct<T>(T value, [bool Function(T, T)? compare])
```
