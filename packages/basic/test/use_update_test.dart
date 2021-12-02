import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'flutter_hooks_test.dart';

void main() {
  testWidgets('useUpdate basic use-case', (tester) async {
    var buildCount = 0;
    final result = await buildHook(() {
      buildCount++;
      return useUpdate();
    });
    // final update = result.current;

    expect(buildCount, 1);

    await result.rebuild();
    // or await act(() => update());
    expect(buildCount, 2);

    await result.rebuild();
    // or await act(() => update());
    expect(buildCount, 3);
  });
}
