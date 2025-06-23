import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useNumber', () {
    testWidgets('should init state to initial value', (tester) async {
      final result = await buildHook((_) => useNumber(5));
      expect(result.current.value, 5);
    });

    testWidgets('should increment and decrement', (tester) async {
      final result = await buildHook((_) => useNumber(0));
      await act(() => result.current.inc());
      expect(result.current.value, 1);
      await act(() => result.current.dec());
      expect(result.current.value, 0);
    });

    testWidgets('should increment by custom value', (tester) async {
      final result = await buildHook((_) => useNumber(10));
      await act(() => result.current.inc(5));
      expect(result.current.value, 15);
      await act(() => result.current.dec(3));
      expect(result.current.value, 12);
    });

    testWidgets('should get value', (tester) async {
      final result = await buildHook((_) => useNumber(100));
      expect(result.current.value, 100);
    });

    testWidgets('should reset to initial value', (tester) async {
      final result = await buildHook((_) => useNumber(50));
      await act(() => result.current.inc(25));
      expect(result.current.value, 75);
      await act(() => result.current.reset());
      expect(result.current.value, 50);
    });

    testWidgets('should respect min boundary', (tester) async {
      final result = await buildHook((_) => useNumber(5, min: 0));
      await act(() => result.current.dec(10));
      expect(result.current.value, 0);
    });

    testWidgets('should respect max boundary', (tester) async {
      final result = await buildHook((_) => useNumber(5, max: 10));
      await act(() => result.current.inc(10));
      expect(result.current.value, 10);
    });
  });
}
