import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseStateListDemo extends HookWidget {
  const UseStateListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // UseStateList manages a list of states with circular navigation
    final colorStates = useStateList([
      {'color': Colors.red, 'name': 'Red'},
      {'color': Colors.green, 'name': 'Green'},
      {'color': Colors.blue, 'name': 'Blue'},
      {'color': Colors.purple, 'name': 'Purple'},
      {'color': Colors.orange, 'name': 'Orange'},
    ]);

    final history = useState<List<String>>([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useStateList Demo'),
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
              '🔄 useStateList Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Circular iteration through a list of states',
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
                      '🎨 Color Carousel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Color display
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: (colorStates.state['color'] as Color),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (colorStates.state['color'] as Color)
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            colorStates.state['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black45),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Navigation controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            colorStates.prev();
                            history.value = [
                              '⬅️ Previous: ${colorStates.state['name']}',
                              ...history.value.take(9),
                            ];
                          },
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 32,
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            Text(
                              '${colorStates.currentIndex + 1} / ${colorStates.list.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Progress indicator
                            SizedBox(
                              width: 100,
                              child: LinearProgressIndicator(
                                value:
                                    (colorStates.currentIndex + 1) /
                                    colorStates.list.length,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorStates.state['color'] as Color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        IconButton.filled(
                          onPressed: () {
                            colorStates.next();
                            history.value = [
                              '➡️ Next: ${colorStates.state['name']}',
                              ...history.value.take(9),
                            ];
                          },
                          icon: const Icon(Icons.arrow_forward),
                          iconSize: 32,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Quick jump buttons
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(colorStates.list.length, (index) {
                        final item = colorStates.list[index];
                        final isActive = colorStates.currentIndex == index;
                        return ActionChip(
                          label: Text(item['name'] as String),
                          onPressed: () {
                            colorStates.setStateAt(index);
                            history.value = [
                              '🎯 Jumped to: ${item['name']}',
                              ...history.value.take(9),
                            ];
                          },
                          backgroundColor: isActive
                              ? (item['color'] as Color)
                              : null,
                          labelStyle: TextStyle(
                            color: isActive ? Colors.white : null,
                            fontWeight: isActive ? FontWeight.bold : null,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // Activity log
                    const Text(
                      'Activity Log:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: history.value.isEmpty
                          ? const Center(
                              child: Text(
                                'Navigate to see history',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: history.value.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  history.value[index],
                                  style: const TextStyle(
                                    color: Colors.white,
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

            // Feature showcase
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.stars, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Key Features',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Circular navigation (wraps around)\n'
                      '• Direct access by index\n'
                      '• Forward/backward navigation\n'
                      '• Current position tracking\n'
                      '• Perfect for carousels, wizards, tours',
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
                      '• Manages a list of predefined states\n'
                      '• Provides circular iteration methods\n'
                      '• Tracks current position in the list\n'
                      '• Allows direct jumping to any state\n'
                      '• No duplicate states - pure navigation',
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
        title: const Text('useStateList Code Example'),
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
                '''// Initialize with state list
final carousel = useStateList([
  'Slide 1',
  'Slide 2', 
  'Slide 3',
  'Slide 4',
]);

// Access current state
print(carousel.state); // 'Slide 1'
print(carousel.currentIndex); // 0

// Navigate forward
carousel.next(); // Goes to 'Slide 2'
carousel.next(); // Goes to 'Slide 3'
carousel.next(); // Goes to 'Slide 4'
carousel.next(); // Wraps to 'Slide 1'

// Navigate backward
carousel.prev(); // Goes to 'Slide 4'

// Jump to specific index
carousel.setStateAt(2); // Goes to 'Slide 3'

// Set by value
carousel.setState('Slide 1'); // Finds and sets

// Image carousel example
final images = useStateList([
  'assets/img1.jpg',
  'assets/img2.jpg',
  'assets/img3.jpg',
]);

Image.asset(
  images.state,
  fit: BoxFit.cover,
)

// Wizard steps
final wizard = useStateList([
  WizardStep.personal,
  WizardStep.contact,
  WizardStep.review,
  WizardStep.complete,
]);

// Check if can go next
final canGoNext = 
  wizard.currentIndex < wizard.list.length - 1;''',
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
