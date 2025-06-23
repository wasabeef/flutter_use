import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseThrottleFnDemo extends HookWidget {
  const UseThrottleFnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    final clickCounter = useState(0);
    final throttleDuration = useState(500);

    // Create throttled function
    final throttledIncrement = useThrottleFn(() {
      counter.value++;
    }, Duration(milliseconds: throttleDuration.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('useThrottleFn Demo'),
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
              '⚡ useThrottleFn Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Throttle function calls to prevent excessive execution',
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
                      '🎯 Live Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Counters Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCounterDisplay(
                                'Button Clicks',
                                clickCounter.value,
                                Colors.orange,
                                Icons.touch_app,
                              ),
                              Container(
                                width: 1,
                                height: 60,
                                color: Colors.grey[300],
                              ),
                              _buildCounterDisplay(
                                'Throttled Calls',
                                counter.value,
                                Colors.blue,
                                Icons.speed,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          clickCounter.value++;
                          throttledIncrement.call();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Click Me Fast!'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Try clicking rapidly! The button clicks are counted immediately, '
                      'but the throttled function only executes once per ${throttleDuration.value}ms.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
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

                    // Reset Button
                    OutlinedButton.icon(
                      onPressed: () {
                        counter.value = 0;
                        clickCounter.value = 0;
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Counters'),
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
                      '• Creates a throttled version of any function\n'
                      '• First call executes immediately\n'
                      '• Subsequent calls are throttled based on duration\n'
                      '• Perfect for button clicks, API calls, and expensive operations\n'
                      '• Prevents function spam and improves performance',
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

  Widget _buildCounterDisplay(
    String label,
    int value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useThrottleFn Code Example'),
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
                '''final counter = useState(0);

final throttledIncrement = useThrottleFn(
  () {
    counter.value++;
    print('Counter incremented: \${counter.value}');
  },
  Duration(milliseconds: 500),
);

// Usage in button
ElevatedButton(
  onPressed: throttledIncrement.call,
  child: Text('Increment (Throttled)'),
)

// Even if clicked rapidly, the function
// only executes once per 500ms
''',
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
