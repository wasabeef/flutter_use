# `useError`

Flutter side-effect hook that returns an error dispatcher.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=8e8e4876d546dd38517cb833ee694359&null_safety=true)

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
