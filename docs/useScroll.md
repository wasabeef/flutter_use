# `useScroll`

Flutter state hook that tracks a widget's scroll position.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-scroll)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollState = useScroll();

    return Column(
      children: [
        Text("X: ${scrollState.x.toStringAsFixed(2)}"),
        Text("Y: ${scrollState.y.toStringAsFixed(2)}"),
        Expanded(
          child: ListView.builder(
            controller: scrollState.controller,
            itemCount: 100,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ]
    );
  }
}
```

## Reference

- **`x`**_`: double`_ - horizontal scroll position;
- **`y`**_`: double`_ - vertical scroll position;
- **`controller`**_`: ScrollController`_ - scroll controller to attach to scrollable widget;