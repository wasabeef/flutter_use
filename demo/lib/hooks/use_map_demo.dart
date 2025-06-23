import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseMapDemo extends HookWidget {
  const UseMapDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = useMap<String, dynamic>({
      'theme': 'dark',
      'notifications': true,
      'fontSize': 16,
      'language': 'en',
    });

    final keyController = useTextEditingController();
    final valueController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('useMap Demo'),
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
              '🗺️ useMap Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Key-value state management with Map utilities',
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
                      '⚙️ Settings Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Settings display
                    ...settings.map.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: _buildValueWidget(entry, settings)),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () => settings.remove(entry.key),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (settings.map.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No settings. Add some!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    const Divider(height: 32),

                    // Add new entry
                    const Text(
                      'Add New Setting:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: keyController,
                            decoration: const InputDecoration(
                              labelText: 'Key',
                              hintText: 'e.g., color',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: valueController,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              hintText: 'e.g., blue',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () {
                            if (keyController.text.isNotEmpty &&
                                valueController.text.isNotEmpty) {
                              settings.add(
                                keyController.text,
                                valueController.text,
                              );
                              keyController.clear();
                              valueController.clear();
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Map actions
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: settings.map.isEmpty
                              ? null
                              : settings.reset,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear All'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => settings.replace({
                            'theme': 'light',
                            'notifications': false,
                            'fontSize': 14,
                          }),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Map info
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
                              Text('Size: ${settings.map.length} entries'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.key, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Keys: ${settings.map.keys.join(", ")}',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                      '• Enhanced Map with set, remove, clear methods\n'
                      '• setAll() to replace entire map\n'
                      '• get() with optional default value\n'
                      '• Automatically triggers rebuilds on changes\n'
                      '• Perfect for settings, configurations, key-value data',
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

  Widget _buildValueWidget(
    MapEntry<String, dynamic> entry,
    MapAction<String, dynamic> settings,
  ) {
    final value = entry.value;

    if (value is bool) {
      return Switch(
        value: value,
        onChanged: (newValue) => settings.add(entry.key, newValue),
      );
    } else if (value is int || value is double) {
      return Slider(
        value: (value as num).toDouble(),
        min: 10,
        max: 24,
        divisions: 14,
        label: value.toString(),
        onChanged: (newValue) => settings.add(entry.key, newValue.round()),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(value.toString()),
      );
    }
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useMap Code Example'),
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
                '''// Initialize map
final config = useMap<String, dynamic>({
  'apiUrl': 'https://api.example.com',
  'timeout': 30,
  'retries': 3,
});

// Access values
print(config.map['apiUrl']);
print(config.get('apiUrl'));

// Add/update values
config.add('apiUrl', 'https://new-api.com');
config.add('debug', true);

// Remove entries
config.remove('debug');

// Bulk operations
config.addAll({
  'feature1': true,
  'feature2': false,
});

// Replace entire map
config.replace({
  'apiUrl': 'https://prod.api.com',
  'timeout': 60,
});

// Reset to initial
config.reset();

// Check existence
if (config.map.containsKey('apiUrl')) {
  // Use the value
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
