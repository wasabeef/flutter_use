import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseListDemo extends HookWidget {
  const UseListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final todoList = useList<String>([
      'Buy groceries',
      'Read a book',
      'Exercise',
    ]);
    final newItemController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('useList Demo'),
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
              '📝 useList Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Advanced list state management with utility methods',
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
                      '✅ Todo List Example',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add new item
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: newItemController,
                            decoration: const InputDecoration(
                              labelText: 'New Todo',
                              hintText: 'Enter a new task...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                todoList.add(value);
                                newItemController.clear();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filled(
                          onPressed: () {
                            if (newItemController.text.isNotEmpty) {
                              todoList.add(newItemController.text);
                              newItemController.clear();
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // List display
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: todoList.list.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: Text(
                                  'No items yet. Add some!',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          : ReorderableListView.builder(
                              shrinkWrap: true,
                              itemCount: todoList.list.length,
                              itemBuilder: (context, index) {
                                final item = todoList.list[index];
                                return ListTile(
                                  key: ValueKey('$item$index'),
                                  leading: CircleAvatar(
                                    child: Text('${index + 1}'),
                                  ),
                                  title: Text(item),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () =>
                                            _editItem(context, todoList, index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            todoList.removeAt(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                if (newIndex > oldIndex) newIndex--;
                                final item = todoList.list[oldIndex];
                                todoList.removeAt(oldIndex);
                                todoList.insert(newIndex, item);
                              },
                            ),
                    ),

                    const SizedBox(height: 20),

                    // List actions
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: todoList.list.isEmpty
                              ? null
                              : todoList.clear,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear All'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => todoList.reset(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                        OutlinedButton.icon(
                          onPressed: todoList.list.isEmpty
                              ? null
                              : () {
                                  final reversed = todoList.list.reversed
                                      .toList();
                                  todoList.clear();
                                  todoList.addAll(reversed);
                                },
                          icon: const Icon(Icons.swap_vert),
                          label: const Text('Reverse'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // List info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Items'),
                              Text(
                                '${todoList.list.length}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[400],
                          ),
                          Column(
                            children: [
                              const Text('Total Chars'),
                              Text(
                                '${todoList.list.join().length}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                      '• Enhanced list with push, pop, insert, removeAt\n'
                      '• set() to replace entire list\n'
                      '• clear() to empty the list\n'
                      '• Automatically triggers rebuilds on changes\n'
                      '• Perfect for dynamic lists and collections',
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

  void _editItem(BuildContext context, ListAction<String> list, int index) {
    final controller = TextEditingController(text: list.list[index]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Item text'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text;
              list.removeAt(index);
              list.insert(index, value);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('useList Code Example'),
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
                '''// Initialize list
final items = useList<String>(['A', 'B', 'C']);

// Access list
print(items.list); // ['A', 'B', 'C']

// Add items
items.add('D'); // Add to end
items.insert(0, 'Z'); // Add at index

// Remove items
items.removeLast(); // Remove last
items.removeAt(1); // Remove at index

// Update items
items.removeAt(0);
items.insert(0, 'New Value');

// Bulk operations
items.clear(); // Remove all
items.addAll(['X', 'Y', 'Z']); // Add multiple

// Use in ListView
ListView.builder(
  itemCount: items.list.length,
  itemBuilder: (context, index) {
    return Text(items.list[index]);
  },
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
