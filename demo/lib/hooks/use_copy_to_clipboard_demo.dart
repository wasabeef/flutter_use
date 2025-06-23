import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseCopyToClipboardDemo extends HookWidget {
  const UseCopyToClipboardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(
      text: 'Hello from Flutter Use! 🎯',
    );
    final copyToClipboard = useCopyToClipboard();

    // Sample texts for quick copy
    final sampleTexts = [
      'flutter pub add flutter_use',
      'https://github.com/wasabeef/flutter_use',
      'contact@example.com',
      '+1 (555) 123-4567',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('useCopyToClipboard Demo'),
        actions: [
          TextButton(
            onPressed: () => _showCodeDialog(context),
            child: const Text('📋 Code', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              '📋 useCopyToClipboard Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Copy text to clipboard with status feedback',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Live Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Live Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input Field
                    TextField(
                      controller: textController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Text to copy',
                        hintText:
                            'Enter any text you want to copy to clipboard',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Copy Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (textController.text.isNotEmpty) {
                            copyToClipboard.copy(textController.text);
                          }
                        },
                        icon: const Icon(Icons.content_copy),
                        label: const Text('Copy to Clipboard'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getStatusColor(copyToClipboard),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getStatusIcon(copyToClipboard),
                                color: _getStatusIconColor(copyToClipboard),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Status: ${_getStatusText(copyToClipboard)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (copyToClipboard.copied != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Last copied: "${copyToClipboard.copied}"',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (copyToClipboard.error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${copyToClipboard.error}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Copy Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚡ Quick Copy Options',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sampleTexts.map((text) {
                        return ActionChip(
                          label: Text(
                            text.length > 30
                                ? '${text.substring(0, 30)}...'
                                : text,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            copyToClipboard.copy(text);
                            textController.text = text;
                          },
                          avatar: const Icon(Icons.content_copy, size: 16),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Usage Info
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'How it works',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Provides a simple interface for clipboard operations\n'
                      '• Tracks the last successfully copied text\n'
                      '• Handles errors gracefully (permissions, platform issues)\n'
                      '• Perfect for share buttons, code snippets, and user content',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showCodeDialog(context),
                      icon: const Icon(Icons.code),
                      label: const Text('View Code Example'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(CopyToClipboardState state) {
    if (state.error != null) return Colors.red[50]!;
    if (state.copied != null) return Colors.green[50]!;
    return Colors.grey[50]!;
  }

  IconData _getStatusIcon(CopyToClipboardState state) {
    if (state.error != null) return Icons.error;
    if (state.copied != null) return Icons.check_circle;
    return Icons.info;
  }

  Color _getStatusIconColor(CopyToClipboardState state) {
    if (state.error != null) return Colors.red;
    if (state.copied != null) return Colors.green;
    return Colors.grey;
  }

  String _getStatusText(CopyToClipboardState state) {
    if (state.error != null) return 'Error occurred';
    if (state.copied != null) return 'Successfully copied';
    return 'Ready to copy';
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useCopyToClipboard Code Example'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''final copyToClipboard = useCopyToClipboard();

// Copy text to clipboard
ElevatedButton(
  onPressed: () {
    copyToClipboard.copy('Hello, World!');
  },
  child: Text('Copy Text'),
)

// Check status
if (copyToClipboard.copied != null) {
  print('Last copied: \${copyToClipboard.copied}');
}

if (copyToClipboard.error != null) {
  print('Error: \${copyToClipboard.error}');
}

// Show feedback to user
Text(copyToClipboard.copied != null 
  ? 'Copied!' 
  : 'Ready to copy')''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
