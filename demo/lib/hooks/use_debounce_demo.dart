import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseDebounceDemo extends HookWidget {
  const UseDebounceDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final textInput = useState('');
    final debouncedValue = useState('');
    final searchCount = useState(0);
    final debounceDuration = useState(500);

    // Debounce the update to debouncedValue
    useDebounce(
      () {
        debouncedValue.value = textInput.value;
        if (textInput.value.isNotEmpty) {
          searchCount.value++;
        }
      },
      Duration(milliseconds: debounceDuration.value),
      [textInput.value],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('useDebounce Demo'),
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
              '⏳ useDebounce Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Delay value updates until user stops changing it',
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
                      '🔍 Search Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      onChanged: (value) => textInput.value = value,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        hintText: 'Type to search (debounced)...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Real-time vs Debounced
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.keyboard,
                                color: Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Real-time: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  textInput.value.isEmpty
                                      ? '(empty)'
                                      : textInput.value,
                                  style: TextStyle(
                                    color: textInput.value.isEmpty
                                        ? Colors.grey
                                        : null,
                                    fontStyle: textInput.value.isEmpty
                                        ? FontStyle.italic
                                        : null,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Debounced: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  debouncedValue.value.isEmpty
                                      ? '(empty)'
                                      : debouncedValue.value,
                                  style: TextStyle(
                                    color: debouncedValue.value.isEmpty
                                        ? Colors.grey
                                        : Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: debouncedValue.value.isEmpty
                                        ? FontStyle.italic
                                        : null,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Search count
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'API calls made: $searchCount',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Saved by debouncing!',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Debounce duration control
                    const Text(
                      'Debounce Duration:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: debounceDuration.value.toDouble(),
                            min: 100,
                            max: 2000,
                            divisions: 19,
                            label: '${debounceDuration.value}ms',
                            onChanged: (value) =>
                                debounceDuration.value = value.round(),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${debounceDuration.value}ms',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Comparison with throttle
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
                          'Debounce vs Throttle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Debounce: Waits until user stops changing value\n'
                      '• Throttle: Limits updates to fixed intervals\n'
                      '• Debounce is ideal for search inputs\n'
                      '• Throttle is better for scroll/resize events',
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
                      '• Delays value updates until stable\n'
                      '• Resets timer on each change\n'
                      '• Perfect for search, validation, auto-save\n'
                      '• Reduces API calls and improves performance',
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
        title: const Text('useDebounce Code Example'),
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
                '''// Debounce a search function
final searchQuery = useState('');

useDebounce(
  () {
    // This function only executes 500ms after
    // the user stops typing
    performSearch(searchQuery.value);
  },
  Duration(milliseconds: 500),
  [searchQuery.value], // Reset timer when query changes
);

// Auto-save example
final documentContent = useState('');

useDebounce(
  () {
    // Auto-save 2 seconds after user stops editing
    saveDocument(documentContent.value);
  },
  Duration(seconds: 2),
  [documentContent.value],
);

// Form validation
final email = useState('');
final isValid = useState<bool?>(null);

useDebounce(
  () {
    isValid.value = validateEmail(email.value);
  },
  Duration(milliseconds: 800),
  [email.value],
);''',
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
