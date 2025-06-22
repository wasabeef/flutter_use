import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useLogger', () {
    final logs = <String>[];
    late void Function(String? message, {int? wrapWidth}) originalDebugPrint;

    setUp(() {
      logs.clear();
      originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };
    });

    tearDown(() {
      debugPrint = originalDebugPrint;
    });

    testWidgets('should log mount', (tester) async {
      await buildHook((_) => useLogger('TestComponent'));

      expect(logs.length, 1);
      expect(logs[0], 'TestComponent mounted {}');

      // Explicit reset at end of test
      debugPrint = originalDebugPrint;
    });

    testWidgets('should log mount with props', (tester) async {
      await buildHook(
        (_) => useLogger('TestComponent', props: {'id': 123, 'name': 'test'}),
      );

      expect(logs.length, 1);
      expect(logs[0], 'TestComponent mounted {id: 123, name: test}');

      // Explicit reset at end of test
      debugPrint = originalDebugPrint;
    });

    testWidgets('should log unmount', (tester) async {
      final result = await buildHook((_) => useLogger('TestComponent'));
      logs.clear();

      await result.unmount();

      expect(logs.length, 1);
      expect(logs[0], 'TestComponent unmounted');

      // Explicit reset at end of test
      debugPrint = originalDebugPrint;
    });

    testWidgets('should log update on rebuild', (tester) async {
      final result = await buildHook((_) => useLogger('TestComponent'));
      logs.clear();

      await result.rebuild();

      expect(logs.length, 1);
      expect(logs[0], 'TestComponent updated {}');

      // Explicit reset at end of test
      debugPrint = originalDebugPrint;
    });

    testWidgets('should log full lifecycle', (tester) async {
      final result = await buildHook(
        (_) => useLogger('TestComponent', props: {'count': 1}),
      );

      expect(logs.length, 1);
      expect(logs[0], 'TestComponent mounted {count: 1}');

      await result.rebuild();

      expect(logs.length, 2);
      expect(logs[1], 'TestComponent updated {count: 1}');

      await result.unmount();

      expect(logs.length, 3);
      expect(logs[2], 'TestComponent unmounted');

      // Explicit reset at end of test
      debugPrint = originalDebugPrint;
    });

    testWidgets('should not log update on first render', (tester) async {
      await buildHook((_) => useLogger('TestComponent'));

      expect(logs.length, 1);
      expect(logs.any((log) => log.contains('updated')), false);

      // Explicit reset at end of test
      debugPrint = originalDebugPrint;
    });
  });
}
