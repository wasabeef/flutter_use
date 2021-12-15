# `useDebounce`

Flutter hook that delays invoking a function until after wait milliseconds have elapsed since the last time the debounced function was invoked.

The third argument is the array of values that the debounce depends on, in the same manner as useEffect. The debounce timeout will start when one of the values changes.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=977ee00fc30da8f0dd1888f6808114eb&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useState('Typing stopped');
    final inputValue = useState('');
    final bounceValue = useState('');
    
    useDebounce(() {
      state.value = 'Typing stopped';
      bounceValue.value = inputValue.value;
    }, const Duration(seconds: 1));

    return Column(
      children: [
        Text("Typing?: ${state.value}"),
        Text("Value: ${bounceValue.value}"),
        TextFormField(
          onChanged: (text) {
            state.value = 'Waiting for typing to stop...';
            inputValue.value = text;
            debugPrint(text);
          },
        ),
      ]
    );
  }
}
```
