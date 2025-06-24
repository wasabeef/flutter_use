import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart' as flutter_use;

void main() {
  group('Validators', () {
    test('required validator', () {
      final validator = flutter_use.Validators.required<String>();
      expect(validator(null), equals('This field is required'));
      expect(validator(''), equals('This field is required'));
      expect(validator('value'), isNull);

      final customMessage =
          flutter_use.Validators.required<String>('Custom error');
      expect(customMessage(null), equals('Custom error'));
    });

    test('email validator', () {
      final validator = flutter_use.Validators.email();
      expect(validator(null), isNull);
      expect(validator(''), isNull);
      expect(validator('invalid'), equals('Please enter a valid email'));
      expect(validator('test@example.com'), isNull);
      expect(validator('user.name+tag@example.co.uk'), isNull);
    });

    test('minLength validator', () {
      final validator = flutter_use.Validators.minLength(5);
      expect(validator(null), isNull);
      expect(validator(''), isNull);
      expect(validator('1234'), equals('Must be at least 5 characters'));
      expect(validator('12345'), isNull);
      expect(validator('123456'), isNull);
    });

    test('maxLength validator', () {
      final validator = flutter_use.Validators.maxLength(5);
      expect(validator(null), isNull);
      expect(validator(''), isNull);
      expect(validator('12345'), isNull);
      expect(validator('123456'), equals('Must be at most 5 characters'));
    });

    test('pattern validator', () {
      final validator = flutter_use.Validators.pattern(
        RegExp(r'^\d+$'),
        'Only numbers allowed',
      );
      expect(validator(null), isNull);
      expect(validator(''), isNull);
      expect(validator('123'), isNull);
      expect(validator('abc'), equals('Only numbers allowed'));
      expect(validator('12a'), equals('Only numbers allowed'));
    });

    test('range validator', () {
      final validator = flutter_use.Validators.range(1, 10);
      expect(validator(null), isNull);
      expect(validator(0), equals('Must be between 1 and 10'));
      expect(validator(1), isNull);
      expect(validator(5), isNull);
      expect(validator(10), isNull);
      expect(validator(11), equals('Must be between 1 and 10'));
    });

    test('composeValidators', () {
      final validator = flutter_use.composeValidators<String>([
        flutter_use.Validators.required(),
        flutter_use.Validators.minLength(5),
        flutter_use.Validators.email(),
      ]);

      expect(validator(null), equals('This field is required'));
      expect(validator(''), equals('This field is required'));
      expect(validator('abc'), equals('Must be at least 5 characters'));
      expect(validator('abcde'), equals('Please enter a valid email'));
      expect(validator('test@example.com'), isNull);
    });
  });

  group('useField', () {
    testWidgets('should manage field state', (tester) async {
      late flutter_use.FieldState<String> field;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              field = flutter_use.useField<String>(
                initialValue: 'initial',
                validators: [flutter_use.Validators.required()],
              );
              return Container();
            },
          ),
        ),
      );

      expect(field.value, equals('initial'));
      expect(field.error, isNull);
      expect(field.touched, isFalse);
      expect(field.isValid, isTrue);

      // Set value
      field.setValue('new value');
      await tester.pump();
      expect(field.value, equals('new value'));

      // Set error
      field.setError('Custom error');
      await tester.pump();
      expect(field.error, equals('Custom error'));
      expect(field.isValid, isFalse);

      // Mark as touched
      field.setTouched(true);
      await tester.pump();
      expect(field.touched, isTrue);
      expect(field.showError, isTrue);
    });

    testWidgets('should validate field', (tester) async {
      late flutter_use.FieldState<String> field;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              field = flutter_use.useField<String>(
                initialValue: '',
                validators: [
                  flutter_use.Validators.required(),
                  flutter_use.Validators.minLength(5),
                ],
              );
              return Container();
            },
          ),
        ),
      );

      // Validate empty value
      final error = field.validate();
      expect(error, equals('This field is required'));
      await tester.pump();
      expect(field.error, equals('This field is required'));

      // Set short value
      field.setValue('abc');
      await tester.pump();
      field.validate();
      await tester.pump();
      expect(field.error, equals('Must be at least 5 characters'));

      // Set valid value
      field.setValue('valid');
      await tester.pump();
      field.validate();
      await tester.pump();
      expect(field.error, isNull);
    });

    testWidgets('should reset field', (tester) async {
      late flutter_use.FieldState<String> field;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              field = flutter_use.useField<String>(
                initialValue: 'initial',
                validators: [],
              );
              return Container();
            },
          ),
        ),
      );

      // Modify field
      field.setValue('modified');
      field.setError('error');
      field.setTouched(true);
      await tester.pump();

      expect(field.value, equals('modified'));
      expect(field.error, equals('error'));
      expect(field.touched, isTrue);

      // Reset
      field.reset();
      await tester.pump();

      expect(field.value, equals('initial'));
      expect(field.error, isNull);
      expect(field.touched, isFalse);
    });

    testWidgets('should provide TextEditingController for string fields',
        (tester) async {
      late flutter_use.FieldState<String> field;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              field = flutter_use.useField<String>(initialValue: 'test');
              return Container();
            },
          ),
        ),
      );

      expect(field.controller, isNotNull);
      expect(field.controller!.text, equals('test'));

      // Update via controller
      field.controller!.text = 'updated';
      await tester.pump();
      expect(field.value, equals('updated'));

      // Update via setValue
      field.setValue('new');
      await tester.pump();
      expect(field.controller!.text, equals('new'));
    });

    testWidgets('should validate on change if enabled', (tester) async {
      late flutter_use.FieldState<String> field;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              field = flutter_use.useField<String>(
                initialValue: '',
                validators: [flutter_use.Validators.required()],
                validateOnChange: true,
              );
              return Container();
            },
          ),
        ),
      );

      // Mark as touched
      field.setTouched(true);
      await tester.pump();

      // Change value - should validate
      field.setValue('');
      await tester.pump();
      expect(field.error, equals('This field is required'));

      // Set valid value
      field.setValue('valid');
      await tester.pump();
      expect(field.error, isNull);
    });
  });

  group('useForm', () {
    testWidgets('should manage form state', (tester) async {
      late flutter_use.FieldState<String> emailField;
      late flutter_use.FieldState<String> passwordField;
      late flutter_use.FormState form;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              emailField = flutter_use.useField<String>(
                initialValue: '',
                validators: [
                  flutter_use.Validators.required(),
                  flutter_use.Validators.email(),
                ],
              );
              passwordField = flutter_use.useField<String>(
                initialValue: '',
                validators: [
                  flutter_use.Validators.required(),
                  flutter_use.Validators.minLength(8),
                ],
              );

              form = flutter_use.useForm({
                'email': emailField,
                'password': passwordField,
              });

              return Container();
            },
          ),
        ),
      );

      // Initially invalid (empty required fields)
      expect(form.isValid, isFalse);
      expect(form.isDirty, isFalse);
      expect(form.values, equals({'email': '', 'password': ''}));

      // Set values
      emailField.setValue('test@example.com');
      passwordField.setValue('password123');
      await tester.pump();

      expect(form.isDirty, isTrue);
      expect(
        form.values,
        equals({
          'email': 'test@example.com',
          'password': 'password123',
        }),
      );
    });

    testWidgets('should validate all fields', (tester) async {
      late flutter_use.FieldState<String> field1;
      late flutter_use.FieldState<String> field2;
      late flutter_use.FormState form;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              field1 = flutter_use.useField<String>(
                initialValue: '',
                validators: [flutter_use.Validators.required()],
              );
              field2 = flutter_use.useField<String>(
                initialValue: 'ab',
                validators: [flutter_use.Validators.minLength(5)],
              );

              form = flutter_use.useForm({
                'field1': field1,
                'field2': field2,
              });

              return Container();
            },
          ),
        ),
      );

      // Validate form
      final isValid = form.validate();
      expect(isValid, isFalse);
      await tester.pump();

      expect(field1.error, equals('This field is required'));
      expect(field2.error, equals('Must be at least 5 characters'));

      // Fix fields
      field1.setValue('value');
      field2.setValue('valid');
      await tester.pump();

      final isValidNow = form.validate();
      expect(isValidNow, isTrue);
    });

    testWidgets('should handle form submission', (tester) async {
      late flutter_use.FieldState<String> emailField;
      late flutter_use.FormState form;
      String? submittedEmail;
      var isSubmitting = false;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              emailField = flutter_use.useField<String>(
                initialValue: 'test@example.com',
                validators: [
                  flutter_use.Validators.required(),
                  flutter_use.Validators.email(),
                ],
              );

              form = flutter_use.useForm({'email': emailField});

              // Track submission state
              if (form.isSubmitting != isSubmitting) {
                isSubmitting = form.isSubmitting;
              }

              return TextButton(
                onPressed: () async {
                  await form.submit((values) async {
                    submittedEmail = values['email'] as String?;
                    await Future<void>.delayed(
                      const Duration(milliseconds: 10),
                    );
                  });
                },
                child: const Text('Submit'),
              );
            },
          ),
        ),
      );

      // Submit form
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(isSubmitting, isTrue);

      // Wait for submission
      await tester.pump(const Duration(milliseconds: 20));

      expect(form.isSubmitting, isFalse);
      expect(submittedEmail, equals('test@example.com'));
      expect(form.submitError, isNull);
    });

    testWidgets('should handle submission errors', (tester) async {
      late flutter_use.FormState form;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final field = flutter_use.useField<String>(initialValue: 'value');
              form = flutter_use.useForm({'field': field});
              return TextButton(
                onPressed: () async {
                  await form.submit((values) async {
                    throw Exception('Submission error');
                  });
                },
                child: const Text('Submit'),
              );
            },
          ),
        ),
      );

      // Submit with error
      await tester.tap(find.text('Submit'));
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 10));

      expect(form.isSubmitting, isFalse);
      expect(form.submitError, contains('Submission error'));
    });

    testWidgets('should reset form', (tester) async {
      late flutter_use.FieldState<String> field;
      late flutter_use.FormState form;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              field = flutter_use.useField<String>(initialValue: 'initial');
              form = flutter_use.useForm({'field': field});
              return Container();
            },
          ),
        ),
      );

      // Modify form
      field.setValue('modified');
      form.setSubmitError('error');
      await tester.pump();

      expect(field.value, equals('modified'));
      expect(form.submitError, equals('error'));

      // Reset
      form.reset();
      await tester.pump();

      expect(field.value, equals('initial'));
      expect(form.submitError, isNull);
    });

    testWidgets('should not submit invalid form', (tester) async {
      late flutter_use.FormState form;
      var submitCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final field = flutter_use.useField<String>(
                initialValue: '',
                validators: [flutter_use.Validators.required()],
              );
              form = flutter_use.useForm({'field': field});
              return TextButton(
                onPressed: () async {
                  await form.submit((values) async {
                    submitCalled = true;
                  });
                },
                child: const Text('Submit'),
              );
            },
          ),
        ),
      );

      // Try to submit invalid form
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(submitCalled, isFalse);
      expect(form.fields['field']!.touched, isTrue);
      expect(form.fields['field']!.error, isNotNull);
    });
  });
}
