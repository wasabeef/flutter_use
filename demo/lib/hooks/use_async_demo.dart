import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseAsyncDemo extends HookWidget {
  const UseAsyncDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo 1: Basic async operation
    final userState = useAsync(() async {
      await Future.delayed(const Duration(seconds: 2));
      return {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatar': '👤',
      };
    });

    // Demo 3: Refreshable data
    final refreshKey = useState(0);
    final postsState = useAsync(() async {
      await Future.delayed(const Duration(seconds: 1));
      return List.generate(
        5,
        (i) => {
          'id': i + refreshKey.value * 5,
          'title': 'Post ${i + 1 + refreshKey.value * 5}',
          'content': 'This is the content of post ${i + 1}',
        },
      );
    }, keys: [refreshKey.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useAsync Demo'),
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
              '🔄 useAsync Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage async operations with loading, data, and error states',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Demo 1: Basic Async
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 Auto-loading User Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (userState.loading)
                      const Center(child: CircularProgressIndicator())
                    else if (userState.hasError)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 12),
                            Text('Error: ${userState.error}'),
                          ],
                        ),
                      )
                    else if (userState.hasData)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              userState.data!['avatar'] as String,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userState.data!['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    userState.data!['email'] as String,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
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

            // Demo 3: Refreshable Data
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '📰 Refreshable Posts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => refreshKey.value++,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (postsState.loading)
                      const Center(child: CircularProgressIndicator())
                    else if (postsState.hasData)
                      ...postsState.data!.map(
                        (post) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post['content'] as String,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
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
                          'Features',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Automatic loading state management\n'
                      '• Error handling with retry support\n'
                      '• Dependency tracking for re-execution\n'
                      '• Manual execution with useAsyncFn\n'
                      '• Type-safe data handling\n'
                      '• Cancellation of previous operations',
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
        title: const Text('useAsync Code Example'),
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
                '''// Basic usage - auto-executes
final userState = useAsync(() async {
  final response = await api.getUser();
  return response.data;
});

if (userState.loading) {
  return CircularProgressIndicator();
}

if (userState.hasError) {
  return Text('Error: \${userState.error}');
}

return UserProfile(user: userState.data!);

// Dependency tracking
final dataState = useAsync(
  () => fetchData(userId),
  keys: [userId], // Re-fetch when userId changes
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
