import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_test.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  testWidgets('should init hook with default delay', (tester) async {
    final effect = MockEffect();

    await buildHook(() => useInterval(effect));
    await tester.pump(const Duration(milliseconds: 1000));
    verify(effect()).called(10);
  });

  testWidgets('useInterval should init hook with custom delay', (tester) async {
    final effect = MockEffect();

    await buildHook(() {
      useInterval(effect, const Duration(milliseconds: 500));
    });
    await tester.pump(const Duration(milliseconds: 1000));
    verify(effect()).called(2);
  });

  testWidgets('useInterval should init hook without delay', (tester) async {
    final effect = MockEffect();

    await buildHook(() {
      useInterval(effect, null);
    });
    await tester.pump(const Duration(milliseconds: 1000));
    verifyNever(effect());
  });

  testWidgets('useInterval should pending when delay changed to null',
      (tester) async {
    final effect = MockEffect();

    var isRunning = true;
    final result = await buildHook(() {
      useInterval(
        effect,
        isRunning ? const Duration(milliseconds: 100) : null,
      );
    });

    await tester.pump(const Duration(milliseconds: 500));

    isRunning = false;
    await result.rebuild();

    await tester.pump(const Duration(seconds: 1000));
    verify(effect()).called(5);
    verifyNoMoreInteractions(effect);
  });
}
