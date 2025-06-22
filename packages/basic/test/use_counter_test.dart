import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useCounter', () {
    testWidgets('should init counter and utils', (tester) async {
      final result = await buildHook((_) => useCounter(5));

      expect(result.current.value, 5);
      expect(result.current.inc, isA<Function>());
      expect(result.current.dec, isA<Function>());
      expect(result.current.getter, isA<Function>());
      expect(result.current.setter, isA<Function>());
      expect(result.current.reset, isA<Function>());
    });
    testWidgets('should init counter to negative number', (tester) async {
      final result = await buildHook((_) => useCounter(-2));
      expect(result.current.value, -2);
    });
    testWidgets('should get current counter', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      expect(result.current.getter(), 5);
    });
    testWidgets('should increment by 1 if not value received', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      await act(() => result.current.inc());
      expect(result.current.value, 6);
    });
    testWidgets('should increment by value received', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      await act(() => result.current.inc(9));
      expect(result.current.value, 14);
    });
    testWidgets('should decrement by 1 if not value received', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      await act(() => result.current.dec());
      expect(result.current.value, 4);
    });
    testWidgets('should decrement by value received', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      await act(() => result.current.dec(9));
      expect(result.current.value, -4);
    });
    testWidgets('should set to value received', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      await act(() => result.current.setter(17));
      expect(result.current.value, 17);
    });
    testWidgets('should reset to original value', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      await act(() => result.current.setter(17));
      expect(result.current.value, 17);
      await act(() => result.current.reset());
      expect(result.current.value, 5);
    });
    testWidgets('should reset and set new original value', (tester) async {
      final result = await buildHook((_) => useCounter(5));
      // set different value than initial one...
      await act(() => result.current.setter(17));
      expect(result.current.value, 17);

      // ... now reset and set it to different than initial one...
      await act(() => result.current.reset(8));
      expect(result.current.value, 8);

      // ... and set different value than initial one again...
      await act(() => result.current.setter(32));
      expect(result.current.value, 32);

      // ... and reset it to new initial value
      await act(() => result.current.reset());
      expect(result.current.value, 8);
      expect(result.current.getter(), 8);
    });
    testWidgets('should not exceed max value', (tester) async {
      expect(() => useCounter(10, max: 5), throwsArgumentError);
      final result = await buildHook((_) => useCounter(5, max: 5));

      await act(() => result.current.reset(10));
      expect(result.current.value, 5);

      await act(() => result.current.reset(4));
      expect(result.current.value, 4);

      await act(() => result.current.inc());
      expect(result.current.value, 5);

      await act(() => result.current.inc());
      expect(result.current.value, 5);
    });

    testWidgets('should not exceed min value', (tester) async {
      expect(() => useCounter(3, min: 5), throwsArgumentError);
      final result = await buildHook((_) => useCounter(5, min: 5));

      await act(() => result.current.reset(4));
      expect(result.current.value, 5);

      await act(() => result.current.reset(-10));
      expect(result.current.value, 5);

      await act(() => result.current.dec());
      expect(result.current.value, 5);

      await act(() => result.current.dec());
      expect(result.current.value, 5);
    });

    testWidgets('should not exceed the range', (tester) async {
      final result = await buildHook((_) => useCounter(5, min: 5, max: 10));

      await act(() => result.current.reset(1));
      expect(result.current.value, 5);

      await act(() => result.current.reset(20));
      expect(result.current.value, 10);
    });
  });
}
