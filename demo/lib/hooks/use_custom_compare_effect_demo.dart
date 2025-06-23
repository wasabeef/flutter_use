import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:collection/collection.dart';

class UseCustomCompareEffectDemo extends HookWidget {
  const UseCustomCompareEffectDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo 1: Deep equality for lists
    final list1 = useState<List<int>>([1, 2, 3]);
    final deepEffectCount = useState(0);
    final normalEffectCount = useState(0);

    // Normal effect - runs on every state update even if values are same
    useEffect(() {
      normalEffectCount.value++;
      return null;
    }, [list1.value]);

    // Custom compare effect - only runs when list contents actually change
    useCustomCompareEffect(
      () {
        deepEffectCount.value++;
        return null;
      },
      [list1.value],
      (prev, next) {
        if (prev == null && next == null) return true;
        if (prev == null || next == null) return false;
        return const DeepCollectionEquality().equals(prev[0], next[0]);
      },
    );

    // Demo 2: Threshold-based comparison
    final sliderValue = useState(50.0);
    final thresholdEffectCount = useState(0);

    useCustomCompareEffect(
      () {
        thresholdEffectCount.value++;
        return null;
      },
      [sliderValue.value],
      (prev, next) {
        if (prev == null || next == null) return false;
        final prevValue = prev[0] as double;
        final nextValue = next[0] as double;
        // Only trigger if change is greater than 10
        return (prevValue - nextValue).abs() < 10;
      },
    );

    // Demo 3: Complex object comparison
    final user = useState<Map<String, dynamic>>({
      'name': 'John',
      'age': 30,
      'email': 'john@example.com',
    });
    final userEffectCount = useState(0);

    useCustomCompareEffect(
      () {
        userEffectCount.value++;
        return null;
      },
      [user.value],
      (prev, next) {
        if (prev == null || next == null) return false;
        final prevUser = prev[0] as Map<String, dynamic>;
        final nextUser = next[0] as Map<String, dynamic>;
        // Only trigger on name or email changes, ignore age
        return prevUser['name'] == nextUser['name'] &&
            prevUser['email'] == nextUser['email'];
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('useCustomCompareEffect Demo'),
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
              '🔍 useCustomCompareEffect Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Custom dependency comparison for useEffect',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Demo 1: Deep List Equality
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Deep List Equality',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('List 1: ${list1.value}'),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Creates new list with same values
                            list1.value = [1, 2, 3];
                          },
                          child: const Text('Same Values (New List)'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            list1.value = [1, 2, 3, 4];
                          },
                          child: const Text('Add Item'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Normal useEffect runs: ${normalEffectCount.value}',
                          ),
                          Text('Custom compare runs: ${deepEffectCount.value}'),
                          const SizedBox(height: 8),
                          Text(
                            'Custom effect only runs when list contents change!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
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

            // Demo 2: Threshold Comparison
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎚️ Threshold-Based Updates',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('Value: ${sliderValue.value.round()}'),
                    Slider(
                      value: sliderValue.value,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: sliderValue.value.round().toString(),
                      onChanged: (value) => sliderValue.value = value,
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Effect runs: ${thresholdEffectCount.value}'),
                          const SizedBox(height: 8),
                          const Text(
                            'Effect only triggers when change > 10 units',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Demo 3: Selective Property Comparison
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 Selective Property Updates',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('User: ${user.value}'),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            user.value = {...user.value, 'name': 'Jane'};
                          },
                          child: const Text('Change Name'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            user.value = {
                              ...user.value,
                              'age': user.value['age'] + 1,
                            };
                          },
                          child: const Text('Increase Age'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            user.value = {
                              ...user.value,
                              'email': 'jane@example.com',
                            };
                          },
                          child: const Text('Change Email'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Effect runs: ${userEffectCount.value}'),
                          const SizedBox(height: 8),
                          Text(
                            'Effect ignores age changes, only tracks name & email',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
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
                      '• Accepts custom equality function\n'
                      '• Compares dependencies your way\n'
                      '• Prevents unnecessary effect runs\n'
                      '• Perfect for complex objects\n'
                      '• Optimizes performance',
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
        title: const Text('useCustomCompareEffect Code Example'),
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
                '''// Deep equality for lists
useCustomCompareEffect(
  () {
    print('List contents changed');
    return null;
  },
  [myList],
  (prev, next) {
    return DeepCollectionEquality()
      .equals(prev?[0], next?[0]);
  },
);

// Threshold-based updates
final temperature = useState(20.0);

useCustomCompareEffect(
  () {
    // Only alert on significant changes
    showTemperatureAlert();
    return null;
  },
  [temperature.value],
  (prev, next) {
    final diff = (prev![0] - next![0]).abs();
    return diff < 5; // Ignore < 5 degree changes
  },
);

// Selective property tracking
final formData = useState({
  'username': '',
  'password': '', 
  'timestamp': DateTime.now(),
});

useCustomCompareEffect(
  () {
    validateCredentials();
    return null;
  },
  [formData.value],
  (prev, next) {
    final p = prev?[0] as Map;
    final n = next?[0] as Map;
    // Only run on username/password change
    return p['username'] == n['username'] &&
           p['password'] == n['password'];
  },
);

// Debounced comparison
useCustomCompareEffect(
  () => saveToDatabase(),
  [searchQuery],
  (prev, next) {
    // Custom debounce logic
    return isSimilar(prev, next);
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
