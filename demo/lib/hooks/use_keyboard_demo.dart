import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseKeyboardDemo extends HookWidget {
  const UseKeyboardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboard = useKeyboard();
    final keyboardExtended = useKeyboardExtended();
    final messageController = useTextEditingController();
    final messages = useState<List<String>>([
      'Welcome to the chat!',
      'This demo shows keyboard management.',
      'Try typing a message below.',
    ]);

    // Demo 2: Form with keyboard-aware scroll
    final scrollController = useKeyboardAwareScroll(
      config: const KeyboardScrollConfig(
        extraScrollPadding: 20,
        animateScroll: true,
      ),
    );

    // Check if this is likely a desktop browser
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = _isDesktopPlatform(context, screenWidth);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('useKeyboard Demo'),
          actions: [
            TextButton(
              onPressed: () => _showCodeDialog(context),
              child: const Text(
                '📋 Code',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chat UI'),
              Tab(text: 'Smart Form'),
              Tab(text: 'Info'),
            ],
          ),
        ),
        body: isDesktop
            ? _buildDesktopMessage(context)
            : TabBarView(
                children: [
                  // Tab 1: Chat UI Demo
                  GestureDetector(
                    onTap: keyboardExtended.dismiss,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.all(16),
                            itemCount: messages.value.length,
                            itemBuilder: (context, index) {
                              final reversedIndex =
                                  messages.value.length - 1 - index;
                              final isUser = reversedIndex % 2 == 1;
                              return Align(
                                alignment: isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    messages.value[reversedIndex],
                                    style: TextStyle(
                                      color: isUser ? Colors.white : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Keyboard info bar
                        AnimatedContainer(
                          duration: keyboard.animationDuration,
                          height: keyboard.isVisible ? 40 : 0,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              const Icon(Icons.keyboard, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Keyboard: ${keyboard.height.round()}px '
                                '(${(keyboardExtended.heightPercentage * 100).round()}%)',
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: keyboardExtended.dismiss,
                                child: const Text('Dismiss'),
                              ),
                            ],
                          ),
                        ),

                        // Message input
                        AnimatedContainer(
                          duration: keyboard.animationDuration,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, -1),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom: keyboard.height + 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Type a message...',
                                    filled: true,
                                    fillColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  onSubmitted: (text) {
                                    if (text.isNotEmpty) {
                                      messages.value = [
                                        ...messages.value,
                                        text,
                                      ];
                                      messageController.clear();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filled(
                                onPressed: () {
                                  final text = messageController.text;
                                  if (text.isNotEmpty) {
                                    messages.value = [...messages.value, text];
                                    messageController.clear();
                                  }
                                },
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab 2: Smart Form
                  ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      const Text(
                        '📝 Keyboard-Aware Form',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Form automatically scrolls to keep focused field visible',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // Generate multiple form fields
                      for (int i = 0; i < 8; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: _getFieldLabel(i),
                              prefixIcon: Icon(_getFieldIcon(i)),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: _getKeyboardType(i),
                            maxLines: i == 7 ? 3 : 1,
                          ),
                        ),

                      const SizedBox(height: 100), // Extra space at bottom
                    ],
                  ),

                  // Tab 3: Keyboard Info
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⌨️ Keyboard State',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Basic keyboard state
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'useKeyboard()',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow('Visible', keyboard.isVisible),
                                _buildInfoRow('Hidden', keyboard.isHidden),
                                _buildInfoRow(
                                  'Height',
                                  '${keyboard.height.round()}px',
                                ),
                                _buildInfoRow(
                                  'Animation',
                                  '${keyboard.animationDuration.inMilliseconds}ms',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Extended keyboard state
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'useKeyboardExtended()',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Bottom Inset',
                                  '${keyboardExtended.bottomInset.round()}px',
                                ),
                                _buildInfoRow(
                                  'Viewport Height',
                                  '${keyboardExtended.viewportHeight.round()}px',
                                ),
                                _buildInfoRow(
                                  'Height %',
                                  '${(keyboardExtended.heightPercentage * 100).round()}%',
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: keyboardExtended.dismiss,
                                    icon: const Icon(Icons.keyboard_hide),
                                    label: const Text('Dismiss Keyboard'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Test field
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Test Keyboard',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Tap here to show keyboard',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Visual representation
                        if (keyboard.isVisible)
                          Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.keyboard, size: 48),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Keyboard is visible',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.grey.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          height:
                                              100 *
                                              keyboardExtended.heightPercentage,
                                          child: Container(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            child: const Center(
                                              child: Text(
                                                'Keyboard',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
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
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _getFieldLabel(int index) {
    const labels = [
      'First Name',
      'Last Name',
      'Email',
      'Phone',
      'Address',
      'City',
      'Zip Code',
      'Notes',
    ];
    return labels[index % labels.length];
  }

  IconData _getFieldIcon(int index) {
    const icons = [
      Icons.person,
      Icons.person_outline,
      Icons.email,
      Icons.phone,
      Icons.home,
      Icons.location_city,
      Icons.pin,
      Icons.notes,
    ];
    return icons[index % icons.length];
  }

  TextInputType _getKeyboardType(int index) {
    const types = [
      TextInputType.name,
      TextInputType.name,
      TextInputType.emailAddress,
      TextInputType.phone,
      TextInputType.streetAddress,
      TextInputType.text,
      TextInputType.number,
      TextInputType.multiline,
    ];
    return types[index % types.length];
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useKeyboard Code Example'),
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
                '''// Basic keyboard tracking
final keyboard = useKeyboard();

AnimatedContainer(
  duration: keyboard.animationDuration,
  padding: EdgeInsets.only(
    bottom: keyboard.height,
  ),
  child: MessageInput(),
)

// Extended version with utilities
final keyboard = useKeyboardExtended();

GestureDetector(
  onTap: keyboard.dismiss,
  child: Scaffold(
    body: Text(
      'Keyboard: \${keyboard.heightPercentage * 100}%'
    ),
  ),
)

// Simple visibility check
final isVisible = useIsKeyboardVisible();

// Keyboard-aware scrolling
final scrollController = useKeyboardAwareScroll(
  config: KeyboardScrollConfig(
    extraScrollPadding: 20,
    animateScroll: true,
  ),
);

ListView(
  controller: scrollController,
  children: formFields,
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

  bool _isDesktopPlatform(BuildContext context, double screenWidth) {
    // Use kIsWeb to detect web platform
    if (kIsWeb) {
      // On web, check screen width and touch capability
      return screenWidth > 768;
    }
    // On native platforms, keyboard will work
    return false;
  }

  Widget _buildDesktopMessage(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smartphone,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Mobile Experience Required',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'The useKeyboard hook is designed for mobile devices with software keyboards. '
              'On desktop browsers with physical keyboards, there\'s no on-screen keyboard to track.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 12),
                        Text(
                          'To experience this demo:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Text('📱'),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Open this page on your mobile device'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text('🔗'),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Or use browser dev tools to simulate mobile',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text('⌨️'),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tap input fields to see the virtual keyboard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showCodeDialog(context),
                        icon: const Icon(Icons.code),
                        label: const Text('View Code Example'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Current Environment',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.computer, size: 20),
                      const SizedBox(width: 8),
                      const Text('Platform: '),
                      Text(
                        'Desktop Browser',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.aspect_ratio, size: 20),
                      const SizedBox(width: 8),
                      const Text('Screen Width: '),
                      Text(
                        '${MediaQuery.of(context).size.width.round()}px',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.keyboard, size: 20),
                      const SizedBox(width: 8),
                      const Text('Virtual Keyboard: '),
                      Text(
                        'Not Available',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
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
    );
  }
}
