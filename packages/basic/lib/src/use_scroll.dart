import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// State object returned by [useScroll].
class ScrollState {
  /// Creates a [ScrollState].
  const ScrollState({
    required this.x,
    required this.y,
    required this.controller,
  });

  /// The horizontal scroll offset.
  final double x;

  /// The vertical scroll offset.
  final double y;

  /// The scroll controller that can be attached to scrollable widgets.
  final ScrollController controller;
}

/// Tracks scroll position of a scrollable widget.
///
/// Returns a [ScrollState] that contains:
/// - [ScrollState.x]: The horizontal scroll offset (always 0 for single-axis scrollables)
/// - [ScrollState.y]: The vertical scroll offset
/// - [ScrollState.controller]: A [ScrollController] to attach to scrollable widgets
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   final scroll = useScroll();
///
///   return Column(
///     children: [
///       Text('Scroll position: ${scroll.y.toStringAsFixed(2)}'),
///       Expanded(
///         child: ListView.builder(
///           controller: scroll.controller,
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
ScrollState useScroll() {
  final controller = useMemoized(ScrollController.new, []);
  final x = useState<double>(0);
  final y = useState<double>(0);

  useEffect(
    () {
      void listener() {
        if (controller.hasClients) {
          y.value = controller.offset;
          // For single-axis scrollables, x is always 0
          x.value = 0;
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    },
    [controller],
  );

  useEffect(
    () => controller.dispose,
    [],
  );

  return ScrollState(
    x: x.value,
    y: y.value,
    controller: controller,
  );
}
