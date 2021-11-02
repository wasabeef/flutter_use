import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('useTemplate basic', (tester) async {
    late ValueNotifier<int> state;
    late HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useState(42);
        return Container();
      },
    ));

    expect(state.value, 42);
    expect(element.dirty, false);

    await tester.pump();

    expect(state.value, 42);
    expect(element.dirty, false);

    state.value++;
    expect(element.dirty, true);
    await tester.pump();

    expect(state.value, 43);
    expect(element.dirty, false);

    // dispose
    await tester.pumpWidget(const SizedBox());

    // ignore: invalid_use_of_protected_member
    expect(() => state.hasListeners, throwsFlutterError);
  });
}
