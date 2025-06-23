import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useException', () {
    testWidgets('should init with null value', (tester) async {
      final result = await buildHook((_) => useException());
      expect(result.current.value, null);
    });

    testWidgets('should dispatch exception', (tester) async {
      final result = await buildHook((_) => useException());
      final exception = Exception('Test error');

      await act(() => result.current.dispatch(exception));
      expect(result.current.value, exception);
    });

    testWidgets('should update exception value', (tester) async {
      final result = await buildHook((_) => useException());
      final exception1 = Exception('Error 1');
      final exception2 = Exception('Error 2');

      await act(() => result.current.dispatch(exception1));
      expect(result.current.value, exception1);

      await act(() => result.current.dispatch(exception2));
      expect(result.current.value, exception2);
    });

    testWidgets('should persist exception across rebuilds', (tester) async {
      final result = await buildHook((_) => useException());
      final exception = Exception('Persistent error');

      await act(() => result.current.dispatch(exception));
      expect(result.current.value, exception);

      await result.rebuild();
      expect(result.current.value, exception);
    });

    testWidgets('should handle custom exception types', (tester) async {
      final result = await buildHook((_) => useException());
      const customException = FormatException('Invalid format');

      await act(() => result.current.dispatch(customException));
      expect(result.current.value, customException);
      expect(result.current.value is FormatException, true);
    });
  });
}
