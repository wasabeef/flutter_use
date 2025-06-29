# `useThrottle`

Flutter state hook that throttles a value to update at most once per specified duration.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-throttle)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final input = useState("");
    final throttledValue = useThrottle(input.value, Duration(milliseconds: 500));

    return Column(
      children: [
        TextField(
          onChanged: (value) => input.value = value,
          decoration: InputDecoration(
            labelText: 'Type something...',
          ),
        ),
        Text("Input: ${input.value}"),
        Text("Throttled: $throttledValue"),
        Text("Updates at most once every 500ms"),
      ]
    );
  }
}
```

## Reference

- **Returns**_`: T`_ - the throttled value that updates at most once per duration;
- **`value`**_`: T`_ - the input value to throttle;
- **`duration`**_`: Duration`_ - the minimum time between updates;