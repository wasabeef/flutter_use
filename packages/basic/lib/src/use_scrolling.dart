import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// State object returned by [useScrolling].
class ScrollingState {
  /// Creates a [ScrollingState].
  const ScrollingState({
    required this.isScrolling,
    required this.controller,
  });

  /// Whether the scrollable widget is currently being scrolled.
  final bool isScrolling;

  /// The scroll controller that can be attached to scrollable widgets.
  final ScrollController controller;
}

/// Tracks whether a scrollable widget is currently being scrolled.
///
/// Returns a [ScrollingState] that contains:
/// - [ScrollingState.isScrolling]: Whether the widget is currently scrolling
/// - [ScrollingState.controller]: A [ScrollController] to attach to scrollable widgets
///
/// The scrolling state is determined by detecting scroll activity and setting
/// a timeout period. If no scroll events occur within the timeout, scrolling
/// is considered to have stopped.
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   final scrolling = useScrolling();
///
///   return Column(
///     children: [
///       Container(
///         color: scrolling.isScrolling ? Colors.red : Colors.green,
///         height: 50,
///         child: Center(
///           child: Text(
///             scrolling.isScrolling ? 'Scrolling...' : 'Not scrolling',
///           ),
///         ),
///       ),
///       Expanded(
///         child: ListView.builder(
///           controller: scrolling.controller,
///           itemCount: 100,
///           itemBuilder: (context, index) => ListTile(
///             title: Text('Item $index'),
///           ),
///         ),
///       ),
///     ],
///   );
/// }
/// ```
ScrollingState useScrolling([
  Duration timeout = const Duration(milliseconds: 150),
]) {
  final controller = useMemoized(ScrollController.new, []);
  final isScrolling = useState<bool>(false);
  final timer = useRef<Timer?>(null);

  useEffect(
    () {
      void listener() {
        if (controller.hasClients) {
          // Set scrolling to true
          isScrolling.value = true;

          // Cancel any existing timer
          timer.value?.cancel();

          // Set a timer to detect when scrolling stops
          timer.value = Timer(timeout, () {
            isScrolling.value = false;
          });
        }
      }

      controller.addListener(listener);
      return () {
        controller.removeListener(listener);
        timer.value?.cancel();
      };
    },
    [controller, timeout],
  );

  useEffect(
    () => () {
      timer.value?.cancel();
      controller.dispose();
    },
    [],
  );

  return ScrollingState(
    isScrolling: isScrolling.value,
    controller: controller,
  );
}
