import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useCopyToClipboard', () {
    setUp(TestWidgetsFlutterBinding.ensureInitialized);

    testWidgets('should copy text to clipboard successfully', (tester) async {
      // Mock clipboard behavior
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            return null;
          }
          return null;
        },
      );

      final result = await buildHook((_) => useCopyToClipboard());

      expect(result.current.copied, isNull);
      expect(result.current.error, isNull);

      await act(() => result.current.copy('Hello, World!'));

      expect(result.current.copied, 'Hello, World!');
      expect(result.current.error, isNull);

      // Copy another text
      await act(() => result.current.copy('Another text'));

      expect(result.current.copied, 'Another text');
      expect(result.current.error, isNull);
    });

    testWidgets('should handle copy errors', (tester) async {
      // Mock clipboard behavior to throw error
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            throw PlatformException(
              code: 'error',
              message: 'Failed to copy',
            );
          }
          return null;
        },
      );

      final result = await buildHook((_) => useCopyToClipboard());

      await act(() => result.current.copy('This will fail'));

      expect(result.current.copied, isNull);
      expect(result.current.error, isA<PlatformException>());
      expect(
        (result.current.error as PlatformException).message,
        'Failed to copy',
      );
    });

    testWidgets('should preserve last copied text after error', (tester) async {
      var shouldFail = false;

      // Mock clipboard behavior
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            if (shouldFail) {
              throw PlatformException(
                code: 'error',
                message: 'Failed to copy',
              );
            }
            return null;
          }
          return null;
        },
      );

      final result = await buildHook((_) => useCopyToClipboard());

      // First copy should succeed
      await act(() => result.current.copy('Success text'));
      expect(result.current.copied, 'Success text');
      expect(result.current.error, isNull);

      // Second copy should fail
      shouldFail = true;
      await act(() => result.current.copy('Fail text'));
      expect(
        result.current.copied,
        'Success text',
      ); // Should preserve last success
      expect(result.current.error, isA<PlatformException>());

      // Third copy should succeed
      shouldFail = false;
      await act(() => result.current.copy('New success'));
      expect(result.current.copied, 'New success');
      expect(result.current.error, isNull);
    });

    testWidgets('copy function should be stable', (tester) async {
      final result = await buildHook((_) => useCopyToClipboard());

      final firstCopy = result.current.copy;

      await result.rebuild();

      // The copy function should be the same instance after rebuild
      expect(identical(firstCopy, result.current.copy), isTrue);
    });

    tearDown(() {
      // Clean up mock handlers
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
  });
}
