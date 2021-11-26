# `useCounter` and `useNumber`

Flutter state hook that tracks a numeric value.
`useNumber` is an alias for `useCounter`.

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
    
    final action = useCounter(1, min: 1, max: 10);

    return Wrap(
      children: [
        Text(
            "Counter: ${action.value} [min: ${action.min}, max: ${action.max}]"),
        ElevatedButton(
          child: const Text('inc()'),
          onPressed: () => action.inc(),
        ),
        ElevatedButton(
          child: const Text('inc(5)'),
          onPressed: () => action.inc(5),
        ),
        ElevatedButton(
          child: const Text('dec()'),
          onPressed: () => action.dec(),
        ),
        ElevatedButton(
          child: const Text('dec(5)'),
          onPressed: () => action.dec(5),
        ),
        ElevatedButton(
          child: const Text('set(100)'),
          onPressed: () => action.set(100),
        ),
        ElevatedButton(
          child: const Text('reset()'),
          onPressed: () => action.reset(),
        ),
        ElevatedButton(
          child: const Text('reset(5)'),
          onPressed: () => action.reset(5),
        ),
      ]
    );
  }
}
```
## Reference

- **`value`**_`: int`_ - current counter value;
- **`inc(int?)`** - increment current value;
- **`dec(int?)`** - decrement current value;
- **`set(int)`** - set arbitrary value;
- **`reset(int?)`** - as the `set`, but also will assign value by reference to the `initial` parameter;