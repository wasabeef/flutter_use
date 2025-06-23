import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseUnmountDemo extends HookWidget {
  const UseUnmountDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final showComponent = useState(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useUnmount Demo'),
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
              '🔚 useUnmount Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Run cleanup when component unmounts',
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
                      '🎮 Component Control',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Switch(
                          value: showComponent.value,
                          onChanged: (value) => showComponent.value = value,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          showComponent.value
                              ? 'Component Mounted'
                              : 'Component Unmounted',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showComponent.value
                          ? const _DemoComponent()
                          : Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info, color: Colors.red),
                                  SizedBox(width: 12),
                                  Text(
                                    'Component unmounted - cleanup executed!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
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
                      '• Runs when component is removed from widget tree\n'
                      '• Perfect for cleanup operations\n'
                      '• Cancel subscriptions, timers, animations\n'
                      '• Release resources and prevent memory leaks',
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
        title: const Text('useUnmount Code Example'),
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
                '''useUnmount(() {
  // This runs when component unmounts
  print('Component unmounting!');
  
  // Cancel subscriptions
  subscription?.cancel();
  
  // Stop timers
  timer?.cancel();
  
  // Dispose controllers
  animationController.dispose();
  
  // Close streams
  streamController.close();
});

// Common patterns:
final timer = useRef<Timer?>(null);

useMount(() {
  timer.value = Timer.periodic(
    Duration(seconds: 1),
    (_) => updateTime(),
  );
});

useUnmount(() {
  timer.value?.cancel();
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

class _DemoComponent extends HookWidget {
  const _DemoComponent();

  @override
  Widget build(BuildContext context) {
    useUnmount(() {
      // This will be called when component unmounts
      debugPrint('🔴 Cleanup executed at ${DateTime.now()}');
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 12),
              Text(
                'Active Component',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This component has cleanup logic.\nToggle the switch to unmount and see cleanup.',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
