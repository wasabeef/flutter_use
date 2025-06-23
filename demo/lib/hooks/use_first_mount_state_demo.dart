import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseFirstMountStateDemo extends HookWidget {
  const UseFirstMountStateDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final isFirstMount = useFirstMountState();
    final renderCount = useState(0);
    final message = useState('');
    final actions = useState<List<String>>([]);

    // Track renders
    useEffect(() {
      renderCount.value++;
      actions.value = [
        '🔄 Render #${renderCount.value} - First mount: $isFirstMount',
        ...actions.value.take(9),
      ];
      return null;
    });

    // Demonstrate first mount usage
    useEffect(() {
      if (isFirstMount) {
        message.value = '🎉 Welcome! This is your first visit.';
      } else {
        message.value = '👋 Welcome back! Component has re-rendered.';
      }
      return null;
    }, [isFirstMount]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useFirstMountState Demo'),
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
              '🚀 useFirstMountState Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Detect if component is in its first render',
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
                      '🎯 First Mount Detection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // First mount indicator
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFirstMount
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.blue.withValues(alpha: 0.1),
                          border: Border.all(
                            color: isFirstMount ? Colors.green : Colors.blue,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFirstMount ? Icons.fiber_new : Icons.refresh,
                              size: 48,
                              color: isFirstMount ? Colors.green : Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isFirstMount ? 'First Mount' : 'Re-render',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isFirstMount
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Message display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.message,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message.value,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Render info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Render Count'),
                            const SizedBox(height: 4),
                            Text(
                              '${renderCount.value}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Is First Mount'),
                            const SizedBox(height: 4),
                            Text(
                              isFirstMount ? 'TRUE' : 'FALSE',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isFirstMount
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Force re-render button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Force a re-render by updating state
                          renderCount.value = renderCount.value;
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Force Re-render'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action log
                    const Text(
                      'Action Log:',
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
                      child: actions.value.isEmpty
                          ? const Center(
                              child: Text(
                                'No actions yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: actions.value.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    actions.value[index],
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
                      '• Show welcome messages on first load\n'
                      '• Skip animations on initial render\n'
                      '• Load data only on first mount\n'
                      '• Track user interactions differently\n'
                      '• Initialize third-party libraries once',
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
                      '• Returns true on first render only\n'
                      '• Returns false on all subsequent renders\n'
                      '• Persists through state changes\n'
                      '• Resets when component unmounts/remounts\n'
                      '• Useful for one-time initialization',
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
        title: const Text('useFirstMountState Code Example'),
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
                '''// Check if first mount
final isFirstMount = useFirstMountState();

// Show welcome message
if (isFirstMount) {
  showWelcomeDialog();
}

// Skip animation on first render
AnimatedContainer(
  duration: isFirstMount 
    ? Duration.zero 
    : Duration(milliseconds: 300),
  // ...
)

// Load data once
useEffect(() {
  if (isFirstMount) {
    loadInitialData();
  }
  return null;
}, []);

// Track analytics differently
useEffect(() {
  analytics.track(
    isFirstMount 
      ? 'page_first_view' 
      : 'page_return_view'
  );
  return null;
}, []);

// Initialize only once
if (isFirstMount) {
  ThirdPartySDK.initialize();
}''',
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
