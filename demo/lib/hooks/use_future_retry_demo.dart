import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseFutureRetryDemo extends HookWidget {
  const UseFutureRetryDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final failureRate = useState(50);

    // Simulated API call that can fail
    Future<String> fetchData() async {
      await Future.delayed(const Duration(seconds: 2));
      final random = Random();
      if (random.nextInt(100) < failureRate.value) {
        throw Exception('Network error: Failed to fetch data');
      }
      return 'Data loaded successfully at ${DateTime.now().toString().substring(11, 19)}';
    }

    final futureState = useFutureRetry(fetchData(), preserveState: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useFutureRetry Demo'),
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
              '🔄 useFutureRetry Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage async operations with retry capability',
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
                      '🌐 Network Request Simulator',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Failure rate control
                    const Text(
                      'Failure Rate:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: failureRate.value.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 10,
                            label: '${failureRate.value}%',
                            onChanged: (value) =>
                                failureRate.value = value.round(),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            '${failureRate.value}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Status display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          futureState.snapshot,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(futureState.snapshot),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getStatusIcon(futureState.snapshot),
                            size: 48,
                            color: _getStatusColor(futureState.snapshot),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getStatusText(futureState.snapshot),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(futureState.snapshot),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (futureState.snapshot.connectionState ==
                              ConnectionState.waiting)
                            const CircularProgressIndicator()
                          else if (futureState.snapshot.hasData)
                            Text(
                              futureState.snapshot.data!,
                              style: const TextStyle(color: Colors.green),
                              textAlign: TextAlign.center,
                            )
                          else if (futureState.snapshot.hasError)
                            Text(
                              futureState.snapshot.error.toString(),
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: futureState.retry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Connection state info
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
                          Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Connection State: ${futureState.snapshot.connectionState.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Has Data: ${futureState.snapshot.hasData}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Has Error: ${futureState.snapshot.hasError}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Features
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
                      '• Retry failed operations easily\n'
                      '• Access AsyncSnapshot state\n'
                      '• Preserve or reset state on retry\n'
                      '• Perfect for network requests\n'
                      '• Built on top of useFuture',
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
                      '• Wraps Flutter\'s useFuture hook\n'
                      '• Provides retry() method\n'
                      '• Re-executes the future on retry\n'
                      '• Manages loading/error states\n'
                      '• Option to preserve previous data',
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

  Color _getStatusColor(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Colors.orange;
    } else if (snapshot.hasError) {
      return Colors.red;
    } else if (snapshot.hasData) {
      return Colors.green;
    }
    return Colors.grey;
  }

  IconData _getStatusIcon(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Icons.hourglass_empty;
    } else if (snapshot.hasError) {
      return Icons.error_outline;
    } else if (snapshot.hasData) {
      return Icons.check_circle_outline;
    }
    return Icons.circle_outlined;
  }

  String _getStatusText(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return 'Loading...';
    } else if (snapshot.hasError) {
      return 'Error Occurred';
    } else if (snapshot.hasData) {
      return 'Success!';
    }
    return 'Ready';
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useFutureRetry Code Example'),
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
                '''// Basic usage
final futureState = useFutureRetry(
  fetchUserData(),
);

// Check state
if (futureState.snapshot.hasData) {
  return Text(futureState.snapshot.data!);
} else if (futureState.snapshot.hasError) {
  return Column(
    children: [
      Text('Error: \${futureState.snapshot.error}'),
      ElevatedButton(
        onPressed: futureState.retry,
        child: Text('Retry'),
      ),
    ],
  );
}

// With initial data
final userState = useFutureRetry(
  fetchUser(id),
  initialData: User.empty(),
  preserveState: true, // Keep old data
);

// Network request with retry
Future<List<Post>> fetchPosts() async {
  final response = await http.get(...);
  if (response.statusCode != 200) {
    throw Exception('Failed to load');
  }
  return Post.fromJson(response.body);
}

final posts = useFutureRetry(fetchPosts());

// Retry on pull to refresh
RefreshIndicator(
  onRefresh: () async => posts.retry(),
  child: ListView(...),
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
