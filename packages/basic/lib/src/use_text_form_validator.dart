import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook for reactive text form validation.
///
/// Automatically runs a validator function whenever the text in a
/// [TextEditingController] changes.
///
/// [validator] is the function that validates the text and returns a result of type [T].
/// [controller] is the TextEditingController to listen to for text changes.
/// [initialValue] is the initial validation result before any text is entered.
///
/// Returns the current validation result of type [T].
///
/// Example:
/// ```dart
/// final controller = TextEditingController();
///
/// // String validation (error message or null)
/// final errorMessage = useTextFormValidator<String?>(
///   validator: (value) => value.isEmpty ? 'Required' : null,
///   controller: controller,
///   initialValue: null,
/// );
///
/// // Boolean validation (valid/invalid)
/// final isValid = useTextFormValidator<bool>(
///   validator: (value) => value.length >= 8,
///   controller: controller,
///   initialValue: false,
/// );
///
/// // Complex validation (list of errors)
/// final errors = useTextFormValidator<List<String>>(
///   validator: (value) {
///     final errors = <String>[];
///     if (value.isEmpty) errors.add('Required');
///     if (value.length < 3) errors.add('Too short');
///     return errors;
///   },
///   controller: controller,
///   initialValue: <String>[],
/// );
/// ```
T useTextFormValidator<T>({
  required Validator<T> validator,
  required TextEditingController controller,
  required T initialValue,
}) {
  final state = useState(initialValue);

  final validate = useCallback(() {
    state.value = validator(controller.value.text);
  }, [
    controller,
  ]);

  useEffect(() {
    controller.addListener(validate);
    return () => controller.removeListener(validate);
  }, [
    controller,
  ]);

  return state.value;
}

/// A function that validates text input and returns a result of type [T].
///
/// This function receives the current text value and should return a validation
/// result. The type [T] can be anything that represents the validation state,
/// such as:
/// - `String?` for error messages (null means valid)
/// - `bool` for simple valid/invalid states
/// - `List<String>` for multiple validation errors
/// - Custom validation result objects
typedef Validator<T> = T Function(String value);
