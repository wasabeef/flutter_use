import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseIntervalDemo extends HookWidget {
  const UseIntervalDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    final delay = useState(1000);
    final isRunning = useState(true);
    final logs = useState<List<String>>([]);

    useInterval(() {
      counter.value++;
      logs.value = [
        '⏱️ Tick #${counter.value} at ${DateTime.now().toString().substring(11, 19)}',
        ...logs.value.take(9), // Keep last 10 logs
      ];
    }, isRunning.value ? Duration(milliseconds: delay.value) : null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useInterval Demo'),
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
              '⏱️ useInterval Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Execute functions at regular intervals',
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
                      '🎯 Live Timer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Counter display
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${counter.value}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => isRunning.value = !isRunning.value,
                          icon: Icon(
                            isRunning.value ? Icons.pause : Icons.play_arrow,
                          ),
                          label: Text(isRunning.value ? 'Pause' : 'Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRunning.value
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            counter.value = 0;
                            logs.value = ['🔄 Counter reset'];
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Interval control
                    const Text(
                      'Interval Duration:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: delay.value.toDouble(),
                            min: 100,
                            max: 5000,
                            divisions: 49,
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

                    // Quick presets
                    Wrap(
                      spacing: 8,
                      children: [
                        ActionChip(
                          label: const Text('100ms'),
                          onPressed: () => delay.value = 100,
                          backgroundColor: delay.value == 100
                              ? Colors.blue
                              : null,
                        ),
                        ActionChip(
                          label: const Text('500ms'),
                          onPressed: () => delay.value = 500,
                          backgroundColor: delay.value == 500
                              ? Colors.blue
                              : null,
                        ),
                        ActionChip(
                          label: const Text('1s'),
                          onPressed: () => delay.value = 1000,
                          backgroundColor: delay.value == 1000
                              ? Colors.blue
                              : null,
                        ),
                        ActionChip(
                          label: const Text('2s'),
                          onPressed: () => delay.value = 2000,
                          backgroundColor: delay.value == 2000
                              ? Colors.blue
                              : null,
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
                      height: 120,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: logs.value.isEmpty
                          ? const Center(
                              child: Text(
                                'No activity yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: logs.value.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  logs.value[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
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
                      '• Executes callback at specified intervals\n'
                      '• Pass null duration to pause/stop\n'
                      '• Automatically cleans up on unmount\n'
                      '• Handles interval changes seamlessly\n'
                      '• Perfect for timers, polling, animations',
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
        title: const Text('useInterval Code Example'),
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
                '''// Basic interval
useInterval(() {
  print('This runs every second');
}, Duration(seconds: 1));

// With state updates
final counter = useState(0);
useInterval(() {
  counter.value++;
}, Duration(milliseconds: 100));

// Conditional interval
final isRunning = useState(true);
useInterval(
  () => updateData(),
  isRunning.value 
    ? Duration(seconds: 5) 
    : null, // null stops interval
);

// Dynamic delay
final delay = useState(1000);
useInterval(
  () => doWork(),
  Duration(milliseconds: delay.value),
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
