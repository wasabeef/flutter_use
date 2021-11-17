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

  useUpdateEffect(() {
    debugPrint('$componentName updated $props');
  });
}
