# `useCustomCompareEffect`

A modified useEffect hook that accepts a comparator which is used for comparison on dependencies instead of reference equality.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
  collection: # If you use DeepCollectionEquality.
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=27146b5ca9189664e39ad4dfe9b08abe&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final countWithUseEffect = useState(0);
    final options = {'aa', 'bb', 'cc'};

    useCustomCompareEffect(
      () {
        count.value++;
      },
      [options],
      (prevKeys, nextKeys) {
        // If you use DeepCollectionEquality, need the `collection` package.
        return const DeepCollectionEquality().equals(prevKeys, nextKeys);
      },
    );
    
    useEffect(() {
      countWithUseEffect.value++;
    }, [options]);

    final update = useUpdate();

    return Column(
      children: [
        Text("useCustomCompareEffect with deep comparison: ${count.value}"),
        Text("useEffect: ${countWithUseEffect.value}"),
        ElevatedButton(
          child: const Text('Update'),
          onPressed: () => update(),
        ),
      ]
    );
  }
}
```
