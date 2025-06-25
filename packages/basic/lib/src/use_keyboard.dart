import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Utility to check if current platform supports keyboard detection.
bool get isKeyboardDetectionSupported => kIsWeb
    ? (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS)
    : true;

/// State information about the keyboard.
class KeyboardState {
  /// Creates a [KeyboardState].
  const KeyboardState({
    required this.isVisible,
    required this.height,
    required this.animationDuration,
  });

  /// Whether the keyboard is currently visible.
  final bool isVisible;

  /// The height of the keyboard in logical pixels.
  final double height;

  /// The duration of the keyboard animation.
  final Duration animationDuration;

  /// Whether the keyboard is currently hidden.
  bool get isHidden => !isVisible;

  /// Creates a copy of this state with optional new values.
  KeyboardState copyWith({
    bool? isVisible,
    double? height,
    Duration? animationDuration,
  }) =>
      KeyboardState(
        isVisible: isVisible ?? this.isVisible,
        height: height ?? this.height,
        animationDuration: animationDuration ?? this.animationDuration,
      );
}

/// Tracks the state of the on-screen keyboard.
///
/// This hook provides information about the keyboard's visibility and height,
/// which is useful for adjusting layouts when the keyboard appears.
///
/// Example:
/// ```dart
/// final keyboard = useKeyboard();
///
/// AnimatedContainer(
///   duration: keyboard.animationDuration,
///   padding: EdgeInsets.only(bottom: keyboard.height),
///   child: Column(
///     children: [
///       // Your content
///       if (keyboard.isVisible)
///         Text('Keyboard is open (${keyboard.height}px)'),
///     ],
///   ),
/// )
/// ```
KeyboardState useKeyboard({
  Duration animationDuration = const Duration(milliseconds: 250),
}) {
  final context = useContext();

  // Return inactive state for unsupported platforms
  if (!isKeyboardDetectionSupported) {
    return KeyboardState(
      isVisible: false,
      height: 0,
      animationDuration: animationDuration,
    );
  }

  // Get the current keyboard state from MediaQuery
  final mediaQuery = MediaQuery.of(context);
  final currentHeight = mediaQuery.viewInsets.bottom;
  final isCurrentlyVisible = currentHeight > 0;

  final state = useState(
    KeyboardState(
      isVisible: isCurrentlyVisible,
      height: currentHeight,
      animationDuration: animationDuration,
    ),
  );

  // Update state when MediaQuery changes
  useEffect(
    () {
      state.value = state.value.copyWith(
        isVisible: isCurrentlyVisible,
        height: currentHeight,
      );
      return null;
    },
    [isCurrentlyVisible, currentHeight],
  );

  useEffect(
    () {
      // Listen for keyboard changes using WidgetsBindingObserver
      void checkKeyboard() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }

          final mediaQuery = MediaQuery.of(context);
          final newHeight = mediaQuery.viewInsets.bottom;
          final newIsVisible = newHeight > 0;

          if (state.value.height != newHeight ||
              state.value.isVisible != newIsVisible) {
            state.value = state.value.copyWith(
              isVisible: newIsVisible,
              height: newHeight,
            );
          }
        });
      }

      // Use WidgetsBindingObserver to detect keyboard changes
      final observer = _KeyboardObserver(checkKeyboard);
      WidgetsBinding.instance.addObserver(observer);

      return () {
        WidgetsBinding.instance.removeObserver(observer);
      };
    },
    [],
  );

  return state.value;
}

/// A WidgetsBindingObserver that notifies when metrics change.
class _KeyboardObserver extends WidgetsBindingObserver {
  _KeyboardObserver(this.onMetricsChanged);

  final VoidCallback onMetricsChanged;

  @override
  void didChangeMetrics() {
    onMetricsChanged();
  }
}

/// Extended keyboard state with additional utilities.
class KeyboardStateExtended extends KeyboardState {
  /// Creates a [KeyboardStateExtended].
  const KeyboardStateExtended({
    required super.isVisible,
    required super.height,
    required super.animationDuration,
    required this.dismiss,
    required this.bottomInset,
    required this.viewportHeight,
  });

  /// Dismisses the keyboard by unfocusing the current focus.
  final VoidCallback dismiss;

  /// The bottom system UI inset (includes keyboard height).
  final double bottomInset;

  /// The height of the viewport excluding the keyboard.
  final double viewportHeight;

  /// The percentage of screen height occupied by the keyboard.
  double get heightPercentage {
    if (viewportHeight == 0) {
      return 0;
    }
    return height / viewportHeight;
  }
}

/// An extended version of [useKeyboard] with additional utilities.
///
/// This hook provides additional functionality like keyboard dismissal
/// and viewport calculations.
///
/// Example:
/// ```dart
/// final keyboard = useKeyboardExtended();
///
/// GestureDetector(
///   onTap: keyboard.dismiss,
///   child: Container(
///     height: keyboard.viewportHeight,
///     child: Column(
///       children: [
///         Expanded(child: MessageList()),
///         MessageInput(),
///         if (keyboard.isVisible)
///           Text('Keyboard uses ${(keyboard.heightPercentage * 100).toStringAsFixed(0)}% of screen'),
///       ],
///     ),
///   ),
/// )
/// ```
KeyboardStateExtended useKeyboardExtended({
  Duration animationDuration = const Duration(milliseconds: 250),
}) {
  final context = useContext();
  final basicState = useKeyboard(animationDuration: animationDuration);

  final dismiss = useCallback(
    () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    [],
  );

  final mediaQuery = MediaQuery.of(context);
  final bottomInset = mediaQuery.viewInsets.bottom;
  final viewportHeight = mediaQuery.size.height - bottomInset;

  return KeyboardStateExtended(
    isVisible: basicState.isVisible,
    height: basicState.height,
    animationDuration: basicState.animationDuration,
    dismiss: dismiss,
    bottomInset: bottomInset,
    viewportHeight: viewportHeight,
  );
}

/// A hook that provides a boolean indicating if the keyboard is visible.
///
/// This is a simplified version of [useKeyboard] when you only need
/// to know if the keyboard is visible.
///
/// Example:
/// ```dart
/// final isKeyboardVisible = useIsKeyboardVisible();
///
/// if (isKeyboardVisible) {
///   // Adjust UI for keyboard
/// }
/// ```
bool useIsKeyboardVisible() {
  final keyboard = useKeyboard();
  return keyboard.isVisible;
}

/// Configuration for keyboard-aware scrolling behavior.
class KeyboardScrollConfig {
  /// Creates a [KeyboardScrollConfig].
  const KeyboardScrollConfig({
    this.extraScrollPadding = 20.0,
    this.animateScroll = true,
    this.scrollDuration = const Duration(milliseconds: 200),
    this.scrollCurve = Curves.easeOut,
  });

  /// Extra padding to add when scrolling to show focused widget.
  final double extraScrollPadding;

  /// Whether to animate the scroll.
  final bool animateScroll;

  /// Duration of the scroll animation.
  final Duration scrollDuration;

  /// Curve of the scroll animation.
  final Curve scrollCurve;
}

/// A hook that automatically scrolls to keep the focused widget visible
/// when the keyboard appears.
///
/// Example:
/// ```dart
/// final scrollController = useKeyboardAwareScroll();
///
/// ListView(
///   controller: scrollController,
///   children: [
///     // Form fields that might be covered by keyboard
///   ],
/// )
/// ```
ScrollController useKeyboardAwareScroll({
  KeyboardScrollConfig config = const KeyboardScrollConfig(),
  ScrollController? controller,
}) {
  final scrollController = controller ?? useScrollController();
  final keyboard = useKeyboard();
  final context = useContext();

  useEffect(
    () {
      if (keyboard.isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final focusedWidget =
              FocusManager.instance.primaryFocus?.context?.widget;
          if (focusedWidget == null) {
            return;
          }

          final renderObject =
              FocusManager.instance.primaryFocus?.context?.findRenderObject();
          if (renderObject == null || !scrollController.hasClients) {
            return;
          }

          final viewport = RenderAbstractViewport.of(renderObject);

          final scrollOffset =
              viewport.getOffsetToReveal(renderObject, 0.0).offset;
          final currentOffset = scrollController.offset;
          final keyboardTop =
              MediaQuery.of(context).size.height - keyboard.height;

          // Calculate if we need to scroll
          final widgetBottom =
              scrollOffset + (renderObject as RenderBox).size.height;
          if (widgetBottom > keyboardTop - config.extraScrollPadding) {
            final targetOffset = currentOffset +
                (widgetBottom - keyboardTop) +
                config.extraScrollPadding;

            if (config.animateScroll) {
              scrollController.animateTo(
                targetOffset,
                duration: config.scrollDuration,
                curve: config.scrollCurve,
              );
            } else {
              scrollController.jumpTo(targetOffset);
            }
          }
        });
      }
      return null;
    },
    [keyboard.isVisible, keyboard.height],
  );

  return scrollController;
}
