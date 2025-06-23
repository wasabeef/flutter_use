import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseOrientationDemo extends HookWidget {
  const UseOrientationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = useOrientation();
    final rotationCount = useState(0);
    final lastOrientation = useState<Orientation?>(null);

    // Track orientation changes
    useEffect(() {
      if (lastOrientation.value != null &&
          lastOrientation.value != orientation) {
        rotationCount.value++;
      }
      lastOrientation.value = orientation;
      return null;
    }, [orientation]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useOrientation Demo'),
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
              '📱 useOrientation Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track device orientation changes in real-time',
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
                      '🔄 Device Orientation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Orientation visualization
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: orientation == Orientation.portrait ? 150 : 250,
                        height: orientation == Orientation.portrait ? 250 : 150,
                        decoration: BoxDecoration(
                          color: orientation == Orientation.portrait
                              ? Colors.blue.withValues(alpha: 0.2)
                              : Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: orientation == Orientation.portrait
                                ? Colors.blue
                                : Colors.green,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              orientation == Orientation.portrait
                                  ? Icons.stay_current_portrait
                                  : Icons.stay_current_landscape,
                              size: 64,
                              color: orientation == Orientation.portrait
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              orientation == Orientation.portrait
                                  ? 'PORTRAIT'
                                  : 'LANDSCAPE',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: orientation == Orientation.portrait
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Orientation info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Current Orientation:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Chip(
                                label: Text(
                                  orientation.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor:
                                    orientation == Orientation.portrait
                                    ? Colors.blue.withValues(alpha: 0.2)
                                    : Colors.green.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Rotation Count:'),
                              Text(
                                '${rotationCount.value}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Instructions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.amber),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Rotate your device to see orientation changes!',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Responsive layout example
                    const Text(
                      'Responsive Layout:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: orientation == Orientation.portrait
                          ? 2
                          : 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: List.generate(8, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .primaries[index % Colors.primaries.length]
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors
                                  .primaries[index % Colors.primaries.length],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
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
                      '• Responsive layouts\n'
                      '• Adaptive UI components\n'
                      '• Video player controls\n'
                      '• Gallery view adjustments\n'
                      '• Form layout optimization',
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
                      '• Tracks MediaQuery orientation\n'
                      '• Updates automatically on rotation\n'
                      '• Returns Orientation.portrait or .landscape\n'
                      '• No configuration needed\n'
                      '• Lightweight and efficient',
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
        title: const Text('useOrientation Code Example'),
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
                '''// Get current orientation
final orientation = useOrientation();

// Responsive layout
if (orientation == Orientation.portrait) {
  return Column(
    children: widgets,
  );
} else {
  return Row(
    children: widgets,
  );
}

// Adaptive grid
GridView.count(
  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
  children: items,
)

// Video player example
Container(
  width: orientation == Orientation.landscape 
    ? double.infinity 
    : 300,
  child: VideoPlayer(),
)

// Conditional rendering
orientation == Orientation.landscape
  ? LandscapeLayout()
  : PortraitLayout()

// With callback (useOrientationFn)
useOrientationFn((orientation) {
  print('Rotated to: \$orientation');
  analytics.track('orientation_change', {
    'orientation': orientation.name,
  });
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
