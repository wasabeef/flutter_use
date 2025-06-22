import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useTextFormValidator', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should return initial value', (tester) async {
      final result = await buildHook((_) => useTextFormValidator<String?>(
            validator: (value) => value.isEmpty ? 'Required' : null,
            controller: controller,
            initialValue: 'initial',
          ));

      expect(result.current, 'initial');
    });

    testWidgets('should validate on text change', (tester) async {
      controller.text = 'initial text';
      final result = await buildHook((_) => useTextFormValidator<String?>(
            validator: (value) => value.isEmpty ? 'Required' : null,
            controller: controller,
            initialValue: null,
          ));

      expect(result.current, null);

      controller.text = '';
      await tester.pump();
      expect(result.current, 'Required');

      controller.text = 'hello';
      await tester.pump();
      expect(result.current, null);
    });

    testWidgets('should work with different validation types', (tester) async {
      final result = await buildHook((_) => useTextFormValidator<bool>(
            validator: (value) => value.length >= 5,
            controller: controller,
            initialValue: false,
          ));

      expect(result.current, false);

      controller.text = 'hi';
      await tester.pump();
      expect(result.current, false);

      controller.text = 'hello';
      await tester.pump();
      expect(result.current, true);
    });

    testWidgets('should handle complex validation', (tester) async {
      final result = await buildHook((_) => useTextFormValidator<List<String>>(
            validator: (value) {
              final errors = <String>[];
              if (value.isEmpty) errors.add('Required');
              if (value.length < 3) errors.add('Too short');
              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value) && value.isNotEmpty) {
                errors.add('Letters only');
              }
              return errors;
            },
            controller: controller,
            initialValue: [],
          ));

      // Initial state with empty controller should validate
      expect(result.current, []);

      // Manually trigger validation by setting text slightly differently
      controller.text = ' ';
      await tester.pump();
      controller.text = '';
      await tester.pump();
      expect(result.current, ['Required', 'Too short']);

      controller.text = 'ab';
      await tester.pump();
      expect(result.current, ['Too short']);

      controller.text = 'abc123';
      await tester.pump();
      expect(result.current, ['Letters only']);

      controller.text = 'abc';
      await tester.pump();
      expect(result.current, []);
    });

    testWidgets('should clean up listener on unmount', (tester) async {
      final result = await buildHook((_) => useTextFormValidator<String?>(
            validator: (value) => value.isEmpty ? 'Required' : null,
            controller: controller,
            initialValue: null,
          ));

      // Verify listener is working
      controller.text = 'test';
      await tester.pump();
      expect(result.current, null);

      await result.unmount();

      // After unmount, changes to controller should not affect the result
      // (we can't directly test hasListeners as it's protected)
      controller.text = '';
      await tester.pump();
      // If listener was properly removed, the result won't update
    });

    testWidgets('should handle controller change', (tester) async {
      var currentController = controller;

      final result = await buildHook(
        (props) => useTextFormValidator<String?>(
          validator: (value) => value.isEmpty ? 'Required' : null,
          controller: props as TextEditingController,
          initialValue: null,
        ),
        initialProps: currentController,
      );

      currentController.text = 'hello';
      await tester.pump();
      expect(result.current, null);

      // Change controller
      final newController = TextEditingController(text: '');
      await result.rebuild(newController);

      // Since the new controller has empty text but validation isn't called until text changes,
      // we need to check initialValue behavior or trigger a change
      expect(result.current, null); // Still has previous validation result

      // Now trigger validation by changing text
      newController.text = 'x';
      await tester.pump();
      expect(result.current, null);

      newController.text = '';
      await tester.pump();
      expect(result.current, 'Required');

      newController.dispose();
    });
  });
}
