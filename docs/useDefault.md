# `useDefault`

Flutter state hook that returns the default value when state is null or undefined.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)]((https://dartpad.dev/?id=6511219165b2e5c64ec8890b69633da6&null_safety=true))

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final initialUser = { 'name': 'Marshall' };
    final defaultUser = { 'name': 'Mathers' };

    final user = useDefault(defaultUser, initialUser);

    return Column(
      children: [
        Text('User: ${user.value['name']}'),
        TextFormField(
          onChanged: (text) {
            user.value = {'name': text};
          },
        ),
        ElevatedButton(
          onPressed: () {
            user.value = null;
          },
          child: const Text('set to null'),
        ),
      ]
    );
  }
}
```
