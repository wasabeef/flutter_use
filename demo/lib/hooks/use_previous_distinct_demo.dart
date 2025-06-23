import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UsePreviousDistinctDemo extends HookWidget {
  const UsePreviousDistinctDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic example with primitive value
    final counter = useState(0);
    final previousCounter = usePreviousDistinct(counter.value);

    // Example with object comparison
    final user = useState(User(id: 1, name: 'John', age: 25));
    final previousUser = usePreviousDistinct(
      user.value,
      (prev, next) => prev.id == next.id && prev.name == next.name,
    );

    // Example with case-insensitive string comparison
    final text = useState('Hello');
    final previousText = usePreviousDistinct(
      text.value,
      (prev, next) => prev.toLowerCase() == next.toLowerCase(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('usePreviousDistinct Demo'),
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
            // Header
            const Text(
              '⏮️ usePreviousDistinct Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track previous distinct values with custom comparison logic',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Basic Counter Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔢 Basic Counter Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${counter.value}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Current'),
                          ],
                        ),
                        const Icon(Icons.arrow_forward, size: 32),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                previousCounter != null
                                    ? '$previousCounter'
                                    : 'null',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Previous'),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => counter.value++,
                          icon: const Icon(Icons.add),
                          label: const Text('Increment'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => counter.value--,
                          icon: const Icon(Icons.remove),
                          label: const Text('Decrement'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => counter.value = counter.value,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Same Value'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Notice: Setting the same value doesn\'t update the previous value',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Object Comparison Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 Object Comparison Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Custom comparison: only tracks changes if ID or name changes',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _buildUserCard(
                            'Current User',
                            user.value,
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUserCard(
                            'Previous User',
                            previousUser,
                            Colors.grey[300]!,
                            Colors.grey[700]!,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            user.value = User(
                              id: user.value.id + 1,
                              name: user.value.name,
                              age: user.value.age,
                            );
                          },
                          child: const Text('Change ID'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            user.value = User(
                              id: user.value.id,
                              name: 'Jane',
                              age: user.value.age,
                            );
                          },
                          child: const Text('Change Name'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            user.value = User(
                              id: user.value.id,
                              name: user.value.name,
                              age: user.value.age + 1,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Change Age (Ignored)'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Age changes are ignored by our custom comparison function',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Case-Insensitive String Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Case-Insensitive String Example',
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
                              const Text(
                                'Current',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  text.value,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Previous',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  previousText ?? 'null',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      onChanged: (value) => text.value = value,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                        hintText: 'Try changing case...',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: text.value),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                text.value = text.value.toUpperCase(),
                            child: const Text('UPPERCASE'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                text.value = text.value.toLowerCase(),
                            child: const Text('lowercase'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Case changes alone won\'t update the previous value',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
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
                      '• Tracks the previous distinct value of a variable\n'
                      '• Only updates when the value actually changes\n'
                      '• Uses default equality (==) or custom comparison function\n'
                      '• Returns null on first render (no previous value)\n'
                      '• Perfect for detecting meaningful changes in complex objects',
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

  Widget _buildUserCard(
    String title,
    User? user,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 8),
          if (user != null) ...[
            Text('ID: ${user.id}', style: TextStyle(color: textColor)),
            Text('Name: ${user.name}', style: TextStyle(color: textColor)),
            Text('Age: ${user.age}', style: TextStyle(color: textColor)),
          ] else
            Text('null', style: TextStyle(color: textColor)),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('usePreviousDistinct Code Example'),
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
                '''// Basic usage with primitive value
final counter = useState(0);
final previousCounter = usePreviousDistinct(counter.value);

// Custom comparison for objects
final user = useState(User(id: 1, name: 'John'));
final previousUser = usePreviousDistinct(
  user.value,
  (prev, next) => prev.id == next.id && 
                  prev.name == next.name,
);

// Case-insensitive string comparison
final text = useState('Hello');
final previousText = usePreviousDistinct(
  text.value,
  (prev, next) => 
    prev.toLowerCase() == next.toLowerCase(),
);

// Usage in widget
Text('Current: \${counter.value}');
Text('Previous: \${previousCounter ?? "none"}');

// The hook only updates previous value when
// the comparison function returns false''',
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

// Simple User class for demo
class User {
  final int id;
  final String name;
  final int age;

  User({required this.id, required this.name, required this.age});
}
