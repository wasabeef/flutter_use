import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_test.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  testWidgets('useEffectOnce should run provided effect only once',
      (tester) async {
    final effect = MockEffect();
    final result = await buildHook(
      () => useEffectOnce(() {
        effect();
      }),
    );
    await result.rebuild();
    verify(effect()).called(1);
    verifyNoMoreInteractions(effect);
  });

  testWidgets('useEffectOnce should run dispose only once after unmount',
      (tester) async {
    final effect = MockEffect();
    final dispose = MockDispose();
    final result = await buildHook(
      () => useEffectOnce(() {
        effect();
        return () => dispose();
      }),
    );
    verify(effect()).called(1);
    verifyNoMoreInteractions(effect);

    await result.unmount();
    verify(dispose()).called(1);
    verifyNoMoreInteractions(dispose);
  });
}
