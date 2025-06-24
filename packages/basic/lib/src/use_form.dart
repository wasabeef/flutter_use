import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A validator function that returns an error message if validation fails.
typedef FieldValidator<T> = String? Function(T? value);

/// Combines multiple validators into a single validator.
FieldValidator<T> composeValidators<T>(List<FieldValidator<T>> validators) =>
    (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };

/// Common validators for form fields.
class Validators {
  /// Validates that a value is not null or empty.
  static FieldValidator<T> required<T>([String? message]) => (value) {
        if (value == null) {
          return message ?? 'This field is required';
        }
        if (value is String && value.isEmpty) {
          return message ?? 'This field is required';
        }
        if (value is Iterable && value.isEmpty) {
          return message ?? 'This field is required';
        }
        return null;
      };

  /// Validates that a string matches an email pattern.
  static FieldValidator<String> email([String? message]) => (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        final emailRegex = RegExp(r'^[\w-\.\+]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return message ?? 'Please enter a valid email';
        }
        return null;
      };

  /// Validates that a string has a minimum length.
  static FieldValidator<String> minLength(int length, [String? message]) =>
      (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        if (value.length < length) {
          return message ?? 'Must be at least $length characters';
        }
        return null;
      };

  /// Validates that a string has a maximum length.
  static FieldValidator<String> maxLength(int length, [String? message]) =>
      (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        if (value.length > length) {
          return message ?? 'Must be at most $length characters';
        }
        return null;
      };

  /// Validates that a string matches a pattern.
  static FieldValidator<String> pattern(RegExp regex, [String? message]) =>
      (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        if (!regex.hasMatch(value)) {
          return message ?? 'Invalid format';
        }
        return null;
      };

  /// Validates that a number is within a range.
  static FieldValidator<num> range(num min, num max, [String? message]) =>
      (value) {
        if (value == null) {
          return null;
        }
        if (value < min || value > max) {
          return message ?? 'Must be between $min and $max';
        }
        return null;
      };

  /// Validates URL format.
  static FieldValidator<String> url([String? message]) => (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        final urlRegex = RegExp(r'^https?:\/\/.+\..+');
        if (!urlRegex.hasMatch(value)) {
          return message ?? 'Please enter a valid URL';
        }
        return null;
      };

  /// Validates phone number format.
  static FieldValidator<String> phone([String? message]) => (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        final phoneRegex = RegExp(r'^[\+]?[0-9\-\(\)\s]{10,}$');
        if (!phoneRegex.hasMatch(value)) {
          return message ?? 'Please enter a valid phone number';
        }
        return null;
      };
}

/// State container and controller for a form field with validation and focus management.
///
/// This class encapsulates all the state and behavior needed for a form field,
/// including the current value, validation state, touch state, and methods for
/// manipulation. It provides a unified interface for managing form fields
/// regardless of their type or input method.
///
/// The field automatically integrates with Flutter's text input system when
/// dealing with string values, providing [TextEditingController] and [FocusNode]
/// for seamless integration with [TextFormField] and similar widgets.
class FieldState<T> {
  /// Creates a [FieldState] with the specified state and control functions.
  ///
  /// [value] is the current value of the field.
  /// [error] contains the current validation error message, if any.
  /// [touched] indicates whether the field has been interacted with.
  /// [setValue] is the function to update the field's value.
  /// [setError] is the function to manually set an error message.
  /// [setTouched] is the function to mark the field as touched.
  /// [validate] is the function that validates the current value.
  /// [reset] is the function that resets the field to its initial state.
  /// [controller] is the text controller for string-based fields (may be null).
  /// [focusNode] is the focus node for managing field focus.
  FieldState({
    required this.value,
    required this.error,
    required this.touched,
    required this.setValue,
    required this.setError,
    required this.setTouched,
    required this.validate,
    required this.reset,
    required this.controller,
    required this.focusNode,
  });

  /// The current value of the field.
  ///
  /// This represents the actual data stored in the field and may be null
  /// if the field is empty or hasn't been initialized with a value.
  final T? value;

  /// The current validation error message, if any.
  ///
  /// This will be null if the field is valid or hasn't been validated yet.
  /// Error messages are typically set during validation or can be manually
  /// set using [setError].
  final String? error;

  /// Whether the field has been touched (focused and then blurred).
  ///
  /// This is useful for determining when to show validation errors.
  /// Typically, errors are only displayed after a field has been touched
  /// to avoid showing errors immediately when the form loads.
  final bool touched;

  /// Sets the value of the field.
  ///
  /// This method updates the field's value and may trigger validation
  /// depending on the field's configuration. For string fields, it also
  /// updates the associated [TextEditingController].
  final void Function(T? value) setValue;

  /// Sets the error message for the field.
  ///
  /// This allows manual error setting, which is useful for server-side
  /// validation errors or custom validation logic.
  final void Function(String? error) setError;

  /// Marks the field as touched or untouched.
  ///
  /// Touched state is typically managed automatically, but this method
  /// allows manual control when needed.
  final void Function(bool touched) setTouched;

  /// Validates the field and returns the error message, if any.
  ///
  /// This method runs all configured validators on the current value
  /// and returns the first error encountered, or null if validation passes.
  /// The field's error state is updated as a side effect.
  final String? Function() validate;

  /// Resets the field to its initial state.
  ///
  /// This clears the value, error, and touched state, restoring the field
  /// to the state it was in when first created.
  final void Function() reset;

  /// Text controller for string-based input fields.
  ///
  /// This is automatically created for fields with string values and provides
  /// integration with Flutter's text input widgets. Will be null for non-string fields.
  final TextEditingController? controller;

  /// Focus node for managing field focus state.
  ///
  /// This allows programmatic control of field focus and listening to focus changes.
  /// It's automatically integrated with the touched state management.
  final FocusNode focusNode;

  /// Whether the field is currently valid.
  ///
  /// Returns true if there is no error message, indicating that the field
  /// either passed validation or hasn't been validated yet.
  bool get isValid => error == null;

  /// Whether the field should display its error.
  ///
  /// Returns true only if the field has an error and has been touched.
  /// This prevents showing errors immediately when a form loads, instead
  /// waiting until the user has interacted with the field.
  bool get showError => error != null && touched;
}

/// Flutter hook that creates and manages a form field with validation and focus handling.
///
/// This hook provides a complete form field solution with automatic validation,
/// focus management, and integration with Flutter's text input system. It handles
/// both the state management and the controller/focus node creation needed for
/// seamless integration with form widgets.
///
/// The hook automatically creates a [TextEditingController] for string fields and
/// synchronizes it with the field state. It also manages focus state and triggers
/// validation based on the configuration provided.
///
/// [initialValue] is the starting value for the field. Can be null for optional fields.
/// [validators] is a list of validation functions that will be composed together.
/// The first validator that returns an error will stop the validation chain.
/// [validateOnChange] determines whether validation runs automatically when the
/// value changes. Defaults to false, meaning validation only occurs on explicit
/// calls to validate() or form submission.
///
/// Returns a [FieldState<T>] object that provides:
/// - Current value and validation state
/// - Methods to update value, error, and touched state
/// - Automatic [TextEditingController] for string fields
/// - [FocusNode] for focus management
/// - Validation and reset functionality
///
/// The field automatically manages touched state by listening to focus changes.
/// When the field loses focus for the first time, it's marked as touched, which
/// enables error display through the [FieldState.showError] getter.
///
/// Example with basic validation:
/// ```dart
/// final emailField = useField<String>(
///   initialValue: '',
///   validators: [Validators.required(), Validators.email()],
/// );
///
/// TextFormField(
///   controller: emailField.controller,
///   focusNode: emailField.focusNode,
///   decoration: InputDecoration(
///     labelText: 'Email',
///     errorText: emailField.showError ? emailField.error : null,
///   ),
/// )
/// ```
///
/// Example with real-time validation:
/// ```dart
/// final passwordField = useField<String>(
///   initialValue: '',
///   validators: [
///     Validators.required(),
///     Validators.minLength(8),
///   ],
///   validateOnChange: true, // Validate as user types
/// );
/// ```
///
/// Example with custom validation:
/// ```dart
/// final ageField = useField<int>(
///   initialValue: null,
///   validators: [
///     Validators.required<int>(),
///     (value) => value != null && value < 18 ? 'Must be 18 or older' : null,
///   ],
/// );
/// ```
///
/// See also:
///  * [useForm], for managing multiple fields together
///  * [FieldState], the returned state object
///  * [Validators], for common validation functions
FieldState<T> useField<T>({
  T? initialValue,
  List<FieldValidator<T>> validators = const [],
  bool validateOnChange = false,
}) {
  final value = useState<T?>(initialValue);
  final touched = useState(false);
  final focusNode = useFocusNode();

  // Run initial validation
  final initialError = validators.isNotEmpty
      ? composeValidators(validators)(initialValue)
      : null;
  final error = useState<String?>(initialError);

  // Create text controller for string fields
  final controller = useMemoized(
    () {
      if (initialValue is String?) {
        return TextEditingController(text: initialValue as String?);
      }
      return null;
    },
    [],
  );

  // Sync controller with value
  useEffect(
    () {
      if (controller != null && value.value is String?) {
        if (controller.text != value.value) {
          controller.text = value.value as String? ?? '';
        }
      }
      return null;
    },
    [value.value],
  );

  // Handle focus changes
  useEffect(
    () {
      void onFocusChange() {
        if (!focusNode.hasFocus && !touched.value) {
          touched.value = true;
        }
      }

      focusNode.addListener(onFocusChange);
      return () => focusNode.removeListener(onFocusChange);
    },
    [focusNode],
  );

  // Handle text controller changes
  useEffect(
    () {
      if (controller != null) {
        void onTextChange() {
          final newValue = controller.text as T?;
          if (newValue != value.value) {
            value.value = newValue;
            if (validateOnChange && touched.value) {
              final composedValidator = composeValidators(validators);
              error.value = composedValidator(newValue);
            }
          }
        }

        controller.addListener(onTextChange);
        return () => controller.removeListener(onTextChange);
      }
      return null;
    },
    [controller, validateOnChange],
  );

  final validate = useCallback(
    () {
      final composedValidator = composeValidators(validators);
      final validationError = composedValidator(value.value);
      error.value = validationError;
      return validationError;
    },
    [value.value, validators],
  );

  final setValue = useCallback<void Function(T?)>(
    (newValue) {
      value.value = newValue;
      if (controller != null && newValue is String?) {
        controller.text = newValue ?? '';
      }
      if (validateOnChange && touched.value) {
        validate();
      }
    },
    [validateOnChange],
  );

  final reset = useCallback(
    () {
      value.value = initialValue;
      error.value = null;
      touched.value = false;
      if (controller != null && initialValue is String?) {
        controller.text = initialValue as String? ?? '';
      }
    },
    [initialValue],
  );

  return FieldState<T>(
    value: value.value,
    error: error.value,
    touched: touched.value,
    setValue: setValue,
    setError: (e) => error.value = e,
    setTouched: (t) => touched.value = t,
    validate: validate,
    reset: reset,
    controller: controller,
    focusNode: focusNode,
  );
}

/// State container and controller for form management with multiple fields.
///
/// This class provides a unified interface for managing multiple form fields,
/// including validation, submission state, and collective operations. It
/// aggregates the state of all fields and provides form-level operations
/// like validation, submission, and reset.
///
/// The form automatically tracks overall validity, dirty state, and submission
/// status based on the individual field states. It also provides convenient
/// methods for form submission with error handling and state management.
class FormState {
  /// Creates a [FormState] with the specified fields and control functions.
  ///
  /// [fields] is a map of field names to their [FieldState] objects.
  /// [isValid] indicates whether all fields pass validation.
  /// [isDirty] indicates whether any field has been modified from its initial value.
  /// [isSubmitting] indicates whether a form submission is in progress.
  /// [submitError] contains any error from the last submission attempt.
  /// [validate] is the function that validates all fields.
  /// [submit] is the function that handles form submission.
  /// [reset] is the function that resets all fields.
  /// [setSubmitting] allows manual control of the submitting state.
  /// [setSubmitError] allows manual setting of submission errors.
  const FormState({
    required this.fields,
    required this.isValid,
    required this.isDirty,
    required this.isSubmitting,
    required this.submitError,
    required this.validate,
    required this.submit,
    required this.reset,
    required this.setSubmitting,
    required this.setSubmitError,
  });

  /// Map of field names to their states.
  ///
  /// This provides access to individual field states by name, allowing
  /// direct manipulation of specific fields when needed.
  final Map<String, FieldState<dynamic>> fields;

  /// Whether all fields in the form are valid.
  ///
  /// This is true only when every field either has no error or hasn't
  /// been validated yet. It's automatically updated when field validation
  /// states change.
  final bool isValid;

  /// Whether any field has been modified from its initial value.
  ///
  /// This is useful for detecting unsaved changes and prompting users
  /// before navigation or for enabling/disabling save buttons.
  final bool isDirty;

  /// Whether the form is currently being submitted.
  ///
  /// This is automatically managed during form submission and can be used
  /// to show loading indicators or disable form controls.
  final bool isSubmitting;

  /// Error that occurred during the last form submission attempt.
  ///
  /// This is typically used for displaying server-side errors or network
  /// failures that occur during form submission.
  final String? submitError;

  /// Validates all fields in the form and returns whether all are valid.
  ///
  /// This method calls validate() on each field and returns true only if
  /// all fields pass validation. It also marks all fields as touched,
  /// which enables error display.
  final bool Function() validate;

  /// Submits the form with the provided submission handler.
  ///
  /// This method automatically validates all fields, manages submission state,
  /// handles errors, and provides the form values to the submission handler.
  /// The submission handler receives a map of field names to values.
  final Future<void> Function(
    Future<void> Function(Map<String, dynamic>) onSubmit,
  ) submit;

  /// Resets all fields to their initial state.
  ///
  /// This clears all values, errors, and touched states, restoring the form
  /// to the state it was in when first created. It also clears any submission errors.
  final void Function() reset;

  /// Manually sets the submitting state.
  ///
  /// This allows external control of the submission state, which can be useful
  /// for complex submission workflows or when integrating with external state management.
  final void Function(bool submitting) setSubmitting;

  /// Manually sets the submission error.
  ///
  /// This allows external error setting, which is useful for handling errors
  /// from external processes or server responses.
  final void Function(String? error) setSubmitError;

  /// Gets the current values of all form fields.
  ///
  /// Returns a map where keys are field names and values are the current
  /// field values. This is the data that would be submitted.
  Map<String, dynamic> get values =>
      fields.map((key, field) => MapEntry(key, field.value));

  /// Gets the current error messages of all form fields.
  ///
  /// Returns a map where keys are field names and values are the current
  /// error messages (or null if the field is valid).
  Map<String, String?> get errors =>
      fields.map((key, field) => MapEntry(key, field.error));
}

/// Flutter hook that creates and manages a form with multiple fields and submission handling.
///
/// This hook aggregates multiple [FieldState] objects into a unified form management
/// system. It provides form-level validation, submission handling, dirty state tracking,
/// and collective operations on all fields. The hook automatically manages the
/// overall form state based on the individual field states.
///
/// The form tracks whether all fields are valid, whether any fields have been modified,
/// and manages submission state with error handling. It provides a streamlined API
/// for form submission that includes automatic validation and state management.
///
/// [fields] is a map where keys are field names and values are [FieldState] objects
/// created with [useField]. The field names are used to identify the fields in the
/// form values and errors maps.
///
/// Returns a [FormState] object that provides:
/// - Aggregated validation state for all fields
/// - Form submission handling with automatic validation
/// - Dirty state tracking to detect unsaved changes
/// - Collective operations like reset and validation
/// - Access to current form values and errors
/// - Submission state management
///
/// The form automatically validates all fields before submission and marks them
/// as touched to display any validation errors. If validation fails, submission
/// is prevented. The submission handler receives a map of field names to values.
///
/// Example with login form:
/// ```dart
/// final form = useForm({
///   'email': useField<String>(
///     initialValue: '',
///     validators: [Validators.required(), Validators.email()],
///   ),
///   'password': useField<String>(
///     initialValue: '',
///     validators: [Validators.required(), Validators.minLength(8)],
///   ),
/// });
///
/// Column(
///   children: [
///     TextFormField(
///       controller: form.fields['email']!.controller,
///       decoration: InputDecoration(
///         labelText: 'Email',
///         errorText: form.fields['email']!.showError
///             ? form.fields['email']!.error
///             : null,
///       ),
///     ),
///     // ... more fields
///     ElevatedButton(
///       onPressed: form.isValid && !form.isSubmitting
///           ? () => form.submit((values) async {
///               await authService.login(
///                 values['email'],
///                 values['password'],
///               );
///             })
///           : null,
///       child: form.isSubmitting
///           ? CircularProgressIndicator()
///           : Text('Login'),
///     ),
///     if (form.submitError != null)
///       Text(form.submitError!, style: TextStyle(color: Colors.red)),
///   ],
/// )
/// ```
///
/// Example with complex validation:
/// ```dart
/// final registrationForm = useForm({
///   'email': useField<String>(
///     validators: [Validators.required(), Validators.email()],
///   ),
///   'password': useField<String>(
///     validators: [Validators.required(), Validators.minLength(8)],
///   ),
///   'confirmPassword': useField<String>(
///     validators: [
///       Validators.required(),
///       (value) => value != passwordField.value
///           ? 'Passwords do not match'
///           : null,
///     ],
///   ),
///   'age': useField<int>(
///     validators: [
///       Validators.required<int>(),
///       Validators.range(18, 120),
///     ],
///   ),
/// });
/// ```
///
/// See also:
///  * [useField], for creating individual form fields
///  * [FormState], the returned state object
///  * [FieldState], for individual field management
FormState useForm(Map<String, FieldState<dynamic>> fields) {
  final isSubmitting = useState(false);
  final submitError = useState<String?>(null);

  final isValid = useMemoized(
    () => fields.values.every((field) => field.isValid),
    [fields.values.map((f) => f.error).toList()],
  );

  final isDirty = useMemoized(
    () => fields.values.any((field) {
      if (field.value == null) {
        return false;
      }
      if (field.value is String && field.value == '') {
        return false;
      }
      if (field.value is Iterable && (field.value as Iterable).isEmpty) {
        return false;
      }
      return true;
    }),
    [fields.values.map((f) => f.value).toList()],
  );

  final validate = useCallback(
    () {
      var allValid = true;
      for (final field in fields.values) {
        final error = field.validate();
        if (error != null) {
          allValid = false;
        }
      }
      return allValid;
    },
    [fields],
  );

  final submit = useCallback(
    (Future<void> Function(Map<String, dynamic>) onSubmit) async {
      // Mark all fields as touched
      for (final field in fields.values) {
        field.setTouched(true);
      }

      // Validate all fields
      if (!validate()) {
        return;
      }

      isSubmitting.value = true;
      submitError.value = null;

      try {
        final values = fields.map((key, field) => MapEntry(key, field.value));
        await onSubmit(values);
      } on Object catch (e) {
        submitError.value = e.toString();
      } finally {
        isSubmitting.value = false;
      }
    },
    [fields, validate],
  );

  final reset = useCallback(
    () {
      for (final field in fields.values) {
        field.reset();
      }
      submitError.value = null;
    },
    [fields],
  );

  return FormState(
    fields: fields,
    isValid: isValid,
    isDirty: isDirty,
    isSubmitting: isSubmitting.value,
    submitError: submitError.value,
    validate: validate,
    submit: submit,
    reset: reset,
    setSubmitting: (submitting) => isSubmitting.value = submitting,
    setSubmitError: (error) => submitError.value = error,
  );
}
