import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseAsyncFnDemo extends HookWidget {
  const UseAsyncFnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo 1: Login form simulation
    final loginAction = useAsyncFn(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (DateTime.now().second % 2 == 0) {
        return 'Login successful! Welcome back.';
      } else {
        throw Exception('Invalid credentials. Please try again.');
      }
    });

    // Demo 2: Data submission
    final submitAction = useAsyncFn(() async {
      await Future.delayed(const Duration(milliseconds: 1500));
      return 'Form submitted successfully!';
    });

    // Demo 3: File upload simulation
    final uploadAction = useAsyncFn(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (DateTime.now().millisecond % 3 == 0) {
        throw Exception('Upload failed: Network error');
      }
      return 'File uploaded successfully! (${DateTime.now().millisecondsSinceEpoch})';
    });

    // Demo 4: API call with different outcomes
    final apiAction = useAsyncFn(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      final outcomes = [
        'Data fetched successfully!',
        () => throw Exception('Server error: 500'),
        () => throw Exception('Network timeout'),
        'Updated 25 records',
      ];
      final outcome = outcomes[DateTime.now().second % outcomes.length];
      if (outcome is Function) {
        outcome();
      }
      return outcome as String;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('useAsyncFn Demo'),
        actions: [
          TextButton(
            onPressed: () => _showCodeDialog(context),
            child: const Text('Code'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'useAsyncFn provides manual control over async operations. '
              'Perfect for form submissions, button clicks, and user-triggered actions.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Demo 1: Login Form
            _buildDemoCard(
              title: '1. Login Form Simulation',
              description: 'Manual execution for authentication',
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: loginAction.loading
                        ? null
                        : () async {
                            try {
                              final result = await loginAction.execute();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString().replaceFirst(
                                        'Exception: ',
                                        '',
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    icon: loginAction.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: Text(
                      loginAction.loading ? 'Logging in...' : 'Login',
                    ),
                  ),
                  if (loginAction.hasError) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${loginAction.error.toString().replaceFirst('Exception: ', '')}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),

            // Demo 2: Form Submission
            _buildDemoCard(
              title: '2. Form Submission',
              description: 'Submit data with loading state',
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: submitAction.loading
                        ? null
                        : () async {
                            final result = await submitAction.execute();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            }
                          },
                    icon: submitAction.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      submitAction.loading ? 'Submitting...' : 'Submit Form',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (submitAction.hasData) ...[
                    const SizedBox(height: 8),
                    Text(
                      '✅ ${submitAction.data}',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),

            // Demo 3: File Upload
            _buildDemoCard(
              title: '3. File Upload Simulation',
              description: 'Upload with error handling',
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: uploadAction.loading
                        ? null
                        : () async {
                            try {
                              final result = await uploadAction.execute();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString().replaceFirst(
                                        'Exception: ',
                                        '',
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    icon: uploadAction.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file),
                    label: Text(
                      uploadAction.loading ? 'Uploading...' : 'Upload File',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (uploadAction.loading)
                    const LinearProgressIndicator()
                  else if (uploadAction.hasData)
                    Text(
                      '✅ ${uploadAction.data}',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    )
                  else if (uploadAction.hasError)
                    Text(
                      '❌ ${uploadAction.error.toString().replaceFirst('Exception: ', '')}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
            ),

            // Demo 4: Multiple Actions
            _buildDemoCard(
              title: '4. Multiple Concurrent Actions',
              description: 'Independent async operations',
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: apiAction.loading
                          ? null
                          : () async {
                              try {
                                await apiAction.execute();
                              } catch (e) {
                                // Error is stored in state
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: apiAction.loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('API Call'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitAction.loading
                          ? null
                          : () async {
                              await submitAction.execute();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: submitAction.loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),

            // Status Display
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Action States:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow('Login', loginAction),
                    _buildStatusRow('Submit', submitAction),
                    _buildStatusRow('Upload', uploadAction),
                    _buildStatusRow('API', apiAction),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, AsyncAction action) {
    Color statusColor = Colors.grey;
    String statusText = 'Idle';

    if (action.loading) {
      statusColor = Colors.blue;
      statusText = 'Loading';
    } else if (action.hasError) {
      statusColor = Colors.red;
      statusText = 'Error';
    } else if (action.hasData) {
      statusColor = Colors.green;
      statusText = 'Success';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text('$label:', style: const TextStyle(fontSize: 12)),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(statusText, style: TextStyle(color: statusColor, fontSize: 12)),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'useAsyncFn Code Example',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('''// 1. Basic Form Submission
final submitAction = useAsyncFn(() async {
  await Future.delayed(const Duration(seconds: 1));
  return await api.submitForm(formData);
});

// 2. Manual Execution
ElevatedButton(
  onPressed: submitAction.loading ? null : () async {
    try {
      final result = await submitAction.execute();
      // Handle success
      showSuccessMessage(result);
    } catch (e) {
      // Handle error
      showErrorMessage(e.toString());
    }
  },
  child: submitAction.loading 
      ? CircularProgressIndicator()
      : Text('Submit'),
)

// 3. State Checking
if (submitAction.loading) {
  // Show loading indicator
} else if (submitAction.hasError) {
  // Show error message
} else if (submitAction.hasData) {
  // Show success state
}

// 4. Multiple Concurrent Actions
final action1 = useAsyncFn(() => api.call1());
final action2 = useAsyncFn(() => api.call2());

// Both can run independently
await Future.wait([
  action1.execute(),
  action2.execute(),
]);''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
