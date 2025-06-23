import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseTimeoutFnDemo extends HookWidget {
  const UseTimeoutFnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = useState<List<String>>([]);
    final delay = useState(2000);

    // Create timeout function that can be started/stopped
    final timeout = useTimeoutFn(() {
      logs.value = [
        '✅ Timeout executed at ${DateTime.now().toString().substring(11, 19)}',
        ...logs.value.take(9),
      ];
    }, Duration(milliseconds: delay.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('useTimeoutFn Demo'),
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
              '⏱️ useTimeoutFn Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Controllable timeout with start, stop, and reset',
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
                      '🎮 Timeout Controller',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status display
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
                          Icon(
                            timeout.isReady() == false
                                ? Icons.timer
                                : Icons.timer_off,
                            size: 32,
                            color: timeout.isReady() == false
                                ? Colors.orange
                                : Colors.grey,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status: ${timeout.isReady() == null
                                      ? "Cancelled"
                                      : timeout.isReady() == false
                                      ? "Running"
                                      : "Ready"}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (timeout.isReady() == false)
                                  Text(
                                    'Will fire in ${delay.value}ms',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: timeout.isReady() == false
                              ? null
                              : timeout.reset,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: timeout.isReady() == false
                              ? timeout.cancel
                              : null,
                          icon: const Icon(Icons.stop),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: timeout.reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Delay control
                    const Text(
                      'Timeout Duration:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: delay.value.toDouble(),
                            min: 500,
                            max: 5000,
                            divisions: 9,
                            label: '${delay.value}ms',
                            onChanged: (value) => delay.value = value.round(),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${delay.value}ms',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Activity log
                    const Text(
                      'Activity Log:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: logs.value.isEmpty
                          ? const Center(
                              child: Text(
                                'No timeouts executed yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: logs.value.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    logs.value[index],
                                    style: const TextStyle(
                                      color: Colors.white,
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
                      onPressed: () => logs.value = [],
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Log'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Comparison with useTimeout
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
                          'useTimeout vs useTimeoutFn',
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
                                'useTimeout',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'useTimeoutFn',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Auto-starts'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Manual control'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('No control methods'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('start(), stop(), reset()'),
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
                      '• Returns TimeoutState object with methods\n'
                      '• isReady() returns null (cancelled), false (running), or true (completed)\n'
                      '• cancel() stops the timeout\n'
                      '• reset() restarts the timeout\n'
                      '• Automatically starts on hook initialization',
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
        title: const Text('useTimeoutFn Code Example'),
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
                '''// Create controllable timeout
final timeout = useTimeoutFn(
  () => print('Timeout fired!'),
  Duration(seconds: 3),
);

// Check status
if (timeout.isActive) {
  print('Timeout is running');
}

// Control methods
ElevatedButton(
  onPressed: timeout.start,
  child: Text('Start Timer'),
)

ElevatedButton(
  onPressed: timeout.stop,
  child: Text('Stop Timer'),
)

// Auto-retry with timeout
final retry = useTimeoutFn(() {
  fetchData().catchError((e) {
    // Retry after delay
    timeout.reset();
  });
}, Duration(seconds: 5));

// Delayed form submission
final submitTimeout = useTimeoutFn(
  () => submitForm(),
  Duration(seconds: 2),
);

TextField(
  onChanged: (_) => submitTimeout.reset(),
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
