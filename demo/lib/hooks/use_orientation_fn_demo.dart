import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseOrientationFnDemo extends HookWidget {
  const UseOrientationFnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final orientationHistory = useState<List<String>>([]);
    final orientationChangeCount = useState(0);
    final currentOrientation = useState<Orientation?>(null);

    // Track orientation changes with callback
    useOrientationFn((orientation) {
      currentOrientation.value = orientation;
      orientationChangeCount.value++;

      final timestamp = DateTime.now().toString().substring(11, 19);
      orientationHistory.value = [
        '📱 $timestamp: Changed to ${orientation.name.toUpperCase()}',
        ...orientationHistory.value.take(9),
      ];
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('useOrientationFn Demo'),
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
              '🔄 useOrientationFn Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Callback-based orientation change detection',
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
                      '📡 Orientation Listener',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Current orientation display
                    if (currentOrientation.value != null) ...[
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.elasticOut,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors:
                                  currentOrientation.value ==
                                      Orientation.portrait
                                  ? [
                                      Colors.blue.withValues(alpha: 0.2),
                                      Colors.indigo.withValues(alpha: 0.2),
                                    ]
                                  : [
                                      Colors.green.withValues(alpha: 0.2),
                                      Colors.teal.withValues(alpha: 0.2),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  currentOrientation.value ==
                                      Orientation.portrait
                                  ? Colors.blue
                                  : Colors.green,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (currentOrientation.value ==
                                                Orientation.portrait
                                            ? Colors.blue
                                            : Colors.green)
                                        .withValues(alpha: 0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedRotation(
                                turns:
                                    currentOrientation.value ==
                                        Orientation.portrait
                                    ? 0
                                    : 0.25,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.phone_android,
                                  size: 80,
                                  color:
                                      currentOrientation.value ==
                                          Orientation.portrait
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentOrientation.value!.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      currentOrientation.value ==
                                          Orientation.portrait
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Waiting for orientation data...'),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Statistics
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'Total Changes',
                          '${orientationChangeCount.value}',
                          Icons.swap_horiz,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Current Mode',
                          currentOrientation.value?.name.toUpperCase() ??
                              'Unknown',
                          currentOrientation.value == Orientation.portrait
                              ? Icons.stay_current_portrait
                              : Icons.stay_current_landscape,
                          currentOrientation.value == Orientation.portrait
                              ? Colors.blue
                              : Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Instructions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.withValues(alpha: 0.1),
                            Colors.orange.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.rotate_right,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Try rotating your device!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'The callback will be triggered automatically on orientation changes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // History log
                    const Text(
                      '📋 Orientation Change History:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: orientationHistory.value.isEmpty
                          ? const Center(
                              child: Text(
                                'Rotate device to see orientation changes...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: orientationHistory.value.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    orientationHistory.value[index],
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

                    // Clear history button
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          orientationHistory.value = [];
                          orientationChangeCount.value = 0;
                        },
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear History'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Comparison with useOrientation
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
                          'useOrientation vs useOrientationFn',
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
                                'useOrientation',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'useOrientationFn',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Returns current orientation'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Calls function on change'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Reactive value'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Event-driven callback'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Use for UI rendering'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Use for side effects'),
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
                      '• Registers callback for orientation changes\n'
                      '• Triggers callback immediately on change\n'
                      '• Perfect for side effects and analytics\n'
                      '• More performant for event handling\n'
                      '• Use when you don\'t need the current value',
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

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useOrientationFn Code Example'),
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
                '''// Basic callback usage
useOrientationFn((orientation) {
  print('Orientation changed to: \$orientation');
});

// Analytics tracking
useOrientationFn((orientation) {
  analytics.track('orientation_change', {
    'orientation': orientation.name,
    'timestamp': DateTime.now().toIso8601String(),
  });
});

// Update app settings
useOrientationFn((orientation) {
  if (orientation == Orientation.landscape) {
    hideUI();
    enterFullscreen();
  } else {
    showUI();
    exitFullscreen();
  }
});

// Side effects on change
final orientationHistory = useState<List<String>>([]);

useOrientationFn((orientation) {
  final timestamp = DateTime.now();
  orientationHistory.value = [
    'Changed to \${orientation.name} at \$timestamp',
    ...orientationHistory.value.take(9),
  ];
});

// Conditional actions
useOrientationFn((orientation) {
  if (orientation == Orientation.landscape) {
    // Landscape-specific logic
    videoPlayer.enterFullscreen();
    systemChrome.hideSystemUI();
  } else {
    // Portrait-specific logic
    videoPlayer.exitFullscreen();
    systemChrome.showSystemUI();
  }
});

// Performance monitoring
useOrientationFn((orientation) {
  final stopwatch = Stopwatch()..start();
  
  // Perform expensive operation
  rebuildExpensiveWidget();
  
  stopwatch.stop();
  print('Orientation change handling took: '
    '\${stopwatch.elapsedMilliseconds}ms');
});''',
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
