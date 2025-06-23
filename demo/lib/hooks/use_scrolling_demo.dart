import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseScrollingDemo extends HookWidget {
  const UseScrollingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final scrolling = useScrolling();

    return Scaffold(
      appBar: AppBar(
        title: const Text('useScrolling Demo'),
        actions: [
          TextButton(
            onPressed: () => _showCodeDialog(context),
            child: const Text('📋 Code', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: scrolling.isScrolling
                ? Colors.orange.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    scrolling.isScrolling
                        ? Icons.directions_run
                        : Icons.accessibility,
                    key: ValueKey(scrolling.isScrolling),
                    color: scrolling.isScrolling ? Colors.orange : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  scrolling.isScrolling
                      ? 'Currently Scrolling...'
                      : 'Not Scrolling',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: scrolling.isScrolling ? Colors.orange : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              controller: scrolling.controller,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏃 useScrolling Demo',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Detect when the user is actively scrolling',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Live Demo Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🎯 Real-time Scroll Detection',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            'Start scrolling this content to see the status change above. '
                            'The hook detects when scrolling starts and stops.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Status Indicator
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: scrolling.isScrolling
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: scrolling.isScrolling
                                    ? Colors.orange
                                    : Colors.green,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  scrolling.isScrolling
                                      ? Icons.play_arrow
                                      : Icons.pause,
                                  color: scrolling.isScrolling
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  scrolling.isScrolling
                                      ? 'Scrolling Active'
                                      : 'Scrolling Inactive',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: scrolling.isScrolling
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Use Cases Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.build, color: Colors.blue),
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
                            '• Show/hide floating action buttons during scroll\n'
                            '• Pause expensive animations while scrolling\n'
                            '• Display scroll indicators or progress bars\n'
                            '• Optimize performance by disabling effects during scroll\n'
                            '• Trigger analytics events for scroll interactions',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Content Blocks to enable scrolling
                  ...List.generate(
                    15,
                    (index) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  radius: 16,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Scroll Content Item ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'This is scroll content item ${index + 1}. Notice how the scrolling status updates '
                              'in real-time as you scroll through this content. The useScrolling hook makes it easy '
                              'to detect scroll activity and respond accordingly in your UI.',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  scrolling.isScrolling
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: scrolling.isScrolling
                                      ? Colors.orange
                                      : Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  scrolling.isScrolling
                                      ? 'Scroll detected!'
                                      : 'No scroll activity',
                                  style: TextStyle(
                                    color: scrolling.isScrolling
                                        ? Colors.orange
                                        : Colors.grey,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                            '• Returns true when user is actively scrolling\n'
                            '• Returns false when scroll stops\n'
                            '• Works with any ScrollController\n'
                            '• Useful for performance optimizations\n'
                            '• Perfect for conditional UI updates during scroll',
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

                  const SizedBox(height: 100), // Extra space for scrolling
                ],
              ),
            ),
          ),
        ],
      ),

      // Conditional FAB based on scroll state
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: scrolling.isScrolling
            ? null // Hide FAB while scrolling
            : FloatingActionButton(
                onPressed: () {
                  scrolling.controller.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.keyboard_arrow_up),
              ),
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useScrolling Code Example'),
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
                '''final scrolling = useScrolling();

// Use in your widget
Scaffold(
  body: SingleChildScrollView(
    controller: scrolling.controller,
    child: Column(
      children: [
        // Your content here
      ],
    ),
  ),
  
  // Conditional FAB - hide while scrolling
  floatingActionButton: scrolling.isScrolling 
    ? null 
    : FloatingActionButton(
        onPressed: () => scrollToTop(),
        child: Icon(Icons.arrow_upward),
      ),
)

// Performance optimization example
if (!scrolling.isScrolling) {
  // Run expensive animations only when not scrolling
  startComplexAnimation();
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
