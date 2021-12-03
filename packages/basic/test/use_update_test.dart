import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_testing.dart';

void main() {
  group('useUpdate', () {
    testWidgets(
        'should re-build component each time returned function is called',
        (tester) async {
      var buildCount = 0;
      final result = await buildHook((_) {
        buildCount++;
        return useUpdate();
      });
      final update = result.current;

      expect(buildCount, 1);

      await act(() => update());
      expect(buildCount, 2);

      await act(() => update());
      expect(buildCount, 3);
    });
  });
}
