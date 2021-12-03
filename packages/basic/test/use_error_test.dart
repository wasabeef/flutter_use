import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_testing.dart';

void main() {
  group('useError', () {
    testWidgets('should return an error on error dispatch', (tester) async {
      final error = UnsupportedError('some_error');

      final result = await buildHook((_) => useError());

      await act(() {
        result.current.dispatch(error);
      });

      expect(result.current.value, error);
    });
  });
}
