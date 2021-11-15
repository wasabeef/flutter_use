# `useError`

Flutter side-effect hook that returns an error dispatcher.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

```dart
class SampleError extends Error {}

class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dispatcherError = useError();

    if (dispatcherError.value is SampleError) {
      debugPrint('Error');
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            dispatcherError.dispatch(SampleError());
          },
          child: const Text('Dispatch Error'),
        ),
      ]
    );
  }
}
```
