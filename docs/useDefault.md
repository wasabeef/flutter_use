# `useDefault`

Flutter state hook that returns the default value when state is null or undefined.

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
