import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseLatestDemo extends HookWidget {
  const UseLatestDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final logs = useState<List<String>>([]);

    // Keep latest value in a ref
    final latestCount = useLatest(count.value);

    // Demonstrate stale closure problem vs useLatest solution
    useEffect(() {
      // This captures the initial count value (stale closure)
      final capturedCount = count.value;

      Timer? timer;
      timer = Timer.periodic(const Duration(seconds: 2), (_) {
        logs.value = [
          '⏱️ Timer tick at ${DateTime.now().toString().substring(11, 19)}:',
          '  - Captured value (stale): $capturedCount',
          '  - Latest value (fresh): $latestCount',
          '  - Current state value: ${count.value}',
          '',
          ...logs.value.take(15),
        ];
      });

      return timer.cancel;
    }, const []); // Empty deps - only run once

    return Scaffold(
      appBar: AppBar(
        title: const Text('useLatest Demo'),
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
              '📌 useLatest Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Always access the latest value in callbacks',
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
                      '🎯 Stale Closure Fix',
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
                          const Icon(Icons.countertops, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Counter Value:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${count.value}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton.filled(
                                onPressed: () => count.value++,
                                icon: const Icon(Icons.add),
                              ),
                              const SizedBox(height: 8),
                              IconButton.filled(
                                onPressed: () => count.value--,
                                icon: const Icon(Icons.remove),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Change the counter and watch how the timer logs show different values!',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Timer log
                    const Text(
                      '📊 Timer Log (updates every 2 seconds):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 250,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: logs.value.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    'Waiting for first timer tick...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: logs.value.length,
                              itemBuilder: (context, index) {
                                final log = logs.value[index];
                                Color color = Colors.white;
                                if (log.contains('stale')) {
                                  color = Colors.orange;
                                } else if (log.contains('fresh')) {
                                  color = Colors.green;
                                } else if (log.contains('Current')) {
                                  color = Colors.blue;
                                }

                                return Text(
                                  log,
                                  style: TextStyle(
                                    color: color,
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    fontWeight: log.contains('Timer tick')
                                        ? FontWeight.bold
                                        : null,
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

            // Explanation
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.school, color: Colors.purple),
                        SizedBox(width: 8),
                        Text(
                          'Understanding the Problem',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Captured value: Stuck at 0 (initial value)\n'
                      '• Latest value: Always current, updates correctly\n'
                      '• Closures capture values at creation time\n'
                      '• useLatest provides a stable ref to current value\n'
                      '• Essential for callbacks with stale closures',
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
                      '• Returns the latest value directly\n'
                      '• Updates on each render\n'
                      '• Solves stale closure problem\n'
                      '• Perfect for event handlers and timers\n'
                      '• No need to access .value property',
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
        title: const Text('useLatest Code Example'),
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
                '''// Problem: Stale closure
final count = useState(0);

useEffect(() {
  Timer.periodic(Duration(seconds: 1), (_) {
    // This always prints 0!
    print(count.value); // Stale value
  });
  return null;
}, []); // Empty deps

// Solution: useLatest
final count = useState(0);
final latestCount = useLatest(count.value);

useEffect(() {
  Timer.periodic(Duration(seconds: 1), (_) {
    // This prints current value!
    print(latestCount); // Fresh value
  });
  return null;
}, []); // Empty deps

// Event handlers
final handleClick = useCallback(() {
  // Access latest state
  doSomething(latestCount);
}, []); // No deps needed!

// Async operations
useEffect(() {
  fetchData().then((_) {
    // Use latest value after async
    updateUI(latestValue);
  });
  return null;
}, []);''',
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
