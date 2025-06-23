import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseCounterDemo extends HookWidget {
  const UseCounterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useCounter(0);
    final customCounter = useCounter(10, min: 0, max: 20);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useCounter Demo'),
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
              '🔢 useCounter Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enhanced counter with increment, decrement, set, and reset',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Basic Counter
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎯 Basic Counter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Counter Display
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${counter.value}',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: counter.dec,
                              heroTag: 'dec1',
                              child: const Icon(Icons.remove),
                            ),
                            const SizedBox(height: 8),
                            const Text('Decrement'),
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: counter.inc,
                              heroTag: 'inc1',
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: const Icon(Icons.add),
                            ),
                            const SizedBox(height: 8),
                            const Text('Increment'),
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: counter.reset,
                              heroTag: 'reset1',
                              backgroundColor: Colors.orange,
                              child: const Icon(Icons.refresh),
                            ),
                            const SizedBox(height: 8),
                            const Text('Reset'),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Set Value
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => counter.setter(42),
                            child: const Text('Set to 42'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => counter.setter(100),
                            child: const Text('Set to 100'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Custom Counter with Limits
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎮 Counter with Limits',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Min: 0, Max: 20, Initial: 10',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),

                    // Counter Display with Progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: customCounter.value / 20,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        Text(
                          '${customCounter.value}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: customCounter.value > 0
                              ? customCounter.dec
                              : null,
                          icon: const Icon(Icons.remove),
                          label: const Text('Dec'),
                        ),
                        ElevatedButton.icon(
                          onPressed: customCounter.value < 20
                              ? customCounter.inc
                              : null,
                          icon: const Icon(Icons.add),
                          label: const Text('Inc'),
                        ),
                        ElevatedButton.icon(
                          onPressed: customCounter.reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Custom Increment/Decrement
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => customCounter.inc(5),
                            child: const Text('Inc by 5'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => customCounter.dec(3),
                            child: const Text('Dec by 3'),
                          ),
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
                      '• Provides a counter with increment/decrement functions\n'
                      '• Supports custom initial value, min, and max limits\n'
                      '• Includes set() and reset() methods\n'
                      '• Custom step values for inc() and dec()\n'
                      '• Automatically enforces min/max constraints',
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
        title: const Text('useCounter Code Example'),
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
                '''// Basic counter
final counter = useCounter(0);

// Counter with options
final customCounter = useCounter(
  10,
  min: 0,
  max: 20,
);

// Usage
Text('Count: \${counter.value}');

ElevatedButton(
  onPressed: counter.inc,
  child: Text('Increment'),
)

// Custom increment
counter.inc(5); // Increment by 5
counter.dec(3); // Decrement by 3
counter.setter(42); // Set to specific value
counter.reset(); // Reset to initial value''',
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
