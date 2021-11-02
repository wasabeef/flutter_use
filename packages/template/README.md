# `useTemplate`

** It's just a template files.**

## Installation
```yaml
dependencies:
  flutter_use_template: ^1.0.0
```

## Usage

```dart
class Counter extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useTemplate(0);

    return GestureDetector(
      onTap: () => count.value++,
      child: Text(count.value.toString()),
    );
  }
}
```