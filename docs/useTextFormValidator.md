# `useTextFormValidator`

Each time given state changes - validator function is invoked.

## Installation

```yaml
dependencies:
  flutter_use: ^0.0.2
```

## Usage

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
