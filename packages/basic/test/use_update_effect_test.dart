import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:mockito/mockito.dart';
import 'flutter_hooks_testing.dart';
import 'mock.dart';

void main() {
  group('useUpdateEffect', () {
    testWidgets('should run effect on update', (tester) async {
      final effect = MockDispose();
      final result = await buildHook((_) {
        useUpdateEffect(() {
          effect();
        });
      });
      verifyNever(effect());
      await result.rebuild();
      verify(effect()).called(1);
    });
    testWidgets('should run cleanup on unmount', (tester) async {
      final dispose = MockDispose();
      final result = await buildHook((_) {
        useUpdateEffect(() {
          return dispose;
        });
      });
      await result.rebuild();
      await result.unmount();
      verify(dispose()).called(1);
    });
  });
}
