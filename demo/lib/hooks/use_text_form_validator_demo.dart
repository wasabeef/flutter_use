import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseTextFormValidatorDemo extends HookWidget {
  const UseTextFormValidatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Email validation
    final emailController = useTextEditingController();
    final emailError = useTextFormValidator<String?>(
      validator: (value) {
        if (value.isEmpty) return 'Email is required';
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) return 'Invalid email format';
        return null;
      },
      controller: emailController,
      initialValue: null,
    );

    // Password validation with multiple rules
    final passwordController = useTextEditingController();
    final passwordErrors = useTextFormValidator<List<String>>(
      validator: (value) {
        final errors = <String>[];
        if (value.isEmpty) {
          errors.add('Password is required');
        } else {
          if (value.length < 8) errors.add('At least 8 characters');
          if (!value.contains(RegExp(r'[A-Z]'))) {
            errors.add('One uppercase letter');
          }
          if (!value.contains(RegExp(r'[a-z]'))) {
            errors.add('One lowercase letter');
          }
          if (!value.contains(RegExp(r'[0-9]'))) errors.add('One number');
          if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
            errors.add('One special character');
          }
        }
        return errors;
      },
      controller: passwordController,
      initialValue: [],
    );

    // Username validation
    final usernameController = useTextEditingController();
    final usernameValid = useTextFormValidator<bool>(
      validator: (value) {
        if (value.isEmpty) return false;
        if (value.length < 3) return false;
        return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value);
      },
      controller: usernameController,
      initialValue: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('useTextFormValidator Demo'),
        actions: [
          TextButton(
            onPressed: () => _showCodeDialog(context),
            child: const Text('📋 Code', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✅ useTextFormValidator Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reactive form validation with real-time feedback',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Registration Form',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Username field
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter username (3+ chars, alphanumeric)',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person),
                        suffixIcon: usernameController.text.isNotEmpty
                            ? Icon(
                                usernameValid
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: usernameValid
                                    ? Colors.green
                                    : Colors.red,
                              )
                            : null,
                      ),
                    ),
                    if (usernameController.text.isNotEmpty && !usernameValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 12),
                        child: Text(
                          'Username must be 3+ characters, alphanumeric only',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Email field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                        errorText: emailError,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter a strong password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: passwordController.text.isNotEmpty
                            ? Icon(
                                passwordErrors.isEmpty
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: passwordErrors.isEmpty
                                    ? Colors.green
                                    : Colors.red,
                              )
                            : null,
                      ),
                      obscureText: true,
                    ),

                    // Password requirements
                    if (passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: passwordErrors.isEmpty
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: passwordErrors.isEmpty
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password Requirements:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            _buildRequirement(
                              'At least 8 characters',
                              !passwordErrors.contains('At least 8 characters'),
                            ),
                            _buildRequirement(
                              'One uppercase letter',
                              !passwordErrors.contains('One uppercase letter'),
                            ),
                            _buildRequirement(
                              'One lowercase letter',
                              !passwordErrors.contains('One lowercase letter'),
                            ),
                            _buildRequirement(
                              'One number',
                              !passwordErrors.contains('One number'),
                            ),
                            _buildRequirement(
                              'One special character',
                              !passwordErrors.contains('One special character'),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (usernameValid &&
                                emailError == null &&
                                emailController.text.isNotEmpty &&
                                passwordErrors.isEmpty &&
                                passwordController.text.isNotEmpty)
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Form is valid! ✅'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            : null,
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Features
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.stars, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Key Features',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Real-time validation feedback\n'
                      '• Flexible return types (String?, bool, List, etc.)\n'
                      '• Reactive updates on text change\n'
                      '• Multiple validation rules support\n'
                      '• Works with TextEditingController',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'How it works',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Listens to TextEditingController changes\n'
                      '• Runs validator function on each change\n'
                      '• Returns validation result reactively\n'
                      '• Supports any return type for flexibility\n'
                      '• Automatically cleans up listeners',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showCodeDialog(context),
                      icon: const Icon(Icons.code),
                      label: const Text('View Code Example'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check : Icons.close,
            size: 16,
            color: met ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: met ? Colors.green : Colors.red,
              decoration: met ? TextDecoration.none : null,
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
        title: const Text('useTextFormValidator Code Example'),
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
                '''// String validation (error message)
final controller = useTextEditingController();
final error = useTextFormValidator<String?>(
  validator: (value) {
    if (value.isEmpty) return 'Required';
    if (value.length < 3) return 'Too short';
    return null; // Valid
  },
  controller: controller,
  initialValue: null,
);

TextField(
  controller: controller,
  decoration: InputDecoration(
    errorText: error,
  ),
)

// Boolean validation
final isValid = useTextFormValidator<bool>(
  validator: (value) => value.length >= 8,
  controller: passwordController,
  initialValue: false,
);

// Multiple errors
final errors = useTextFormValidator<List<String>>(
  validator: (value) {
    final errors = <String>[];
    if (!hasUppercase(value)) {
      errors.add('Need uppercase');
    }
    if (!hasNumber(value)) {
      errors.add('Need number');
    }
    return errors;
  },
  controller: controller,
  initialValue: [],
);

// Email validation
final emailValid = useTextFormValidator<bool>(
  validator: (value) {
    final regex = RegExp(r'^[w-.]+@([w-]+.)+[w-]{2,4}\$');
    return regex.hasMatch(value);
  },
  controller: emailController,
  initialValue: false,
);''',
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
