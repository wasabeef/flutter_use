# `useFutureRetry`

Uses `useFuture` with an additional retry method to easily retry/refresh the future function.

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
