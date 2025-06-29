# `useCopyToClipboard`

Flutter state hook that provides functionality to copy text to the clipboard.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-copy-to-clipboard)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final copyToClipboard = useCopyToClipboard();

    return Column(
      children: [
        if (copyToClipboard.copied != null)
          Text("Copied: ${copyToClipboard.copied}"),
        if (copyToClipboard.error != null)
          Text("Error: ${copyToClipboard.error}"),
        ElevatedButton(
          onPressed: () {
            copyToClipboard.copy("Hello, World!");
          },
          child: const Text('Copy Text'),
        ),
        ElevatedButton(
          onPressed: () {
            copyToClipboard.copy("flutter_use is awesome!");
          },
          child: const Text('Copy Another Text'),
        ),
      ]
    );
  }
}
```

## Reference

- **`copied`**_`: String?`_ - the last successfully copied text;
- **`error`**_`: Object?`_ - error occurred during copying, if any;
- **`copy(String)`** - copies the given text to clipboard;