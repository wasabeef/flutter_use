# `useScrolling`

Flutter state hook that tracks whether a widget is currently scrolling.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-scrolling)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollingState = useScrolling();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: scrollingState.isScrolling ? Colors.red : Colors.green,
          child: Text(
            scrollingState.isScrolling ? "Scrolling..." : "Not scrolling",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollingState.controller,
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

- **`isScrolling`**_`: bool`_ - whether the widget is currently scrolling;
- **`controller`**_`: ScrollController`_ - scroll controller to attach to scrollable widget;