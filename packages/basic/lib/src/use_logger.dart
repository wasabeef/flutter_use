import 'package:flutter/material.dart';

import 'use_effect_once.dart';
import 'use_update_effect.dart';

/// Flutter lifecycle hook that console logs parameters as component
/// transitions through lifecycles.
void useLogger(String componentName, {Map<String, dynamic> props = const {}}) {
  useEffectOnce(() {
    debugPrint('$componentName mounted $props');
    return () => debugPrint('$componentName unmounted');
  });

  // ignore: body_might_complete_normally_nullable
  useUpdateEffect(() {
    debugPrint('$componentName updated $props');
  });
}
