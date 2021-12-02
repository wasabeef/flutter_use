import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_test.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  testWidgets('useMount should call provided callback on mount',
      (tester) async {
    final effect = MockEffect();
    await buildHook(() => useMount(() => effect()));
    verify(effect()).called(1);
    verifyNoMoreInteractions(effect);
  });

  testWidgets('useMount should not call provided callback on unmount',
      (tester) async {
    final effect = MockEffect();
    final result = await buildHook(() => useMount(() => effect()));
    verify(effect()).called(1);
    verifyNoMoreInteractions(effect);

    await result.unmount();
    verifyNever(effect());
    verifyNoMoreInteractions(effect);
  });

  testWidgets('useMount should not call provided callback on rebuild',
      (tester) async {
    final effect = MockEffect();
    final result = await buildHook(() => useMount(() => effect()));
    await result.rebuild();
    verify(effect()).called(1);
    verifyNoMoreInteractions(effect);
  });
}
