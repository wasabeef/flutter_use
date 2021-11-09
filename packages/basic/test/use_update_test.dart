import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/src/use_update.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  testWidgets('useUpdate basic use-case', (tester) async {
    final effect = MockEffect();
    const key = Key('button');

    Widget builder() {
      return HookBuilder(builder: (context) {
        final update = useUpdate();
        effect();
        return GestureDetector(
          key: key,
          onTap: () => update(),
        );
      });
    }

    // called count is 1
    await tester.pumpWidget(builder());
    // called count is 2
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle(const Duration(milliseconds: 1));
    // called count is 3
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle(const Duration(milliseconds: 1));
    verify(effect()).called(3);
    verifyNoMoreInteractions(effect);
  });
}
