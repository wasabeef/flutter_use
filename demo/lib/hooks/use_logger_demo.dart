import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseLoggerDemo extends HookWidget {
  const UseLoggerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final text = useState('');
    final enabled = useState(true);
    final logs = useState<List<String>>([]);

    // Log component lifecycle and props changes
    useLogger(
      'UseLoggerDemo',
      props: {
        'count': count.value,
        'text': text.value,
        'enabled': enabled.value,
      },
    );

    // Capture console output for display
    useEffect(() {
      // In a real app, you'd capture actual console output
      // For demo, we'll simulate logs
      logs.value = [
        '🔄 UseLoggerDemo updated',
        'Props: {count: ${count.value}, text: "${text.value}", enabled: ${enabled.value}}',
        ...logs.value.take(18),
      ];
      return null;
    }, [count.value, text.value, enabled.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useLogger Demo'),
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
            const Text(
              '📝 useLogger Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Debug component lifecycle and state changes',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔍 Component Debugging',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Interactive controls
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Counter control
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.numbers),
                              const SizedBox(width: 12),
                              const Text(
                                'Count:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => count.value--,
                                icon: const Icon(Icons.remove),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${count.value}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => count.value++,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Text input
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Text Input',
                            hintText: 'Type to see prop changes...',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                          onChanged: (value) => text.value = value,
                        ),

                        const SizedBox(height: 12),

                        // Toggle control
                        SwitchListTile(
                          title: const Text('Enabled'),
                          subtitle: const Text('Toggle to log state change'),
                          value: enabled.value,
                          onChanged: (value) => enabled.value = value,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Console output
                    const Text(
                      'Console Output:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: logs.value.isEmpty
                          ? const Center(
                              child: Text(
                                'No logs yet',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: logs.value.length,
                              itemBuilder: (context, index) {
                                final log = logs.value[index];
                                Color color = Colors.white;
                                if (log.contains('mounted')) {
                                  color = Colors.green;
                                } else if (log.contains('unmounted')) {
                                  color = Colors.red;
                                } else if (log.contains('updated')) {
                                  color = Colors.blue;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    log,
                                    style: TextStyle(
                                      color: color,
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => logs.value = [],
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Logs'),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Total logs: ${logs.value.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Debug tips
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Debug Tips',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Logs mount/unmount lifecycle\n'
                      '• Shows prop changes in console\n'
                      '• Useful for debugging renders\n'
                      '• Disable in production builds\n'
                      '• Great for understanding hook flow',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

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
                      '• Logs component name on mount\n'
                      '• Tracks prop changes between renders\n'
                      '• Shows unmount for cleanup tracking\n'
                      '• Conditional logging in dev mode\n'
                      '• Helps identify unnecessary renders',
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
        title: const Text('useLogger Code Example'),
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
                '''// Basic logging
useLogger('MyComponent');

// Log with props
final count = useState(0);
final name = useState('John');

useLogger('UserProfile', props: {
  'count': count.value,
  'name': name.value,
  'timestamp': DateTime.now(),
});

// Conditional logging
if (kDebugMode) {
  useLogger('DebugComponent', props: {
    'state': currentState,
    'errors': errorList,
  });
}

// Track specific values
useLogger('FormWidget', props: {
  'isValid': form.isValid,
  'isDirty': form.isDirty,
  'fields': form.fields.length,
});

// Console output:
// MyComponent mounted
// UserProfile mounted
// UserProfile updated: 
//   {count: 0 → 1}
// UserProfile unmounted''',
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
