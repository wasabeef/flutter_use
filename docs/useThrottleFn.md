# `useThrottleFn`

Flutter state hook that throttles a function to execute at most once per specified duration.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-throttle-fn)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    
    final throttledIncrement = useThrottleFn(
      () => counter.value++,
      Duration(milliseconds: 1000),
    );

    return Column(
      children: [
        Text("Counter: ${counter.value}"),
        ElevatedButton(
          onPressed: throttledIncrement,
          child: const Text('Increment (throttled)'),
        ),
        Text("Function executes at most once per second"),
      ]
    );
  }
}
```

## Reference

- **Returns**_`: VoidCallback`_ - the throttled function;
- **`fn`**_`: VoidCallback`_ - the function to throttle;
- **`duration`**_`: Duration`_ - the minimum time between function executions;