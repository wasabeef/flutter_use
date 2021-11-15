# `useException`

Flutter side-effect hook that returns an exception dispatcher.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

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
