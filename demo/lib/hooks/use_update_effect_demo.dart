import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseUpdateEffectDemo extends HookWidget {
  const UseUpdateEffectDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    final input = useState('');
    final updateLog = useState<List<String>>([]);
    final ignoreFirstRender = useState(true);

    // This effect runs only on updates, not on initial mount
    useUpdateEffect(() {
      final timestamp = DateTime.now().toString().substring(11, 19);
      updateLog.value = [
        '🔄 Update at $timestamp - Counter: ${counter.value}, Input: "${input.value}"',
        ...updateLog.value.take(9),
      ];
      return null;
    }, [counter.value, input.value]);

    // Comparison with regular useEffect
    useEffect(() {
      if (!ignoreFirstRender.value) {
        final timestamp = DateTime.now().toString().substring(11, 19);
        updateLog.value = [
          '📌 Regular effect at $timestamp (includes mount)',
          ...updateLog.value.take(9),
        ];
      }
      ignoreFirstRender.value = false;
      return null;
    }, [counter.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useUpdateEffect Demo'),
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
              '🔄 useUpdateEffect Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Run effects only on updates, skip initial mount',
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
                      '🎯 Update-Only Effects',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Counter control
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.numbers, size: 32),
                          const SizedBox(width: 16),
                          Text(
                            'Counter: ${counter.value}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton.filled(
                            onPressed: () => counter.value--,
                            icon: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: () => counter.value++,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Text input
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Text Input',
                        hintText: 'Type something to trigger update effect...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.text_fields),
                      ),
                      onChanged: (value) => input.value = value,
                    ),

                    const SizedBox(height: 24),

                    // Update log
                    const Text(
                      'Effect Log:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: updateLog.value.isEmpty
                          ? const Center(
                              child: Text(
                                'No updates yet. Change counter or input to see effects.',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: updateLog.value.length,
                              itemBuilder: (context, index) {
                                final log = updateLog.value[index];
                                final isUpdateEffect = log.startsWith('🔄');
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    log,
                                    style: TextStyle(
                                      color: isUpdateEffect
                                          ? Colors.blue
                                          : Colors.orange,
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: () => updateLog.value = [],
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Log'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Comparison card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.compare_arrows, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'useEffect vs useUpdateEffect',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(color: Colors.grey[300]!),
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.black12),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'useEffect',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'useUpdateEffect',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Runs on mount ✅'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Skips mount ❌'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Runs on updates ✅'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Runs on updates ✅'),
                            ),
                          ],
                        ),
                      ],
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
                      '• Skips effect execution on initial mount\n'
                      '• Only runs when dependencies change\n'
                      '• Perfect for logging updates, analytics\n'
                      '• Avoids unnecessary initial API calls\n'
                      '• Useful for form validation on change',
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
        title: const Text('useUpdateEffect Code Example'),
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
                '''// Only runs on updates, not mount
final query = useState('');
final results = useState<List<Item>>([]);

useUpdateEffect(() {
  // This won't run on initial render
  // Only when query changes after mount
  print('Searching for: \${query.value}');
  searchAPI(query.value);
  return null;
}, [query.value]);

// Track form changes (skip initial)
final name = useState(initialName);
final hasChanges = useState(false);

useUpdateEffect(() {
  // Mark form as dirty only on edits
  hasChanges.value = true;
  return null;
}, [name.value]);

// Log updates for analytics
useUpdateEffect(() {
  analytics.logEvent('value_changed', {
    'old': previousValue,
    'new': currentValue,
  });
  return null;
}, [currentValue]);''',
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
