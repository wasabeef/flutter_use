# `useInterval`

A declarative interval hook based on [Dan Abramov's article on overreacted.io](https://overreacted.io/making-setinterval-declarative-with-react-hooks). The interval can be paused by setting the delay to `null`.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-interval)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final delay = useState(const Duration(milliseconds: 300));
    final isRunning = useState(true);
    useInterval(
      () => count.value++,
      isRunning.value ? delay.value : null,
    );

    return Column(
      children: [
        Text("count: ${count.value}"),
        ElevatedButton(
          onPressed: () {
            isRunning.value = !isRunning.value;
          },
          child: const Text("Button"),
        ),
      ]
    );
  }
}
```
