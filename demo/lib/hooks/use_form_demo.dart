import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseFormDemo extends HookWidget {
  const UseFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo 1: Login Form
    final emailField = useField<String>(
      initialValue: '',
      validators: [
        Validators.required('Email is required'),
        Validators.email('Please enter a valid email'),
      ],
    );

    final passwordField = useField<String>(
      initialValue: '',
      validators: [
        Validators.required('Password is required'),
        Validators.minLength(8, 'Password must be at least 8 characters'),
      ],
    );

    final loginForm = useForm({'email': emailField, 'password': passwordField});

    // Demo 2: Registration Form with more validators
    final usernameField = useField<String>(
      validators: [
        Validators.required(),
        Validators.minLength(3),
        Validators.maxLength(20),
        Validators.pattern(
          RegExp(r'^[a-zA-Z0-9_]+$'),
          'Only letters, numbers, and underscores allowed',
        ),
      ],
      validateOnChange: true,
    );

    final ageField = useField<String>(
      validators: [
        Validators.required(),
        (value) {
          if (value == null || value.isEmpty) return null;
          final age = int.tryParse(value);
          if (age == null) return 'Please enter a valid number';
          if (age < 18) return 'Must be 18 or older';
          if (age > 120) return 'Please enter a valid age';
          return null;
        },
      ],
    );

    final bioField = useField<String>(
      validators: [
        Validators.maxLength(200, 'Bio must be less than 200 characters'),
      ],
    );

    final registrationForm = useForm({
      'username': usernameField,
      'age': ageField,
      'bio': bioField,
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('useForm Demo'),
          actions: [
            TextButton(
              onPressed: () => _showCodeDialog(context),
              child: const Text(
                '📋 Code',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Login Form'),
              Tab(text: 'Registration Form'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Login Form
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔐 Login Form',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Simple form with email and password validation',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailField.controller,
                            focusNode: emailField.focusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              errorText: emailField.showError
                                  ? emailField.error
                                  : null,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordField.controller,
                            focusNode: passwordField.focusNode,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              errorText: passwordField.showError
                                  ? passwordField.error
                                  : null,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed:
                                  loginForm.isValid && !loginForm.isSubmitting
                                  ? () => loginForm.submit((values) async {
                                      // Simulate API call
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Login successful! Email: ${values['email']}',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        // Reset form after success
                                        loginForm.reset();
                                      }
                                    })
                                  : null,
                              child: loginForm.isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Login'),
                            ),
                          ),
                          if (loginForm.submitError != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(loginForm.submitError!)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form state info
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Form State',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _buildStateRow('Valid', loginForm.isValid),
                          _buildStateRow('Dirty', loginForm.isDirty),
                          _buildStateRow('Submitting', loginForm.isSubmitting),
                          const SizedBox(height: 12),
                          Text(
                            'Values: ${loginForm.values}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab 2: Registration Form
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 Registration Form',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Advanced form with multiple validators',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: usernameField.controller,
                            focusNode: usernameField.focusNode,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: const Icon(Icons.person),
                              errorText: usernameField.showError
                                  ? usernameField.error
                                  : null,
                              helperText:
                                  '3-20 characters, letters, numbers, underscore',
                              border: const OutlineInputBorder(),
                              suffixIcon:
                                  usernameField.value?.isNotEmpty ?? false
                                  ? usernameField.error == null
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: ageField.controller,
                            focusNode: ageField.focusNode,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              prefixIcon: const Icon(Icons.cake),
                              errorText: ageField.showError
                                  ? ageField.error
                                  : null,
                              helperText: 'Must be 18 or older',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: bioField.controller,
                            focusNode: bioField.focusNode,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Bio (optional)',
                              alignLabelWithHint: true,
                              prefixIcon: const Icon(Icons.info),
                              errorText: bioField.showError
                                  ? bioField.error
                                  : null,
                              helperText:
                                  '${bioField.value?.length ?? 0}/200 characters',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: registrationForm.reset,
                                  child: const Text('Reset'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Validate all fields
                                    final isValid = registrationForm.validate();
                                    if (isValid) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Form is valid!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Validate'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Validators info
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.verified_user, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Built-in Validators',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '• required() - Non-empty validation\n'
                            '• email() - Email format\n'
                            '• minLength(n) - Minimum length\n'
                            '• maxLength(n) - Maximum length\n'
                            '• pattern(regex) - Pattern matching\n'
                            '• range(min, max) - Number range\n'
                            '• Custom validators supported',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: value ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 13,
              color: value ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useForm Code Example'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''// Define fields with validators
final emailField = useField<String>(
  validators: [
    Validators.required(),
    Validators.email(),
  ],
);

final passwordField = useField<String>(
  validators: [
    Validators.required(),
    Validators.minLength(8),
  ],
);

// Create form
final form = useForm({
  'email': emailField,
  'password': passwordField,
});

// Use in UI
TextFormField(
  controller: emailField.controller,
  focusNode: emailField.focusNode,
  decoration: InputDecoration(
    errorText: emailField.showError 
        ? emailField.error 
        : null,
  ),
)

// Submit form
ElevatedButton(
  onPressed: form.isValid && !form.isSubmitting
      ? () => form.submit((values) async {
          await api.login(values);
        })
      : null,
  child: form.isSubmitting
      ? CircularProgressIndicator()
      : Text('Login'),
)

// Built-in validators
Validators.required(message)
Validators.email(message)
Validators.minLength(n, message)
Validators.maxLength(n, message)
Validators.pattern(regex, message)
Validators.range(min, max, message)

// Custom validator
(value) {
  if (value != confirmPassword) {
    return 'Passwords must match';
  }
  return null;
}''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
