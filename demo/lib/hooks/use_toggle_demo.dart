import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseToggleDemo extends HookWidget {
  const UseToggleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final toggle = useToggle(false);

    // For multiple checkbox example
    final option1 = useToggle(false);
    final option2 = useToggle(true);
    final option3 = useToggle(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useToggle Demo'),
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
              '🔀 useToggle Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toggle boolean states with optional custom setter',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Basic Toggle
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎯 Basic Toggle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Visual Toggle
                    Center(
                      child: GestureDetector(
                        onTap: () => toggle.toggle(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: toggle.value
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: toggle.value
                                    ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.4)
                                    : Colors.grey.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: toggle.value ? 100 : 0,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  toggle.value ? 'ON' : 'OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => toggle.toggle(),
                          child: const Text('Toggle'),
                        ),
                        OutlinedButton(
                          onPressed: () => toggle.toggle(true),
                          child: const Text('Set ON'),
                        ),
                        OutlinedButton(
                          onPressed: () => toggle.toggle(false),
                          child: const Text('Set OFF'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Current State
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Current state: '),
                          Text(
                            toggle.value.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
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

            // Multiple Toggles Example
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '☑️ Multiple Toggles (Settings)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Settings List
                    _buildSettingTile(
                      'Enable Notifications',
                      'Receive push notifications',
                      Icons.notifications,
                      option1.value,
                      option1,
                    ),
                    const Divider(),
                    _buildSettingTile(
                      'Dark Mode',
                      'Use dark theme',
                      Icons.dark_mode,
                      option2.value,
                      option2,
                    ),
                    const Divider(),
                    _buildSettingTile(
                      'Auto-save',
                      'Automatically save changes',
                      Icons.save,
                      option3.value,
                      option3,
                    ),

                    const SizedBox(height: 20),

                    // Summary
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Settings Summary:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Notifications: ${option1.value ? "ON" : "OFF"}\n'
                            'Dark Mode: ${option2.value ? "ON" : "OFF"}\n'
                            'Auto-save: ${option3.value ? "ON" : "OFF"}',
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Toggle vs Boolean Comparison
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.compare_arrows, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'useToggle vs useBoolean',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• useToggle returns a function that toggles or sets the value\n'
                      '• useBoolean returns an object with multiple methods\n'
                      '• useToggle is simpler for basic toggle functionality\n'
                      '• useBoolean provides more explicit methods (setTrue, setFalse)\n'
                      '• Both work great with switches and checkboxes',
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
                      '• Returns a ToggleState object with value getter and setter function\n'
                      '• Call setter() to toggle the value\n'
                      '• Call setter(true/false) to set specific value\n'
                      '• More concise than useBoolean for simple toggles\n'
                      '• Perfect for switches, checkboxes, and visibility states',
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

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ToggleState toggle,
  ) {
    return ListTile(
      leading: Icon(icon, color: value ? Colors.blue : Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(value: value, onChanged: (_) => toggle.toggle()),
      onTap: () => toggle.toggle(),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useToggle Code Example'),
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
                '''// Initialize toggle
final toggle = useToggle(false);

// Access the value
Text('Status: \${toggle.value}');

// Toggle the value
ElevatedButton(
  onPressed: () => toggle.toggle(),
  child: Text('Toggle'),
)

// Set specific value
toggle.toggle(true);  // Set to true
toggle.toggle(false); // Set to false

// Use with Switch
Switch(
  value: toggle.value,
  onChanged: (_) => toggle.toggle(),
)

// Multiple toggles
final darkMode = useToggle(false);
final notifications = useToggle(true);

// Conditional rendering
if (darkMode.value) {
  // Apply dark theme
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
