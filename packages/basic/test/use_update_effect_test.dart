import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'mock.dart';

void main() {
  group('useUpdateEffect', () {
    testWidgets('should run effect on update', (tester) async {
      final effect = MockDispose();
      final result = await buildHook((_) {
        // ignore: body_might_complete_normally_nullable
        // ignore: unnecessary_lambdas
        useUpdateEffect(() {
          effect();
          return null;
        });
      });
      verifyNever(effect());
      await result.rebuild();
      verify(effect()).called(1);
    });
    testWidgets('should run cleanup on unmount', (tester) async {
      final dispose = MockDispose();
      final result = await buildHook((_) {
        useUpdateEffect(() => dispose);
      });
      await result.rebuild();
      await result.unmount();
      verify(dispose()).called(1);
    });
  });
}
