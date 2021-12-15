# `useFutureRetry`

Uses `useFuture` with an additional retry method to easily retry/refresh the future function.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=ab910cc4170f5e8746229cc958ba845c&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useFutureRetry(Future.delayed(const Duration(seconds: 2), () {
      return 'Fetched :${DateTime.now()}';
    }));

    return Column(
      children: [
        state.snapshot.connectionState == ConnectionState.done
          ? Text('Value: ${state.snapshot.data}')
          : const Text('Loading...'),
        ElevatedButton(
          onPressed: () => state.retry(),
          child: const Text('Retry'),
        ),
      ]
    );
  }
}
```
