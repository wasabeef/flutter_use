import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// State object returned by [useCopyToClipboard].
class CopyToClipboardState {
  /// Creates a [CopyToClipboardState].
  const CopyToClipboardState({
    required this.copied,
    required this.error,
    required this.copy,
  });

  /// The last successfully copied text, or null if nothing was copied yet.
  final String? copied;

  /// The error that occurred during the last copy operation, if any.
  final Object? error;

  /// Copies the given text to the clipboard.
  ///
  /// Returns a [Future] that completes when the operation is done.
  /// If successful, [copied] will be updated with the text.
  /// If failed, [error] will be updated with the error.
  final Future<void> Function(String text) copy;
}

/// Provides a way to copy text to the clipboard.
///
/// Returns a [CopyToClipboardState] that contains:
/// - [CopyToClipboardState.copy]: A function to copy text to clipboard
/// - [CopyToClipboardState.copied]: The last successfully copied text
/// - [CopyToClipboardState.error]: Any error that occurred during copy
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   final clipboard = useCopyToClipboard();
///
///   return Column(
///     children: [
///       if (clipboard.error != null)
///         Text('Error: ${clipboard.error}'),
///       if (clipboard.copied != null)
///         Text('Copied: ${clipboard.copied}'),
///       ElevatedButton(
///         onPressed: () => clipboard.copy('Hello, World!'),
///         child: Text('Copy to clipboard'),
///       ),
///     ],
///   );
/// }
/// ```
CopyToClipboardState useCopyToClipboard() {
  final copied = useState<String?>(null);
  final error = useState<Object?>(null);

  final copy = useCallback<Future<void> Function(String)>(
    (text) async {
      try {
        await Clipboard.setData(ClipboardData(text: text));
        copied.value = text;
        error.value = null;
      } on Exception catch (e) {
        error.value = e;
      }
    },
    [],
  );

  return CopyToClipboardState(
    copied: copied.value,
    error: error.value,
    copy: copy,
  );
}
