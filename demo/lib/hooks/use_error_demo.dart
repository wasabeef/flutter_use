import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseErrorDemo extends HookWidget {
  const UseErrorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final errorState = useError();
    final exceptionState = useException();
    final operationCount = useState(0);
    final successCount = useState(0);
    final errorHistory = useState<List<String>>([]);

    void performRiskyOperation(String operation) {
      operationCount.value++;
      try {
        final random = Random();
        final shouldFail = random.nextBool();

        if (shouldFail) {
          switch (operation) {
            case 'network':
              throw StateError('Network connection failed');
            case 'parse':
              throw ArgumentError('Invalid JSON format');
            case 'auth':
              throw UnsupportedError('Authentication failed');
            case 'custom':
              throw CustomError('Custom operation failed');
          }
        }

        successCount.value++;
        errorHistory.value = [
          '✅ ${operation.toUpperCase()} succeeded',
          ...errorHistory.value.take(9),
        ];
      } catch (e) {
        errorHistory.value = [
          '❌ ${operation.toUpperCase()} failed: $e',
          ...errorHistory.value.take(9),
        ];

        if (e is Error) {
          errorState.dispatch(e);
        } else if (e is Exception) {
          exceptionState.dispatch(e);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('useError & useException Demo'),
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
              '⚠️ useError & useException Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage error and exception states in your app',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Error State Display
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🚨 Current Error State',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Error display
                    if (errorState.value != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 8),
                                Text(
                                  'Error: ${errorState.value.runtimeType}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              errorState.value.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'No errors',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Exception display
                    if (exceptionState.value != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  'Exception: ${exceptionState.value.runtimeType}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              exceptionState.value.toString(),
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Operations
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎮 Risky Operations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Each operation has a 50% chance of failure',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Operation buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => performRiskyOperation('network'),
                          icon: const Icon(Icons.wifi),
                          label: const Text('Network Call'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => performRiskyOperation('parse'),
                          icon: const Icon(Icons.code),
                          label: const Text('Parse Data'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => performRiskyOperation('auth'),
                          icon: const Icon(Icons.lock),
                          label: const Text('Authenticate'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => performRiskyOperation('custom'),
                          icon: const Icon(Icons.build),
                          label: const Text('Custom Task'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Operations'),
                            Text(
                              '${operationCount.value}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Successes'),
                            Text(
                              '${successCount.value}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Failures'),
                            Text(
                              '${operationCount.value - successCount.value}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // History
                    const Text(
                      'Operation History:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: errorHistory.value.isEmpty
                          ? const Center(
                              child: Text(
                                'No operations yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: errorHistory.value.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  errorHistory.value[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'monospace',
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
                      '• useError manages Error objects\n'
                      '• useException manages Exception objects\n'
                      '• dispatch() stores the error/exception\n'
                      '• value property retrieves current state\n'
                      '• Perfect for error boundaries and recovery',
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
        title: const Text('useError & useException Code Example'),
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
                '''// Use error state
final errorState = useError();

// Dispatch errors
try {
  someRiskyOperation();
} catch (e) {
  if (e is Error) {
    errorState.dispatch(e);
  }
}

// Check for errors
if (errorState.value != null) {
  return ErrorWidget(errorState.value!);
}

// Use exception state
final exceptionState = useException();

// API call example
Future<void> fetchData() async {
  try {
    final response = await api.get('/data');
    processData(response);
  } on NetworkException catch (e) {
    exceptionState.dispatch(e);
  } on FormatException catch (e) {
    exceptionState.dispatch(e);
  }
}

// Error boundary pattern  
if (errorState.value != null) {
  return ErrorRecoveryWidget(
    error: errorState.value!,
    onRetry: () {
      // Clear error by creating new state
      retry();
    },
  );
}

// Global error handling
useEffect(() {
  if (errorState.value != null) {
    logError(errorState.value!);
    showErrorSnackbar(context);
  }
  return null;
}, [errorState.value]);''',
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

class CustomError extends Error {
  final String message;
  CustomError(this.message);

  @override
  String toString() => message;
}
