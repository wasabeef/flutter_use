import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useFirstMountState', () {
    testWidgets('should return true on first mount', (tester) async {
      final result = await buildHook((_) => useFirstMountState());
      expect(result.current, true);
    });

    testWidgets('should return false on subsequent builds', (tester) async {
      final result = await buildHook((_) => useFirstMountState());
      expect(result.current, true);

      await result.rebuild();
      expect(result.current, false);

      await result.rebuild();
      expect(result.current, false);
    });

    testWidgets('should return true again after unmount and remount',
        (tester) async {
      final result = await buildHook((_) => useFirstMountState());
      expect(result.current, true);

      await result.rebuild();
      expect(result.current, false);

      await result.unmount();

      // Create a new instance
      final newResult = await buildHook((_) => useFirstMountState());
      expect(newResult.current, true);
    });

    testWidgets('should work correctly with multiple hooks', (tester) async {
      bool? firstMount1;
      bool? firstMount2;

      final result = await buildHook((_) {
        firstMount1 = useFirstMountState();
        firstMount2 = useFirstMountState();
        return null;
      });

      expect(firstMount1, true);
      expect(firstMount2, true);

      await result.rebuild();

      await buildHook((_) {
        firstMount1 = useFirstMountState();
        firstMount2 = useFirstMountState();
        return null;
      });

      expect(firstMount1, false);
      expect(firstMount2, false);
    });
  });
}
