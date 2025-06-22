import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_testing.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  group('useInterval', () {
    testWidgets('should init hook with default delay', (tester) async {
      final effect = MockEffect();

      await buildHook((_) => useInterval(effect));
      await tester.pump(const Duration(milliseconds: 1000));
      verify(effect()).called(10);
    });

    testWidgets('should init hook with custom delay', (tester) async {
      final effect = MockEffect();

      await buildHook((_) {
        useInterval(effect, const Duration(milliseconds: 500));
      });
      await tester.pump(const Duration(milliseconds: 1000));
      verify(effect()).called(2);
    });

    testWidgets('should init hook without delay', (tester) async {
      final effect = MockEffect();

      await buildHook((_) {
        useInterval(effect, null);
      });
      await tester.pump(const Duration(milliseconds: 1000));
      verifyNever(effect());
    });

    testWidgets('should pending when delay changed to null', (tester) async {
      final effect = MockEffect();

      final result = await buildHook(
        (isRunning) {
          useInterval(
            effect,
            (isRunning as bool? ?? false)
                ? const Duration(milliseconds: 100)
                : null,
          );
        },
        initialProps: true,
      );

      await tester.pump(const Duration(milliseconds: 500));

      await result.rebuild(false);

      await tester.pump(const Duration(seconds: 1000));
      verify(effect()).called(5);
      verifyNoMoreInteractions(effect);
    });
  });
}
