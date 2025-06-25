import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

void main() {
  group('useKeyboard', () {
    testWidgets('should detect keyboard visibility', (tester) async {
      late KeyboardState keyboardState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestKeyboardWidget(
              onStateChanged: (state) => keyboardState = state,
            ),
          ),
        ),
      );

      // Initially keyboard should be hidden
      expect(keyboardState.isVisible, isFalse);
      expect(keyboardState.isHidden, isTrue);
      expect(keyboardState.height, equals(0.0));

      // Focus text field to show keyboard
      await tester.tap(find.byType(TextField));
      await tester.pump();

      // Note: In test environment, keyboard doesn't actually show
      // so we can't test the actual keyboard detection.
      // This would need to be tested on a real device or emulator.
    });

    test('should create KeyboardState with copyWith', () async {
      const state = KeyboardState(
        isVisible: false,
        height: 0.0,
        animationDuration: Duration(milliseconds: 250),
      );

      final newState = state.copyWith(
        isVisible: true,
        height: 300.0,
      );

      expect(newState.isVisible, isTrue);
      expect(newState.height, equals(300.0));
      expect(newState.animationDuration, equals(state.animationDuration));
    });
  });

  group('useKeyboardExtended', () {
    testWidgets('should provide dismiss functionality', (tester) async {
      KeyboardStateExtended? keyboardState;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestKeyboardExtendedWidget(
              focusNode: focusNode,
              onStateChanged: (state) => keyboardState = state,
            ),
          ),
        ),
      );

      // Focus text field
      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      // Dismiss keyboard
      await tester.tap(find.text('Dismiss'));
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);

      // Use keyboardState to avoid unused variable warning
      expect(keyboardState, isNotNull);
    });

    test('should calculate viewport height and percentage', () async {
      // Create a mock state
      const state = KeyboardStateExtended(
        isVisible: true,
        height: 300.0,
        animationDuration: Duration(milliseconds: 250),
        dismiss: _dummyCallback,
        bottomInset: 300.0,
        viewportHeight: 500.0, // 800 total - 300 keyboard
      );

      expect(state.heightPercentage, equals(0.6)); // 300/500 = 0.6

      // Test with zero viewport
      const zeroState = KeyboardStateExtended(
        isVisible: false,
        height: 0.0,
        animationDuration: Duration(milliseconds: 250),
        dismiss: _dummyCallback,
        bottomInset: 0.0,
        viewportHeight: 0.0,
      );

      expect(zeroState.heightPercentage, equals(0.0));
    });
  });

  group('useIsKeyboardVisible', () {
    testWidgets('should return boolean visibility', (tester) async {
      late bool isVisible;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestKeyboardVisibilityWidget(
              onVisibilityChanged: (visible) => isVisible = visible,
            ),
          ),
        ),
      );

      expect(isVisible, isFalse);
    });
  });

  group('useKeyboardAwareScroll', () {
    testWidgets('should provide scroll controller', (tester) async {
      late ScrollController scrollController;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _TestKeyboardAwareScrollWidget(
              onControllerChanged: (controller) =>
                  scrollController = controller,
            ),
          ),
        ),
      );

      expect(scrollController.hasClients, isTrue);

      // Test scrolling
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();

      expect(scrollController.offset, greaterThan(0));
    });

    testWidgets('should use custom config', (tester) async {
      const config = KeyboardScrollConfig(
        extraScrollPadding: 50.0,
        animateScroll: false,
        scrollDuration: Duration(milliseconds: 500),
        scrollCurve: Curves.linear,
      );

      late ScrollController controller;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              controller = useKeyboardAwareScroll(config: config);
              return Container();
            },
          ),
        ),
      );

      expect(controller, isA<ScrollController>());
    });

    testWidgets('should use provided controller', (tester) async {
      final providedController = ScrollController();
      late ScrollController returnedController;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              returnedController =
                  useKeyboardAwareScroll(controller: providedController);
              return Container();
            },
          ),
        ),
      );

      expect(returnedController, equals(providedController));
    });
  });
}

void _dummyCallback() {}

class _TestKeyboardWidget extends HookWidget {
  const _TestKeyboardWidget({required this.onStateChanged});

  final void Function(KeyboardState state) onStateChanged;

  @override
  Widget build(BuildContext context) {
    final keyboardState = useKeyboard();
    onStateChanged(keyboardState);

    return Column(
      children: [
        const TextField(),
        Text('Keyboard visible: ${keyboardState.isVisible}'),
        Text('Keyboard height: ${keyboardState.height}'),
      ],
    );
  }
}

class _TestKeyboardExtendedWidget extends HookWidget {
  const _TestKeyboardExtendedWidget({
    required this.focusNode,
    required this.onStateChanged,
  });

  final FocusNode focusNode;
  final void Function(KeyboardStateExtended state) onStateChanged;

  @override
  Widget build(BuildContext context) {
    final keyboardState = useKeyboardExtended();
    onStateChanged(keyboardState);

    return Column(
      children: [
        TextField(focusNode: focusNode),
        ElevatedButton(
          onPressed: keyboardState.dismiss,
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}

class _TestKeyboardVisibilityWidget extends HookWidget {
  const _TestKeyboardVisibilityWidget({required this.onVisibilityChanged});

  final void Function(bool visible) onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    final isVisible = useIsKeyboardVisible();
    onVisibilityChanged(isVisible);
    return const TextField();
  }
}

class _TestKeyboardAwareScrollWidget extends HookWidget {
  const _TestKeyboardAwareScrollWidget({required this.onControllerChanged});

  final void Function(ScrollController controller) onControllerChanged;

  @override
  Widget build(BuildContext context) {
    final scrollController = useKeyboardAwareScroll();
    onControllerChanged(scrollController);

    return ListView(
      controller: scrollController,
      children: List.generate(
        20,
        (index) => ListTile(
          title: Text('Item $index'),
          subtitle: index == 10 ? const TextField() : null,
        ),
      ),
    );
  }
}
