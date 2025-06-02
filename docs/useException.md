# `useException`

Flutter side-effect hook that returns an exception dispatcher.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=98580d1987dcae38ea0f27ee67a0d089&null_safety=true)

```dart
class SampleException extends Exception {}

class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dispatcherException = useException();

    if (dispatcherException.value is SampleException) {
      debugPrint('Exception');
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            dispatcherException.dispatch(SampleException());
          },
          child: const Text('Dispatch Exception'),
        ),
      ]
    );
  }
}
```
