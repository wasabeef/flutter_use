import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Each time given state changes - validator function is invoked.
T useTextFormValidator<T>({
  required Validator validator,
  required TextEditingController controller,
  required T initialValue,
}) {
  final state = useState(initialValue);

  final validate = useCallback(() {
    state.value = validator(controller.value.text);
  }, [controller]);

  useEffect(() {
    controller.addListener(validate);
    return () => controller.removeListener(validate);
  }, [controller]);

  return state.value;
}

typedef Validator<T> = T Function(String value);
