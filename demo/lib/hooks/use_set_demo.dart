import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseSetDemo extends HookWidget {
  const UseSetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = useSet<String>({'flutter', 'dart', 'mobile'});
    final newTagController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('useSet Demo'),
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
              '🏷️ useSet Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage unique values with Set operations',
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
                      '🏷️ Tag Manager',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add new tag
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: newTagController,
                            decoration: const InputDecoration(
                              labelText: 'New Tag',
                              hintText: 'Enter a unique tag...',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.label),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                final exists = tags.set.contains(value);
                                if (!exists) {
                                  tags.add(value);
                                  newTagController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added tag: $value'),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Tag already exists: $value',
                                      ),
                                      backgroundColor: Colors.orange,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filled(
                          onPressed: () {
                            final value = newTagController.text;
                            if (value.isNotEmpty) {
                              final exists = tags.set.contains(value);
                              if (!exists) {
                                tags.add(value);
                                newTagController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added tag: $value'),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tag already exists: $value'),
                                    backgroundColor: Colors.orange,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Tags display
                    const Text(
                      'Current Tags:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      constraints: const BoxConstraints(minHeight: 100),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: tags.set.isEmpty
                          ? const Center(
                              child: Text(
                                'No tags yet. Add some!',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: tags.set.map((tag) {
                                return Chip(
                                  label: Text(tag),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () {
                                    tags.remove(tag);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Removed tag: $tag'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Set operations
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: tags.set.isEmpty ? null : tags.reset,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear All'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () =>
                              tags.replace({'web', 'app', 'ui', 'ux'}),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Replace Set'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => tags.toggle('featured'),
                          icon: const Icon(Icons.star),
                          label: const Text('Toggle "featured"'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Set info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16),
                              const SizedBox(width: 8),
                              Text('Unique tags: ${tags.set.length}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tags.set.contains('flutter')
                                    ? 'Has "flutter" tag'
                                    : 'No "flutter" tag',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Set operations demo
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.functions, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Set Operations',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• add() - Returns true if added, false if exists\n'
                      '• remove() - Removes a value from the set\n'
                      '• has() - Check if value exists\n'
                      '• toggle() - Add if absent, remove if present\n'
                      '• clear() - Remove all values\n'
                      '• replace() - Replace entire set',
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
                      '• Manages unique values only\n'
                      '• No duplicates allowed\n'
                      '• Reactive updates on changes\n'
                      '• Perfect for tags, categories, selections\n'
                      '• Preserves insertion order',
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
        title: const Text('useSet Code Example'),
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
                '''// Initialize set
final tags = useSet<String>({'flutter', 'dart'});

// Access set
print(tags.value); // {flutter, dart}

// Add values
tags.add('mobile'); // Returns true
tags.add('flutter'); // Returns false (exists)

// Check existence
if (tags.has('web')) {
  print('Has web tag');
}

// Toggle value
tags.toggle('featured'); // Add if absent
tags.toggle('featured'); // Remove if present

// Remove value
tags.remove('dart');

// Replace entire set
tags.replace({'ios', 'android'});

// Clear all
tags.clear();

// Use in UI
Wrap(
  children: tags.value.map((tag) {
    return Chip(
      label: Text(tag),
      onDeleted: () => tags.remove(tag),
    );
  }).toList(),
)''',
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
