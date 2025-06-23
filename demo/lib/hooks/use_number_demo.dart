import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseNumberDemo extends HookWidget {
  const UseNumberDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Different number use cases
    final score = useNumber(0, min: 0, max: 1000);
    final temperature = useNumber(20, min: -50, max: 50);
    final volume = useNumber(50, min: 0, max: 100);
    final progress = useNumber(0, min: 0, max: 100);

    final history = useState<List<String>>([]);

    void addToHistory(String action) {
      history.value = [
        '${DateTime.now().toString().substring(11, 19)}: $action',
        ...history.value.take(9),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('useNumber Demo'),
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
              '🔢 useNumber Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Numeric value management with bounds (alias for useCounter)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Score counter
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎯 Game Score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.blue.withValues(alpha: 0.2),
                              Colors.purple.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'SCORE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${score.value}',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              'Max: ${score.max ?? 'No limit'}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            score.inc(10);
                            addToHistory('Score +10 (${score.value})');
                          },
                          child: const Text('+10'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            score.inc(50);
                            addToHistory('Score +50 (${score.value})');
                          },
                          child: const Text('+50'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            score.inc(100);
                            addToHistory('Score +100 (${score.value})');
                          },
                          child: const Text('+100'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            score.reset();
                            addToHistory('Score reset to ${score.value}');
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Temperature control
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🌡️ Temperature Control',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _getTemperatureColor(
                                    temperature.value,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getTemperatureColor(
                                      temperature.value,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      _getTemperatureIcon(temperature.value),
                                      size: 40,
                                      color: _getTemperatureColor(
                                        temperature.value,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${temperature.value}°C',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _getTemperatureColor(
                                          temperature.value,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Range: ${temperature.min}°C to ${temperature.max}°C',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      temperature.dec(5);
                                      addToHistory(
                                        'Temperature -5°C (${temperature.value}°C)',
                                      );
                                    },
                                    icon: const Icon(Icons.remove),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      temperature.inc(5);
                                      addToHistory(
                                        'Temperature +5°C (${temperature.value}°C)',
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Volume and Progress
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔊 Volume & Progress Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Volume control
                    Row(
                      children: [
                        const Icon(Icons.volume_down),
                        Expanded(
                          child: Slider(
                            value: volume.value.toDouble(),
                            min: volume.min!.toDouble(),
                            max: volume.max!.toDouble(),
                            divisions: 20,
                            label: '${volume.value}%',
                            onChanged: (value) {
                              volume.setter(value.round());
                              addToHistory('Volume set to ${volume.value}%');
                            },
                          ),
                        ),
                        const Icon(Icons.volume_up),
                        Text('${volume.value}%'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Progress simulation
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Progress'),
                            Text('${progress.value}%'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress.value / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress.value == 100 ? Colors.green : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: progress.value >= 100
                                  ? null
                                  : () {
                                      progress.inc(10);
                                      addToHistory(
                                        'Progress +10% (${progress.value}%)',
                                      );
                                    },
                              child: const Text('+10%'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Simulate random progress
                                final randomProgress = Random().nextInt(101);
                                progress.setter(randomProgress);
                                addToHistory(
                                  'Progress set to $randomProgress%',
                                );
                              },
                              child: const Text('Random'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                progress.reset();
                                addToHistory(
                                  'Progress reset to ${progress.value}%',
                                );
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action history
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📜 Action History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                      child: history.value.isEmpty
                          ? const Center(
                              child: Text(
                                'Interact with controls to see history',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: history.value.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  history.value[index],
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
                          'useNumber vs useCounter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• useNumber is an alias for useCounter\n'
                      '• Same functionality, different semantic meaning\n'
                      '• Use useNumber for mathematical operations\n'
                      '• Use useCounter for counting/tallying\n'
                      '• Both support min/max bounds',
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

  Color _getTemperatureColor(int temp) {
    if (temp < 0) return Colors.cyan;
    if (temp < 10) return Colors.blue;
    if (temp < 20) return Colors.green;
    if (temp < 30) return Colors.orange;
    return Colors.red;
  }

  IconData _getTemperatureIcon(int temp) {
    if (temp < 0) return Icons.ac_unit;
    if (temp < 15) return Icons.thermostat;
    if (temp < 25) return Icons.wb_sunny_outlined;
    return Icons.whatshot;
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useNumber Code Example'),
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
                '''// Basic number with bounds
final score = useNumber(0, min: 0, max: 1000);

// Temperature control
final temperature = useNumber(20, min: -50, max: 50);

// Volume control
final volume = useNumber(50, min: 0, max: 100);

// Increment/decrement
score.inc(10);    // Add 10
score.dec(5);     // Subtract 5
score.inc();      // Add 1 (default)

// Set specific value
temperature.setter(25);

// Reset to initial value
score.reset();    // Back to 0

// Access properties
print('Current: \${score.value}');
print('Min: \${score.min}');
print('Max: \${score.max}');

// Mathematical operations
final calculator = useNumber(0);

calculator.inc(calculator.value); // Double
calculator.setter(calculator.value * 2); // Multiply

// Progress tracking
final progress = useNumber(0, min: 0, max: 100);

// Increment by percentage
progress.inc(25); // 25%

// Set completion
if (taskCompleted) {
  progress.setter(100);
}

// Bounded operations (automatically clamped)
final health = useNumber(100, min: 0, max: 100);
health.dec(150); // Will be clamped to 0
health.inc(50);  // Will be clamped to 100

// Use in sliders
Slider(
  value: volume.value.toDouble(),
  min: volume.min!.toDouble(),
  max: volume.max!.toDouble(),
  onChanged: (value) => volume.setter(value.round()),
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
