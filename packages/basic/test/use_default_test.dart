import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_testing.dart';

void main() {
  group('useDefault', () {
    [
      {
        'initialValue': 123,
        'defaultValue': 456,
        'anotherValue': 789,
      },
      {
        'initialValue': 'init',
        'defaultValue': 'default',
        'anotherValue': 'another',
      },
      {
        'initialValue': false,
        'defaultValue': false,
        'anotherValue': true,
      },
      {
        'initialValue': [1, 2, 3],
        'defaultValue': [4, 5, 6],
        'anotherValue': [7, 8, 9],
      },
      {
        'initialValue': {'name': 'Marshall'},
        'defaultValue': {'name': 'Mathers'},
        'anotherValue': {'name': 'Wasabeef'},
      },
      // ignore: avoid_function_literals_in_foreach_calls
    ].forEach((map) {
      final initialValue = map['initialValue'];
      final defaultValue = map['defaultValue'];
      final anotherValue = map['anotherValue'];

      group(
          'when value type is ${initialValue.runtimeType} ($initialValue, $defaultValue, $anotherValue)',
          () {
        testWidgets('should init state with initial value', (tester) async {
          final result = await buildHook(
            (initialValue) => useDefault(defaultValue, initialValue),
            initialProps: initialValue,
          );

          expect(result.current.value, initialValue);
        });

        testWidgets('should set state to another value', (tester) async {
          final result = await buildHook(
            (initialValue) => useDefault(defaultValue, initialValue),
            initialProps: initialValue,
          );
          await act(() => result.current.value = anotherValue);
          expect(result.current.value, anotherValue);
        });

        testWidgets('should return default value if state set to null',
            (tester) async {
          final result = await buildHook(
            (initialValue) => useDefault(defaultValue, initialValue),
            initialProps: initialValue,
          );
          await act(() => result.current.value = null);
          expect(result.current.value, defaultValue);
        });
        testWidgets(
            'should handle state properly after being set to null and then to another value',
            (tester) async {
          final result = await buildHook(
            (initialValue) => useDefault(defaultValue, initialValue),
            initialProps: initialValue,
          );
          await act(() => result.current.value = null);
          expect(result.current.value, defaultValue);

          await act(() => result.current.value = anotherValue);
          expect(result.current.value, anotherValue);
        });
      });
    });
  });
}
