# useAsync

A hook that manages the state of an asynchronous operation with loading, data, and error states.

## Usage

```dart
import 'package:flutter_use/flutter_use.dart';

class UserProfile extends HookWidget {
  final String userId;
  
  const UserProfile({required this.userId});
  
  @override
  Widget build(BuildContext context) {
    final userState = useAsync(
      () => fetchUserData(userId),
      keys: [userId], // Re-fetch when userId changes
    );
    
    if (userState.loading) {
      return const CircularProgressIndicator();
    }
    
    if (userState.hasError) {
      return Text('Error: ${userState.error}');
    }
    
    if (userState.hasData) {
      return UserCard(user: userState.data!);
    }
    
    return const SizedBox();
  }
}
```

## useAsyncFn

A variant that doesn't execute automatically and provides manual control:

```dart
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
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
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

### useAsync

```dart
AsyncState<T> useAsync<T>(
  Future<T> Function() asyncFunction, {
  List<Object?> keys = const [],
})
```

**Parameters:**
- `asyncFunction`: The async function to execute
- `keys`: Dependencies that trigger re-execution when changed

**Returns:** `AsyncState<T>` with:
- `loading`: Whether the operation is in progress
- `data`: The result data if successful
- `error`: The error if failed
- `hasData`: Whether data is available
- `hasError`: Whether an error occurred

### useAsyncFn

```dart
AsyncAction<T> useAsyncFn<T>(
  Future<T> Function() asyncFunction,
)
```

**Parameters:**
- `asyncFunction`: The async function to execute on demand

**Returns:** `AsyncAction<T>` with:
- All properties from `AsyncState<T>`
- `execute()`: Function to trigger the async operation

## Features

- Automatic loading state management
- Error handling
- Dependency tracking for re-execution
- Cancellation of previous operations
- Type-safe data handling
- Manual execution control with `useAsyncFn`

## Common Use Cases

1. **API Data Fetching**
   ```dart
   final productsState = useAsync(() => api.getProducts());
   ```

2. **User Authentication**
   ```dart
   final authAction = useAsyncFn(() => auth.signIn(credentials));
   ```

3. **File Operations**
   ```dart
   final fileState = useAsync(() => loadFileContent(path));
   ```

4. **Real-time Data**
   ```dart
   final liveData = useAsync(
     () => streamToFuture(dataStream),
     keys: [refreshTrigger],
   );
   ```