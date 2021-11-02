import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/src/use_effect_once.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  testWidgets('useEffectOnce basic use-case', (tester) async {
    final effect = MockEffect();
    final unrelated = MockWidgetBuild();
    final dispose = MockDispose();

    when(effect()).thenReturn(dispose);

    Widget builder() {
      return HookBuilder(builder: (context) {
        useEffectOnce(effect);
        unrelated();
        return Container();
      });
    }

    await tester.pumpWidget(builder());

    verifyInOrder([
      effect(),
      unrelated(),
    ]);

    verifyNoMoreInteractions(effect);
    verifyNoMoreInteractions(unrelated);

    await tester.pumpWidget(Container());

    verifyInOrder([
      dispose(),
    ]);

    verifyNoMoreInteractions(dispose);
  });

  testWidgets('useEffectOnce called once', (tester) async {
    final effect = MockEffect();
    Widget builder() {
      return HookBuilder(builder: (context) {
        useEffectOnce(effect);
        return Container();
      });
    }

    await tester.pumpWidget(builder());
    verify(effect()).called(1);
    verifyNoMoreInteractions(effect);
  });
}
