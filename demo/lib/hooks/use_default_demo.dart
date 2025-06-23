import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseDefaultDemo extends HookWidget {
  const UseDefaultDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Use default with initial values
    final textInput = useDefault('', 'Enter text here...');
    final numberInput = useDefault<int?>(null, 0);
    final selectedOption = useDefault<String?>(null, 'Option A');

    return Scaffold(
      appBar: AppBar(
        title: const Text('useDefault Demo'),
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
              '📝 useDefault Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Provide default values for nullable or empty states',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Text Input Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✏️ Text Input with Default',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      onChanged: (value) => textInput.value = value,
                      decoration: InputDecoration(
                        labelText: 'Your Text',
                        hintText: 'Type something...',
                        border: const OutlineInputBorder(),
                        suffixIcon: textInput.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => textInput.value = '',
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Display with default
                    Container(
                      width: double.infinity,
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
                          const Text(
                            'Displayed Value:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            textInput.value,
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: textInput.value == 'Enter text here...'
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              color: textInput.value == 'Enter text here...'
                                  ? Colors.grey
                                  : null,
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

            // Number Selection Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔢 Number Selection with Default',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text('Select a quantity:'),
                    const SizedBox(height: 12),

                    // Number options
                    Wrap(
                      spacing: 8,
                      children: [
                        for (int? num in [null, 1, 5, 10, 25, 50])
                          ChoiceChip(
                            label: Text(num?.toString() ?? 'None'),
                            selected: numberInput.value == num,
                            onSelected: (_) => numberInput.value = num,
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Result display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart, color: Colors.blue),
                          const SizedBox(width: 12),
                          Text(
                            'Quantity: ${numberInput.value ?? 5}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (numberInput.value == null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'DEFAULT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
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

            // Dropdown Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Dropdown with Default',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String?>(
                      value: selectedOption.value,
                      decoration: const InputDecoration(
                        labelText: 'Select Option',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('None selected'),
                        ),
                        ...['Option A', 'Option B', 'Option C', 'Option D'].map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        ),
                      ],
                      onChanged: (value) => selectedOption.value = value,
                    ),

                    const SizedBox(height: 20),

                    // Display selection
                    Row(
                      children: [
                        const Text('Selected: '),
                        Chip(
                          label: Text(selectedOption.value ?? 'Option A'),
                          backgroundColor: selectedOption.value == null
                              ? Colors.orange.withValues(alpha: 0.2)
                              : Theme.of(context).colorScheme.primaryContainer,
                        ),
                        if (selectedOption.value == null) ...[
                          const SizedBox(width: 8),
                          const Text(
                            '(using default)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ],
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
                      '• Provides a default value for nullable or empty states\n'
                      '• Returns DefaultState with value getter/setter only\n'
                      '• Useful for forms, settings, and optional configurations\n'
                      '• Helps avoid null checks and provides fallback values\n'
                      '• Can handle any type: String, int, custom objects, etc.',
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
        title: const Text('useDefault Code Example'),
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
                '''// Basic usage - (defaultValue, initialValue)
final username = useDefault('Anonymous', '');
final quantity = useDefault<int>(1, 5);

// Access current value
print(username.value); // Current value or default

// Update value
username.value = 'John Doe';
quantity.value = 10;

// Set to null triggers default fallback
username.value = null; // Falls back to 'Anonymous'
quantity.value = null; // Falls back to 1

// Display pattern
Text(username.value), // Always non-null

// With nullable types
final selectedId = useDefault<String>('default-id', 'user-123');

// Form field with default
TextField(
  onChanged: (value) => username.value = value,
  decoration: InputDecoration(
    hintText: 'Enter name (default: Anonymous)',
  ),
),

// Reset by setting to null
ElevatedButton(
  onPressed: () => username.value = null,
  child: Text('Reset to Default'),
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
