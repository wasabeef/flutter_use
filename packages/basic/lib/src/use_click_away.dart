import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// State object returned by [useClickAway].
class ClickAwayState {
  /// Creates a [ClickAwayState].
  const ClickAwayState({
    required this.ref,
  });

  /// A global key that should be attached to the target widget.
  ///
  /// Clicks outside this widget will trigger the callback.
  final GlobalKey ref;
}

/// Detects clicks outside a target widget and calls a callback function.
///
/// This hook is useful for implementing behaviors like closing dropdowns,
/// modals, or context menus when clicking outside them.
///
/// Returns a [ClickAwayState] that contains:
/// - [ClickAwayState.ref]: A [GlobalKey] to attach to the target widget
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   final showDropdown = useState(false);
///   final clickAway = useClickAway(() {
///     showDropdown.value = false;
///   });
///
///   return Column(
///     children: [
///       ElevatedButton(
///         onPressed: () => showDropdown.value = !showDropdown.value,
///         child: Text('Toggle Dropdown'),
///       ),
///       if (showDropdown.value)
///         Container(
///           key: clickAway.ref,
///           width: 200,
///           height: 100,
///           color: Colors.blue,
///           child: Center(
///             child: Text('Click outside to close'),
///           ),
///         ),
///     ],
///   );
/// }
/// ```
ClickAwayState useClickAway(VoidCallback onClickAway) {
  final ref = useMemoized(GlobalKey.new, []);
  final callbackRef = useRef(onClickAway);

  // Update the callback reference whenever it changes
  callbackRef.value = onClickAway;

  useEffect(
    () {
      void handlePointerEvent(PointerEvent event) {
        // Only handle pointer down events
        if (event is! PointerDownEvent) {
          return;
        }

        final context = ref.currentContext;
        if (context == null) {
          return;
        }

        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null) {
          return;
        }

        final offset = renderBox.globalToLocal(event.position);
        final size = renderBox.size;

        // Check if the click is outside the target widget
        if (offset.dx < 0 ||
            offset.dy < 0 ||
            offset.dx > size.width ||
            offset.dy > size.height) {
          callbackRef.value();
        }
      }

      // Add global pointer listener
      GestureBinding.instance.pointerRouter.addGlobalRoute(handlePointerEvent);

      return () {
        // Remove global pointer listener
        GestureBinding.instance.pointerRouter
            .removeGlobalRoute(handlePointerEvent);
      };
    },
    [],
  );

  return ClickAwayState(ref: ref);
}
