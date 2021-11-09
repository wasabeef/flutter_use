import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  testWidgets('useInterval basic use-case', (tester) async {
    final effect = MockEffect();

    Widget builder() {
      return HookBuilder(builder: (context) {
        useInterval(
          effect,
          delay: const Duration(milliseconds: 100),
        );
        return Container();
      });
    }

    await tester.pumpWidget(builder());
    await tester.pump(const Duration(milliseconds: 1000));
    verify(effect()).called(10);
    verifyNoMoreInteractions(effect);
  });

  testWidgets('useInterval paused use-case', (tester) async {
    final effect = MockEffect();
    const key = Key('button');

    Widget builder() {
      return HookBuilder(builder: (context) {
        final isRunning = useState(true);
        useInterval(
          effect,
          delay: isRunning.value ? const Duration(milliseconds: 100) : null,
        );
        return GestureDetector(
            key: key,
            onTap: () {
              isRunning.value = false;
            });
      });
    }

    await tester.pumpWidget(builder());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 500));
    verify(effect()).called(5);
    verifyNoMoreInteractions(effect);
  });
}
