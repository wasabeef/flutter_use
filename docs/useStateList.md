# `useStateList`

Provides handles for circular iteration over states list.
Supports forward and backward iterations and arbitrary position set.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=5761442418062838b04cbe21a36be586&null_safety=true)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {

    final list = ['first', 'second', 'third', 'fourth', 'fifth'];
    final stateList = useStateList(list);
    final stateAtController = useTextEditingController();
    final stateController = useTextEditingController();

    return Column(
      children: [
        Text(stateList.list.toString()),
        Text(
          "${stateList.list.isNotEmpty ? stateList.state : null} [index: ${stateList.currentIndex}]"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => stateList.prev(),
              child: const Text('prev')),
            ElevatedButton(
              onPressed: () => stateList.next(),
              child: const Text('next')),
          ],
        ),
        TextFormField(
          controller: stateAtController,
          decoration: const InputDecoration(
            labelText: 'set state by index',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            stateList.setStateAt(int.parse(stateAtController.text));
          },
          child: const Text('set state by index')),
        TextFormField(
          controller: stateController,
          decoration: const InputDecoration(
            labelText: 'set state by value',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            stateList.setState(stateController.text);
          },
          child: const Text('set state by value'),
        ),
      ],
    );
  }
}
```
## Reference

```dart
UseStateList<T> useStateList<T>([List<T> stateSet = const []])
```

If `stateSet` changed, became shorter than before and `currentIndex` left in shrunk gap - the last element of list will be taken as current.

- **`state`**_`: T`_ &mdash; current state value;
- **`currentIndex`**_`: int`_ &mdash; current state index;
- **`prev()`**_`: void`_ &mdash; switches state to the previous one. If first element selected it will switch to the last one;
- **`next()`**_`: void`_ &mdash; switches state to the next one. If last element selected it will switch to the first one;
- **`setStateAt(int newIndex)`**_`: void`_ &mdash; set the arbitrary state by index. Indexes are looped.  
_4ex:_ if list contains 5 elements, attempt to set index 9 will bring use to 5th element, in case of negative index it will set to the 0th.
- **`setState(T state)`**_`: void`_ &mdash; set the arbitrary state value that exists in `stateSet`. _In case new state does not exists in `stateSet` an Error will be thrown._