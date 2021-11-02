library template;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This is a template for hook.
ValueNotifier<T> useTemplate<T>(T initialData) {
  return useState(initialData);
}
