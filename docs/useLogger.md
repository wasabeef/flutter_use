# `useLogger`

Flutter lifecycle hook that console logs parameters as component transitions through lifecycles.

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=c72c9ab0fa46f93dd266f6557a29a3ed&null_safety=true)

```dart
class Sample extends HookWidget {
  const Sample(this.user, {Key? key}) : super(key: key);

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {

    useLogger('Sample', props: user);

    return Container();
  }
}
```
## Example Output

```
Sample mounted {}
Sample updated {}
Sample unmounted
```

## Reference

```dart
useLogger(componentName: string, props: map);
```

- **`componentName`**_`: String`_ -  component name.
- **`props`**_`: Map<String, dynamic>`_ - parameters to log.