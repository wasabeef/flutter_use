import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseClickAwayDemo extends HookWidget {
  const UseClickAwayDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDropdownOpen = useState(false);
    final isModalOpen = useState(false);
    final clickCount = useState(0);

    // Click away for dropdown
    final dropdownClickAway = useClickAway(() {
      if (isDropdownOpen.value) {
        isDropdownOpen.value = false;
      }
    });

    // Click away for modal
    final modalClickAway = useClickAway(() {
      if (isModalOpen.value) {
        isModalOpen.value = false;
      }
    });

    // Click away for counter (just for demo)
    final counterClickAway = useClickAway(() {
      clickCount.value++;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('useClickAway Demo'),
        actions: [
          TextButton(
            onPressed: () => _showCodeDialog(context),
            child: const Text('📋 Code', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  '👆 useClickAway Demo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Detect clicks outside of specific elements',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Dropdown Demo
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📋 Dropdown Example',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Click the button to open the dropdown, then click anywhere outside to close it.',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),

                        // Dropdown Container
                        Container(
                          key: dropdownClickAway.ref,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  isDropdownOpen.value = !isDropdownOpen.value;
                                },
                                icon: Icon(
                                  isDropdownOpen.value
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                                label: Text(
                                  isDropdownOpen.value
                                      ? 'Close Dropdown'
                                      : 'Open Dropdown',
                                ),
                              ),

                              if (isDropdownOpen.value) ...[
                                const SizedBox(height: 8),
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.2),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDropdownItem(
                                        'Option 1',
                                        Icons.star,
                                      ),
                                      _buildDropdownItem(
                                        'Option 2',
                                        Icons.favorite,
                                      ),
                                      _buildDropdownItem(
                                        'Option 3',
                                        Icons.settings,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Modal Demo
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🪟 Modal Example',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Click the button to show a modal, then click outside the modal content to close it.',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: () {
                            isModalOpen.value = true;
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open Modal'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Click Counter Demo
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎯 Click Counter Example',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'This box tracks clicks outside of it. Click anywhere outside the blue area below.',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          key: counterClickAway.ref,
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Protected Area',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Clicks outside this area: ${clickCount.value}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  clickCount.value = 0;
                                },
                                child: const Text('Reset Counter'),
                              ),
                            ],
                          ),
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
                          '• Returns a GlobalKey to attach to your target widget\n'
                          '• Listens for clicks anywhere on the screen\n'
                          '• Calls your callback when clicks occur outside the target\n'
                          '• Perfect for dropdowns, modals, and tooltips\n'
                          '• Automatically handles cleanup when widget unmounts',
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

                const SizedBox(height: 100), // Extra space
              ],
            ),
          ),

          // Modal Overlay
          if (isModalOpen.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    key: modalClickAway.ref,
                    width: 300,
                    height: 200,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Modal Content',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Click outside this modal to close it',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            isModalOpen.value = false;
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useClickAway Code Example'),
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
                '''final isOpen = useState(false);

final clickAway = useClickAway(() {
  if (isOpen.value) {
    isOpen.value = false;
  }
});

// Use the ref with your target widget
Container(
  key: clickAway.ref,
  child: Column(
    children: [
      ElevatedButton(
        onPressed: () => isOpen.value = true,
        child: Text('Open Dropdown'),
      ),
      
      if (isOpen.value)
        Container(
          // Dropdown content
          child: Text('Dropdown Content'),
        ),
    ],
  ),
)

// Callback is called when user clicks outside
// the widget with the clickAway.ref key''',
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
