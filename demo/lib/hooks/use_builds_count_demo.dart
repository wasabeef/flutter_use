import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseBuildsCountDemo extends HookWidget {
  const UseBuildsCountDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final buildsCount = useBuildsCount();
    final counter = useState(0);
    final text = useState('');
    final isChecked = useState(false);
    final sliderValue = useState(50.0);
    final buildHistory = useState<List<String>>([]);

    // Track build reasons
    useEffect(() {
      final reason = _getBuildReason(
        counter.value,
        text.value,
        isChecked.value,
        sliderValue.value,
      );
      buildHistory.value = [
        'Build #$buildsCount: $reason at ${DateTime.now().toString().substring(11, 19)}',
        ...buildHistory.value.take(9),
      ];
      return null;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('useBuildsCount Demo'),
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
              '🔢 useBuildsCount Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track how many times your widget rebuilds',
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
                      '📊 Build Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Build count display
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.withValues(alpha: 0.2),
                              Colors.purple.withValues(alpha: 0.2),
                            ],
                          ),
                          border: Border.all(color: Colors.blue, width: 3),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Builds',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$buildsCount',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      '🎮 Interactive Controls',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Each interaction causes a rebuild:',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),

                    // Counter control
                    Row(
                      children: [
                        const Text('Counter: '),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => counter.value--,
                          icon: const Icon(Icons.remove_circle),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${counter.value}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => counter.value++,
                          icon: const Icon(Icons.add_circle),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Text input
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Type something',
                        hintText: 'Each character triggers a rebuild',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.keyboard),
                      ),
                      onChanged: (value) => text.value = value,
                    ),

                    const SizedBox(height: 16),

                    // Checkbox
                    CheckboxListTile(
                      title: const Text('Toggle me'),
                      subtitle: const Text('Causes rebuild on change'),
                      value: isChecked.value,
                      onChanged: (value) => isChecked.value = value!,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    const SizedBox(height: 16),

                    // Slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Slider: ${sliderValue.value.round()}'),
                        Slider(
                          value: sliderValue.value,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: sliderValue.value.round().toString(),
                          onChanged: (value) => sliderValue.value = value,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Build history
                    const Text(
                      '📜 Build History:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: buildHistory.value.isEmpty
                          ? const Center(
                              child: Text(
                                'Build history will appear here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: buildHistory.value.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  buildHistory.value[index],
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

            const SizedBox(height: 24),

            // Performance tips
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.speed, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Performance Tips',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• High build counts may indicate optimization opportunities\n'
                      '• Use const widgets where possible\n'
                      '• Consider memoization for expensive computations\n'
                      '• Split large widgets into smaller ones\n'
                      '• Use keys to preserve widget state',
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
                      '• Increments counter on each build\n'
                      '• Persists count across rebuilds\n'
                      '• Starts from 1 (first build)\n'
                      '• Simple performance monitoring\n'
                      '• Helps identify excessive rebuilds',
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

  String _getBuildReason(
    int counter,
    String text,
    bool checked,
    double slider,
  ) {
    // In a real scenario, you'd track what actually changed
    return 'State changed';
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useBuildsCount Code Example'),
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
                '''// Track build count
final buildsCount = useBuildsCount();

// Display in UI
Text('This widget has rebuilt \$buildsCount times')

// Debug performance
if (buildsCount > 100) {
  print('Warning: Excessive rebuilds detected!');
}

// Monitor specific widget
class ExpensiveWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final builds = useBuildsCount();
    
    if (kDebugMode) {
      print('ExpensiveWidget build #\$builds');
    }
    
    return Container();
  }
}

// Track rebuild reasons
useEffect(() {
  print('Build #\$buildsCount triggered');
  return null;
});

// Performance monitoring
final builds = useBuildsCount();
final lastBuildTime = useRef(DateTime.now());

useEffect(() {
  final duration = DateTime.now()
    .difference(lastBuildTime.value);
  print('Build #\$builds took \${duration.inMilliseconds}ms');
  lastBuildTime.value = DateTime.now();
  return null;
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
