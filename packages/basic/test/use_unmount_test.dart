import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_testing.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  group('useUnmount', () {
    testWidgets('should not call provided callback on mount', (tester) async {
      final effect = MockEffect();
      await buildHook((_) => useUnmount(effect));
      verifyNever(effect());
    });

    testWidgets('should not call provided callback on re-builds',
        (tester) async {
      final effect = MockEffect();
      final result = await buildHook((_) => useUnmount(effect));

      await result.rebuild();
      await result.rebuild();
      await result.rebuild();
      await result.rebuild();
      await result.rebuild();

      verifyNever(effect());
    });

    testWidgets('should call provided callback on unmount', (tester) async {
      final effect = MockEffect();
      final result = await buildHook((_) => useUnmount(effect));

      await result.unmount();
      verify(effect()).called(1);
      verifyNoMoreInteractions(effect);
    });
  });
}
