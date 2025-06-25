import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseDebounceFnDemo extends HookWidget {
  const UseDebounceFnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo 1: Search with debounce
    final searchController = useTextEditingController();
    final searchResults = useState<List<String>>([]);
    final isSearching = useState(false);
    final searchCallCount = useState(0);

    final search = useDebounceFn(() async {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        searchResults.value = [];
        return;
      }

      isSearching.value = true;
      searchCallCount.value++;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      searchResults.value = List.generate(5, (i) => '$query - Result ${i + 1}');
      isSearching.value = false;
    }, 500);

    // Demo 2: Auto-save with debounce
    final noteController = useTextEditingController();
    final saveStatus = useState<String>('');
    final saveCount = useState(0);

    final autoSave = useDebounceFn1<String>((content) async {
      saveStatus.value = 'Saving...';
      saveCount.value++;

      // Simulate save operation
      await Future.delayed(const Duration(seconds: 1));

      saveStatus.value =
          'Saved at ${DateTime.now().toString().substring(11, 19)}';
    }, 1000);

    // Demo 3: Resize handler
    final sliderValue = useState(50.0);
    final resizeCount = useState(0);
    final lastResizeValue = useState(50.0);

    final handleResize = useDebounceFn(() {
      resizeCount.value++;
      lastResizeValue.value = sliderValue.value;
    }, 300);

    return Scaffold(
      appBar: AppBar(
        title: const Text('useDebounceFn Demo'),
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
              '⏱️ useDebounceFn Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Debounce function calls for better performance',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Demo 1: Search
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔍 Debounced Search',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: searchController,
                      onChanged: (_) => search.call(),
                      decoration: InputDecoration(
                        hintText: 'Type to search...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (search.isPending() || isSearching.value)
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            if (searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  search.cancel();
                                  searchResults.value = [];
                                },
                              ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 16),
                          const SizedBox(width: 8),
                          Text('API calls made: ${searchCallCount.value}'),
                          const Spacer(),
                          if (search.isPending())
                            const Text(
                              'Pending...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (searchResults.value.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ...searchResults.value.map(
                        (result) => ListTile(
                          leading: const Icon(Icons.article),
                          title: Text(result),
                          dense: true,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Demo 2: Auto-save
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
                          '💾 Auto-save Note',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (saveStatus.value.isNotEmpty)
                          Chip(
                            label: Text(saveStatus.value),
                            backgroundColor: saveStatus.value == 'Saving...'
                                ? Colors.orange.withValues(alpha: 0.2)
                                : Colors.green.withValues(alpha: 0.2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: noteController,
                      maxLines: 5,
                      onChanged: (text) {
                        autoSave.call(text);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Start typing... (auto-saves after 1 second)',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          'Total saves: ${saveCount.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: autoSave.isPending()
                              ? autoSave.flush
                              : null,
                          icon: const Icon(Icons.save, size: 16),
                          label: const Text('Save Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Demo 3: Resize handler
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📐 Debounced Resize Handler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('Size: ${sliderValue.value.round()}'),
                    Slider(
                      value: sliderValue.value,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: sliderValue.value.round().toString(),
                      onChanged: (value) {
                        sliderValue.value = value;
                        handleResize.call();
                      },
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Resize events: ${resizeCount.value}'),
                          Text(
                            'Last processed value: ${lastResizeValue.value.round()}',
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Move the slider quickly to see debouncing in action!',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
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
                      '• Delays function execution until user stops calling\n'
                      '• Reduces API calls and improves performance\n'
                      '• Cancellable and flushable\n'
                      '• Perfect for search, auto-save, and resize events\n'
                      '• Type-safe variants available',
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
        title: const Text('useDebounceFn Code Example'),
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
final search = useDebounceFn(() async {
  final results = await searchAPI(query);
  setState(() => searchResults = results);
}, 500); // 500ms delay

TextField(
  onChanged: (_) => search.call(),
)

// Type-safe single argument
final autoSave = useDebounceFn1<String>(
  (content) async {
    await saveDocument(content);
    showSnackBar('Saved!');
  },
  1000, // 1 second delay
);

// Control methods
search.cancel();     // Cancel pending execution
search.flush();      // Execute immediately
search.isPending();  // Check if pending

// Use in resize handlers
final handleResize = useDebounceFn(() {
  recalculateLayout();
}, 200);

// API rate limiting
final suggest = useDebounceFn(() {
  fetchSuggestions(searchTerm);
}, 300);''',
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
