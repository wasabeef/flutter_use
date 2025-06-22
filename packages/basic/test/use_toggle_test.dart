import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useToggle', () {
    testWidgets('should init state to true', (tester) async {
      final result = await buildHook((_) => useToggle(true));
      expect(result.current.value, true);
    });

    testWidgets('should init state to false', (tester) async {
      final result = await buildHook((_) => useToggle(false));
      expect(result.current.value, false);
    });

    testWidgets('should set state to true', (tester) async {
      final result = await buildHook((_) => useToggle(false));
      await act(() => result.current.toggle(true));
      expect(result.current.value, true);
    });

    testWidgets('should set state to false', (tester) async {
      final result = await buildHook((_) => useToggle(true));
      await act(() => result.current.toggle(false));
      expect(result.current.value, false);
    });

    testWidgets('should toggle state from true', (tester) async {
      final result = await buildHook((_) => useToggle(true));
      await act(() => result.current.toggle());
      expect(result.current.value, false);
    });

    testWidgets('should toggle state from false', (tester) async {
      final result = await buildHook((_) => useToggle(false));
      await act(() => result.current.toggle());
      expect(result.current.value, true);
    });
  });
}
