import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseThrottleDemo extends HookWidget {
  const UseThrottleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final inputText = useState('');
    final throttleDuration = useState(500);

    // Listen to text changes
    useEffect(() {
      void listener() {
        inputText.value = textController.text;
      }

      textController.addListener(listener);
      return () => textController.removeListener(listener);
    }, [textController]);

    // Apply throttling
    final throttledText = useThrottle(
      inputText.value,
      Duration(milliseconds: throttleDuration.value),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('useThrottle Demo'),
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
              '🔄 useThrottle Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Throttle value updates to improve performance',
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
                      decoration: const InputDecoration(
                        labelText: 'Type here...',
                        hintText: 'Start typing to see throttling in action',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Results Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.keyboard,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Original: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  inputText.value.isEmpty
                                      ? '(empty)'
                                      : '"${inputText.value}"',
                                  style: TextStyle(
                                    color: inputText.value.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                    fontStyle: inputText.value.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.speed,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Throttled (${throttleDuration.value}ms): ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  throttledText.isEmpty
                                      ? '(empty)'
                                      : '"$throttledText"',
                                  style: TextStyle(
                                    color: throttledText.isEmpty
                                        ? Colors.grey
                                        : Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: throttledText.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Duration Control
                    const Text(
                      '⏱️ Throttle Duration',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: throttleDuration.value.toDouble(),
                            min: 100,
                            max: 2000,
                            divisions: 19,
                            label: '${throttleDuration.value}ms',
                            onChanged: (value) {
                              throttleDuration.value = value.round();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${throttleDuration.value}ms',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick presets
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildPresetChip('Fast (200ms)', 200, throttleDuration),
                        _buildPresetChip(
                          'Normal (500ms)',
                          500,
                          throttleDuration,
                        ),
                        _buildPresetChip(
                          'Slow (1000ms)',
                          1000,
                          throttleDuration,
                        ),
                      ],
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
                      '• The first value update is immediate\n'
                      '• Subsequent updates are throttled based on duration\n'
                      '• Perfect for search inputs, API calls, and expensive operations\n'
                      '• Reduces unnecessary computations and improves performance',
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

  Widget _buildPresetChip(
    String label,
    int value,
    ValueNotifier<int> notifier,
  ) {
    return ActionChip(
      label: Text(label),
      onPressed: () => notifier.value = value,
      backgroundColor: notifier.value == value ? Colors.blue[100] : null,
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useThrottle Code Example'),
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
                '''final text = useState('');
final throttledValue = useThrottle(
  text.value,
  Duration(milliseconds: 500),
);

// Use in TextField
TextField(
  onChanged: (value) => text.value = value,
  decoration: InputDecoration(
    labelText: 'Search...',
  ),
)

// throttledValue updates at most once per 500ms
useEffect(() {
  // This expensive operation only runs when throttled value changes
  performExpensiveSearch(throttledValue);
  return null;
}, [throttledValue]);''',
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
