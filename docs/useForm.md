# useForm

A comprehensive form state management hook with validation, submission handling, and field management.

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-form)

```dart
import 'package:flutter_use/flutter_use.dart';

class LoginForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final emailField = useField<String>(
      initialValue: '',
      validators: [
        Validators.required(),
        Validators.email(),
      ],
    );
    
    final passwordField = useField<String>(
      initialValue: '',
      validators: [
        Validators.required(),
        Validators.minLength(8),
      ],
    );
    
    final form = useForm({
      'email': emailField,
      'password': passwordField,
    });
    
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailField.controller,
            focusNode: emailField.focusNode,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: emailField.showError ? emailField.error : null,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordField.controller,
            focusNode: passwordField.focusNode,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: passwordField.showError ? passwordField.error : null,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: form.isValid && !form.isSubmitting
                ? () => form.submit((values) async {
                    await authService.login(
                      values['email'],
                      values['password'],
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  })
                : null,
            child: form.isSubmitting
                ? const CircularProgressIndicator()
                : const Text('Login'),
          ),
          if (form.submitError != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                form.submitError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
```

## Built-in Validators

```dart
class RegistrationForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final form = useForm({
      'username': useField<String>(
        validators: [
          Validators.required('Username is required'),
          Validators.minLength(3, 'At least 3 characters'),
          Validators.maxLength(20, 'At most 20 characters'),
          Validators.pattern(
            RegExp(r'^[a-zA-Z0-9_]+$'),
            'Only letters, numbers, and underscores',
          ),
        ],
      ),
      'email': useField<String>(
        validators: [
          Validators.required(),
          Validators.email('Invalid email format'),
        ],
      ),
      'age': useField<int>(
        validators: [
          Validators.required(),
          Validators.range(18, 120, 'Must be 18 or older'),
        ],
      ),
      'password': useField<String>(
        validators: [
          Validators.required(),
          Validators.minLength(8),
          // Custom validator
          (value) {
            if (value != null && !value.contains(RegExp(r'[0-9]'))) {
              return 'Password must contain at least one number';
            }
            return null;
          },
        ],
      ),
    });
    
    // Form UI...
  }
}
```

## API

### useField

```dart
FieldState<T> useField<T>({
  T? initialValue,
  List<FieldValidator<T>> validators = const [],
  bool validateOnChange = false,
})
```

**Parameters:**
- `initialValue`: Initial field value
- `validators`: List of validation functions
- `validateOnChange`: Validate on every change (after touched)

**Returns:** `FieldState<T>` with:
- `value`: Current value
- `error`: Validation error message
- `touched`: Whether field has been focused
- `setValue(T?)`: Update value
- `setError(String?)`: Set error manually
- `setTouched(bool)`: Mark as touched
- `validate()`: Run validation
- `reset()`: Reset to initial state
- `controller`: TextEditingController (for String fields)
- `focusNode`: FocusNode for the field
- `isValid`: Whether field is valid
- `showError`: Whether to display error (touched && error)

### useForm

```dart
FormState useForm(Map<String, FieldState> fields)
```

**Parameters:**
- `fields`: Map of field names to field states

**Returns:** `FormState` with:
- `fields`: Map of all fields
- `isValid`: Whether all fields are valid
- `isDirty`: Whether any field has changed
- `isSubmitting`: Whether form is being submitted
- `submitError`: Error from submission
- `values`: Current form values
- `errors`: Current field errors
- `validate()`: Validate all fields
- `submit(Function)`: Submit with handler
- `reset()`: Reset all fields

### Validators

Built-in validators:
- `Validators.required<T>([message])`: Non-empty validation
- `Validators.email([message])`: Email format validation
- `Validators.minLength(length, [message])`: Minimum length
- `Validators.maxLength(length, [message])`: Maximum length
- `Validators.pattern(regex, [message])`: Pattern matching
- `Validators.range(min, max, [message])`: Number range

## Features

- Comprehensive field state management
- Built-in and custom validators
- Automatic TextEditingController for text fields
- Focus management
- Touch state tracking
- Form-level validation
- Async submission handling
- Error state management
- Field reset functionality
- Compose multiple validators

## Common Use Cases

1. **User Registration**
   ```dart
   final form = useForm({
     'email': useField(validators: [Validators.required(), Validators.email()]),
     'password': useField(validators: [Validators.required(), Validators.minLength(8)]),
     'confirmPassword': useField(validators: [
       Validators.required(),
       (value) => value != passwordField.value ? 'Passwords must match' : null,
     ]),
   });
   ```

2. **Profile Settings**
   ```dart
   final form = useForm({
     'displayName': useField(initialValue: user.name),
     'bio': useField(initialValue: user.bio, validators: [Validators.maxLength(200)]),
     'website': useField(validators: [urlValidator]),
   });
   ```

3. **Multi-step Forms**
   ```dart
   final step1 = useForm({...});
   final step2 = useForm({...});
   final currentStep = useState(0);
   ```

## Advanced Example

```dart
class CompleteFormExample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Custom async validator
    final checkUsernameAvailable = useCallback((String? username) async {
      if (username == null || username.isEmpty) return null;
      final isAvailable = await api.checkUsername(username);
      return isAvailable ? null : 'Username already taken';
    }, []);
    
    final usernameField = useField<String>(
      validators: [
        Validators.required(),
        Validators.pattern(RegExp(r'^[a-zA-Z0-9_]+$')),
      ],
    );
    
    final emailField = useField<String>(
      validators: [Validators.required(), Validators.email()],
      validateOnChange: true,
    );
    
    final passwordField = useField<String>(
      validators: [
        Validators.required(),
        Validators.minLength(8),
        (value) {
          if (value == null) return null;
          final hasUpper = value.contains(RegExp(r'[A-Z]'));
          final hasLower = value.contains(RegExp(r'[a-z]'));
          final hasDigit = value.contains(RegExp(r'[0-9]'));
          final hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
          
          if (!hasUpper || !hasLower || !hasDigit || !hasSpecial) {
            return 'Password must contain uppercase, lowercase, number, and special character';
          }
          return null;
        },
      ],
    );
    
    final form = useForm({
      'username': usernameField,
      'email': emailField,
      'password': passwordField,
    });
    
    // Async username validation
    useEffect(() {
      Timer? timer;
      if (usernameField.value?.isNotEmpty ?? false) {
        timer = Timer(const Duration(milliseconds: 500), () async {
          final error = await checkUsernameAvailable(usernameField.value);
          usernameField.setError(error);
        });
      }
      return timer?.cancel;
    }, [usernameField.value]);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: usernameField.controller,
              focusNode: usernameField.focusNode,
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: usernameField.showError ? usernameField.error : null,
                suffixIcon: usernameField.value?.isNotEmpty ?? false
                    ? usernameField.error == null
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailField.controller,
              focusNode: emailField.focusNode,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailField.showError ? emailField.error : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordField.controller,
              focusNode: passwordField.focusNode,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: passwordField.showError ? passwordField.error : null,
                helperText: 'Min 8 chars with upper, lower, number, special',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: form.reset,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: form.isValid && !form.isSubmitting
                        ? () => form.submit((values) async {
                            await api.createAccount(values);
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, '/welcome');
                            }
                          })
                        : null,
                    child: form.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```