import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns a throttled value that only updates at most once per [duration].
///
/// The throttled value will update immediately on the first change,
/// then ignore subsequent changes until [duration] has passed.
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   final searchQuery = useState('');
///   final throttledQuery = useThrottle(searchQuery.value, Duration(milliseconds: 500));
///
///   useEffect(() {
///     // This will only execute at most once every 500ms
///     print('Searching for: $throttledQuery');
///     return null;
///   }, [throttledQuery]);
///
///   return TextField(
///     onChanged: (value) => searchQuery.value = value,
///   );
/// }
/// ```
T useThrottle<T>(T value, Duration duration) {
  final throttled = useState<T>(value);
  final timer = useRef<Timer?>(null);
  final previousValue = useRef<T>(value);
  final isThrottling = useRef(false);

  // Update throttled value if this is a new value
  if (previousValue.value != value) {
    if (!isThrottling.value) {
      // Update immediately if not currently throttling
      throttled.value = value;
      isThrottling.value = true;

      // Start throttling period
      timer.value?.cancel();
      timer.value = Timer(duration, () {
        isThrottling.value = false;
      });
    } else {
      // Schedule an update after the throttling period ends
      timer.value?.cancel();
      timer.value = Timer(duration, () {
        throttled.value = value;
        isThrottling.value = false;
      });
    }

    previousValue.value = value;
  }

  useEffect(
    () {
      return () => timer.value?.cancel();
    },
    [],
  );

  return throttled.value;
}
