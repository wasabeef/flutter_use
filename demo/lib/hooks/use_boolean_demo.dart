import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseBooleanDemo extends HookWidget {
  const UseBooleanDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final boolean = useBoolean(false);
    final darkMode = useBoolean(true);
    final isExpanded = useBoolean(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useBoolean Demo'),
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
              '🔵 useBoolean Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Boolean state management with toggle, set true/false',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Basic Boolean Toggle
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎯 Basic Boolean Toggle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: boolean.value
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: boolean.value ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            boolean.value ? Icons.check_circle : Icons.cancel,
                            color: boolean.value ? Colors.green : Colors.red,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            boolean.value ? 'TRUE' : 'FALSE',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: boolean.value ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Control Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: boolean.toggle,
                            icon: const Icon(Icons.swap_horiz),
                            label: const Text('Toggle'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => boolean.toggle(true),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            child: const Text('Set True'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => boolean.toggle(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Set False'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Dark Mode Example
            Card(
              elevation: 4,
              color: darkMode.value ? Colors.grey[900] : null,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🌙 Dark Mode Toggle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkMode.value ? Colors.white : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Icon(
                          darkMode.value ? Icons.dark_mode : Icons.light_mode,
                          size: 48,
                          color: darkMode.value ? Colors.amber : Colors.orange,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                darkMode.value
                                    ? 'Dark Mode Active'
                                    : 'Light Mode Active',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: darkMode.value ? Colors.white : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Toggle to switch theme',
                                style: TextStyle(
                                  color: darkMode.value
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: darkMode.value,
                          onChanged: (_) => darkMode.toggle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Expandable Section Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📦 Expandable Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    InkWell(
                      onTap: isExpanded.toggle,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Click to expand/collapse',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            AnimatedRotation(
                              turns: isExpanded.value ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(Icons.expand_more),
                            ),
                          ],
                        ),
                      ),
                    ),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: isExpanded.value
                          ? Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'This is the expanded content! 🎉\n\n'
                                'The useBoolean hook makes it easy to manage '
                                'toggle states like expand/collapse, show/hide, '
                                'and any other binary state in your application.',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

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
                      '• Simple boolean state management\n'
                      '• toggle() method to flip the value\n'
                      '• toggle(true) and toggle(false) for explicit setting\n'
                      '• Perfect for switches, checkboxes, visibility toggles\n'
                      '• Returns ToggleState with value and toggle method',
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

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useBoolean Code Example'),
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
                '''// Initialize with default value
final isVisible = useBoolean(true);
final darkMode = useBoolean(false);

// Access the value
if (isVisible.value) {
  // Show content
}

// Toggle the value
ElevatedButton(
  onPressed: isVisible.toggle,
  child: Text('Toggle Visibility'),
)

// Set explicitly
TextButton(
  onPressed: () => darkMode.toggle(true),
  child: Text('Enable Dark Mode'),
)

// Use with Switch widget
Switch(
  value: darkMode.value,
  onChanged: (_) => darkMode.toggle(),
)''',
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
