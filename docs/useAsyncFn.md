# useAsyncFn

A hook that manages the state of an asynchronous function with manual execution control, ideal for user-triggered operations like form submissions and API calls.

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-async-fn)

```dart
import 'package:flutter_use/flutter_use.dart';

class LoginForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final loginAction = useAsyncFn(() async {
      return await authService.login(email, password);
    });
    
    return Column(
      children: [
        // Form fields...
        ElevatedButton(
          onPressed: loginAction.loading 
              ? null 
              : () async {
                  try {
                    final user = await loginAction.execute();
                    // Handle successful login
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    // Handle login error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: $e')),
                    );
                  }
                },
          child: loginAction.loading
              ? const CircularProgressIndicator()
              : const Text('Login'),
        ),
      ],
    );
  }
}
```

## API

### Parameters

- `asyncFunction`: The asynchronous function to be executed manually when `execute()` is called

### Returns

An `AsyncAction<T>` object with the following properties:

- `loading`: Whether the async operation is currently in progress
- `data`: The result if the operation completed successfully  
- `error`: Any error that occurred during execution
- `execute()`: Method to trigger the async operation
- `hasData`: Whether the operation has completed successfully
- `hasError`: Whether the operation has failed

## Examples

### Basic Form Submission

```dart
class SubmitForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final submitAction = useAsyncFn(() async {
      return await api.submitForm(formData);
    });
    
    return ElevatedButton(
      onPressed: submitAction.loading ? null : () async {
        await submitAction.execute();
      },
      child: submitAction.loading 
          ? const CircularProgressIndicator()
          : const Text('Submit'),
    );
  }
}
```

### Conditional Execution

```dart
class ConditionalSubmit extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final submitAction = useAsyncFn(() async {
      return await api.submitForm(formData);
    });
    
    return ElevatedButton(
      onPressed: (formIsValid && !submitAction.loading) 
          ? () async {
              await submitAction.execute();
            }
          : null,
      child: const Text('Submit'),
    );
  }
}
```

### Error Handling

```dart
class ErrorHandlingExample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dataAction = useAsyncFn(() async {
      return await riskyApiCall();
    });
    
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              await dataAction.execute();
            } catch (e) {
              // Handle error
              showErrorDialog(context, e.toString());
            }
          },
          child: const Text('Load Data'),
        ),
        if (dataAction.hasError)
          Text('Error: ${dataAction.error}'),
        if (dataAction.hasData)
          Text('Success: ${dataAction.data}'),
      ],
    );
  }
}
```

### Multiple Operations

```dart
class MultipleActions extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final saveAction = useAsyncFn(() async {
      return await api.saveData(data);
    });
    
    final deleteAction = useAsyncFn(() async {
      return await api.deleteData(id);
    });
    
    return Row(
      children: [
        ElevatedButton(
          onPressed: saveAction.loading ? null : () async {
            await saveAction.execute();
          },
          child: saveAction.loading 
              ? const CircularProgressIndicator()
              : const Text('Save'),
        ),
        ElevatedButton(
          onPressed: deleteAction.loading ? null : () async {
            await deleteAction.execute();
          },
          child: deleteAction.loading
              ? const CircularProgressIndicator() 
              : const Text('Delete'),
        ),
      ],
    );
  }
}
```

## Comparison with useAsync

| Feature | useAsync | useAsyncFn |
|---------|----------|------------|
| Execution | Automatic on mount/dependency change | Manual via `execute()` |
| Use Case | Data fetching, auto-updates | Form submission, user actions |
| Control | Reactive to dependencies | Imperative control |
| State | `AsyncState<T>` | `AsyncAction<T>` |

## When to Use

- ✅ Form submissions
- ✅ Button-triggered API calls  
- ✅ User-initiated operations
- ✅ Operations that need manual timing control
- ❌ Data fetching that should happen automatically
- ❌ Operations that should react to state changes

## See Also

- [useAsync](./useAsync.md) - For automatically executed async operations
- [useForm](./useForm.md) - For comprehensive form management