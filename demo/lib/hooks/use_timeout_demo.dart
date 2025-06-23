import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseTimeoutDemo extends HookWidget {
  const UseTimeoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final message = useState('');
    final delay = useState(3000);
    final isRunning = useState(false);

    // useTimeout just causes a rebuild after the delay
    final timeoutState = useTimeout(
      isRunning.value
          ? Duration(milliseconds: delay.value)
          : const Duration(days: 365),
    );

    // Check if timeout has fired
    useEffect(() {
      if (isRunning.value && timeoutState.isReady() == true) {
        message.value =
            '⏰ Timeout fired at ${DateTime.now().toString().substring(11, 19)}';
        isRunning.value = false;
      }
      return null;
    }, [timeoutState.isReady()]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useTimeout Demo'),
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
              '⏲️ useTimeout Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Execute code after a specified delay',
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
                      '🎯 Delayed Action',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Timer visualization
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isRunning.value ? Colors.blue : Colors.grey,
                            width: 4,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isRunning.value ? Icons.timer : Icons.timer_off,
                                size: 48,
                                color: isRunning.value
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isRunning.value ? 'Running...' : 'Idle',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isRunning.value
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                              if (isRunning.value) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${delay.value}ms',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Control button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: isRunning.value
                            ? null
                            : () {
                                message.value = '';
                                isRunning.value = true;
                              },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Timeout'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
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
                            max: 10000,
                            divisions: 19,
                            label: '${delay.value}ms',
                            onChanged: isRunning.value
                                ? null
                                : (value) => delay.value = value.round(),
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
                          label: const Text('1s'),
                          onPressed: isRunning.value
                              ? null
                              : () => delay.value = 1000,
                          backgroundColor: delay.value == 1000
                              ? Colors.blue
                              : null,
                        ),
                        ActionChip(
                          label: const Text('3s'),
                          onPressed: isRunning.value
                              ? null
                              : () => delay.value = 3000,
                          backgroundColor: delay.value == 3000
                              ? Colors.blue
                              : null,
                        ),
                        ActionChip(
                          label: const Text('5s'),
                          onPressed: isRunning.value
                              ? null
                              : () => delay.value = 5000,
                          backgroundColor: delay.value == 5000
                              ? Colors.blue
                              : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Message display
                    if (message.value.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                message.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Use cases
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Common Use Cases',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Show loading indicators for minimum time\n'
                      '• Delay navigation or redirects\n'
                      '• Auto-dismiss notifications\n'
                      '• Implement splash screens\n'
                      '• Add delays to animations',
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
                      '• Executes callback after specified delay\n'
                      '• Pass null duration to cancel timeout\n'
                      '• Automatically cleans up on unmount\n'
                      '• One-shot execution (not repeating)\n'
                      '• Useful for delayed actions and transitions',
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
        title: const Text('useTimeout Code Example'),
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
                '''// Basic timeout - causes rebuild after delay
final timeoutState = useTimeout(Duration(seconds: 3));

// Check if timeout is ready
useEffect(() {
  if (timeoutState.isReady()) {
    print('3 seconds have passed!');
    // Perform action after timeout
  }
  return null;
}, [timeoutState.isReady()]);

// Conditional timeout
final showLoading = useState(true);
final loadingTimeout = useTimeout(
  showLoading.value 
    ? Duration(seconds: 2) 
    : Duration(days: 365), // Effectively disabled
);

useEffect(() {
  if (loadingTimeout.isReady() && showLoading.value) {
    showLoading.value = false;
  }
  return null;
}, [loadingTimeout.isReady()]);

// Control timeout state
loadingTimeout.reset(); // Reset timer
loadingTimeout.cancel(); // Cancel timer

// Minimum display time pattern
final dataLoaded = useState(false);
final minDisplayTime = useTimeout(Duration(seconds: 1));

// Only hide when both data loaded AND min time passed
final shouldHideLoading = dataLoaded.value && 
                         minDisplayTime.isReady();''',
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
