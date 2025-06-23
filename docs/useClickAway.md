# `useClickAway`

Flutter state hook that detects clicks outside a target widget and calls a callback function.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

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