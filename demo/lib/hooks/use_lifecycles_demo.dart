import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseLifecyclesDemo extends HookWidget {
  const UseLifecyclesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final lifecycleEvents = useState<List<String>>([]);
    final updateCount = useState(0);
    final isVisible = useState(true);

    // Add initial mount event
    useEffect(() {
      lifecycleEvents.value = ['🚀 Widget initialized at ${_timestamp()}'];
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useLifecycles Demo'),
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
              '🔄 useLifecycles Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage component lifecycle with mount and unmount callbacks',
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
                      '🎯 Lifecycle Component',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Toggle visibility button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => isVisible.value = !isVisible.value,
                        icon: Icon(
                          isVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        label: Text(
                          isVisible.value ? 'Hide Component' : 'Show Component',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lifecycle component
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isVisible.value ? null : 0,
                      child: isVisible.value
                          ? _LifecycleComponent(
                              onLifecycleEvent: (event) {
                                lifecycleEvents.value = [
                                  event,
                                  ...lifecycleEvents.value.take(19),
                                ];
                              },
                              updateCount: updateCount.value,
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),

                    // Update trigger
                    if (isVisible.value) ...[
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () => updateCount.value++,
                          icon: const Icon(Icons.refresh),
                          label: Text('Trigger Update (${updateCount.value})'),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Lifecycle events log
                    const Text(
                      'Lifecycle Events:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: lifecycleEvents.value.isEmpty
                          ? const Center(
                              child: Text(
                                'No events yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: lifecycleEvents.value.length,
                              itemBuilder: (context, index) {
                                final event = lifecycleEvents.value[index];
                                Color color = Colors.white;
                                if (event.contains('Mounted')) {
                                  color = Colors.green;
                                } else if (event.contains('Unmounted')) {
                                  color = Colors.red;
                                } else if (event.contains('Updated')) {
                                  color = Colors.blue;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    event,
                                    style: TextStyle(
                                      color: color,
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => lifecycleEvents.value = [],
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Log'),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Total events: ${lifecycleEvents.value.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
                      '• Combines mount and unmount in one hook\n'
                      '• Mount callback runs after first render\n'
                      '• Unmount callback runs on disposal\n'
                      '• Perfect for resource management\n'
                      '• Useful for subscriptions, timers, listeners',
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

  String _timestamp() => DateTime.now().toString().substring(11, 19);

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useLifecycles Code Example'),
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
                '''// Combined mount/unmount management
useLifecycles(
  mount: () {
    print('Component mounted');
    // Initialize resources
    controller.init();
    subscription = stream.listen(handler);
  },
  unmount: () {
    print('Component unmounting');
    // Cleanup resources
    controller.dispose();
    subscription?.cancel();
  },
);

// WebSocket connection example
useLifecycles(
  mount: () {
    websocket = WebSocket.connect(url);
    websocket.listen(onMessage);
  },
  unmount: () {
    websocket?.close();
  },
);

// Analytics tracking
useLifecycles(
  mount: () {
    analytics.screenView('UserProfile');
    startTime = DateTime.now();
  },
  unmount: () {
    final duration = DateTime.now()
      .difference(startTime);
    analytics.timing('screen_time', duration);
  },
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

class _LifecycleComponent extends HookWidget {
  final Function(String) onLifecycleEvent;
  final int updateCount;

  const _LifecycleComponent({
    required this.onLifecycleEvent,
    required this.updateCount,
  });

  @override
  Widget build(BuildContext context) {
    useLifecycles(
      mount: () {
        onLifecycleEvent(
          '✅ Component Mounted at ${DateTime.now().toString().substring(11, 19)}',
        );
      },
      unmount: () {
        onLifecycleEvent(
          '❌ Component Unmounted at ${DateTime.now().toString().substring(11, 19)}',
        );
      },
    );

    useEffect(() {
      if (updateCount > 0) {
        onLifecycleEvent(
          '🔄 Component Updated (count: $updateCount) at ${DateTime.now().toString().substring(11, 19)}',
        );
      }
      return null;
    }, [updateCount]);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.widgets, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Lifecycle Component',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Update count: $updateCount',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Component is mounted',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
