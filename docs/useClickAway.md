# `useClickAway`

Flutter state hook that detects clicks outside a target widget and calls a callback function.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-click-away)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final showDropdown = useState(false);
    final clickAway = useClickAway(() {
      showDropdown.value = false;
    });

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => showDropdown.value = !showDropdown.value,
          child: Text('Toggle Dropdown'),
        ),
        if (showDropdown.value)
          Container(
            key: clickAway.ref,
            width: 200,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Click outside to close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
      ]
    );
  }
}
```

## Reference

- **`ref`**_`: GlobalKey`_ - a global key to attach to the target widget;
- **`onClickAway`**_`: VoidCallback`_ - callback function called when clicking outside the target;