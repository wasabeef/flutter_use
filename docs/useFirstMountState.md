# `useFirstMountState`

Returns `true` if component is just mounted (on first build) and `false` otherwise.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=c9b6853d726ae29dcf902efcf7e85dc6&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isFirstMount = useFirstMountState();
    final update = useUpdate();

    return Column(
      children: [
        Text("This component is just mounted: ${isFirstMount ? 'YES' : 'NO'}"),
        ElevatedButton(
          onPressed: () => update(),
          child: const Text('Rebuild'),
        ),
      ]
    );
  }
}
```
