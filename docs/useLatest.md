# `useLatest`

Flutter state hook that returns the latest state as described in the [React hooks FAQ](https://reactjs.org/docs/hooks-faq.html#why-am-i-seeing-stale-props-or-state-inside-my-function).

This is mostly useful to get access to the latest value of some props or state inside an asynchronous callback, instead of that value at the time the callback was created from.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)]((https://dartpad.dev/?id=2a76f5b16c2f27d11c023a140f38ce33&null_safety=true))

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final latestCount = useLatest(count.value);
    
    void handleClick() {
      Timer(const Duration(seconds: 2), () {
        debugPrint("Latest count value: ${latestCount}");
      });
    }

    return Column(
      children: [
        Text('You clicked ${count.value} times'),
        ElevatedButton(
          onPressed: () {
            count.value++;
          },
          child: const Text('Click me'),
        ),
        ElevatedButton(
          onPressed: () {
            handleClick();
          },
          child: const Text('Start timer'),
        ),
      ]
    );
  }
}
```

## Reference

```dart
ObjectRef<T> useLatest<T>(T value)
```
