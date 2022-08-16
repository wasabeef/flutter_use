import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:mockito/mockito.dart';
import 'flutter_hooks_testing.dart';

import 'mock.dart';

void main() {
  group('useEffectOnce', () {
    testWidgets('should run provided effect only once', (tester) async {
      final effect = MockEffect();
      final result = await buildHook(
        // ignore: body_might_complete_normally_nullable
        (_) => useEffectOnce(() {
          effect();
        }),
      );
      verify(effect()).called(1);
      await result.rebuild();
      verifyNever(effect());
      verifyNoMoreInteractions(effect);
    });

    testWidgets('should run dispose only once after unmount', (tester) async {
      final dispose = MockDispose();
      final result = await buildHook(
        (_) => useEffectOnce(() {
          return () => dispose();
        }),
      );
      await result.unmount();
      verify(dispose()).called(1);
      verifyNoMoreInteractions(dispose);
    });
  });
}
