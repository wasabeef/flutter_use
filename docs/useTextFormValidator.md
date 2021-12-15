# `useTextFormValidator`

Each time given state changes - validator function is invoked.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://dartpad.dev/?id=23dee1c153a8a9e455d463584537256e&null_safety=true)

```dart
class Sample extends HookWidget {

  // Email format.
  static final _regExp = RegExp(
    '[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}',
  );

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
   
    final validate = useTextFormValidator(
      validator: (value) => _regExp.hasMatch(value),
      controller: textController,
      initialValue: false,
    );

    return Column(
      children: [
        Text("isValid: $validate"),
        TextFormField(
          onChanged: (text) {
            debugPrint(text);
          },
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'wasabeef@github.com',
          ),
        ),
      ]
    );
  }
}
```
