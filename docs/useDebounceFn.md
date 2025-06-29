# useDebounceFn

A hook that debounces function calls, delaying execution until after a specified delay has elapsed since the last invocation.

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-debounce-fn)

```dart
import 'package:flutter_use/flutter_use.dart';

class SearchBar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final search = useDebounceFn(
      () async {
        final query = searchController.text;
        if (query.isNotEmpty) {
          final results = await searchAPI(query);
          setState(() => searchResults = results);
        }
      },
      500, // 500ms delay
    );
    
    return TextField(
      controller: searchController,
      onChanged: (_) => search.call(),
      decoration: InputDecoration(
        hintText: 'Search...',
        suffixIcon: search.isPending() 
            ? const CircularProgressIndicator() 
            : const Icon(Icons.search),
      ),
    );
  }
}
```

## Type-Safe Version

For better type safety with single arguments:

```dart
class AutoSaveEditor extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final autoSave = useDebounceFn1<String>(
      (content) async {
        await saveDocument(content);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved')),
        );
      },
      1000, // Auto-save after 1 second of inactivity
    );
    
    return TextField(
      maxLines: null,
      onChanged: autoSave.call,
      decoration: const InputDecoration(
        hintText: 'Start typing... (auto-saves)',
      ),
    );
  }
}
```

## API

### useDebounceFn

```dart
DebouncedFunction<T> useDebounceFn<T>(
  T Function() fn,
  int delay, {
  List<Object?> keys = const [],
})
```

**Parameters:**
- `fn`: The function to debounce
- `delay`: Delay in milliseconds
- `keys`: Dependencies that reset the debounce timer

**Returns:** `DebouncedFunction<T>` with:
- `call([...args])`: Call the debounced function
- `cancel()`: Cancel pending execution
- `flush()`: Execute immediately if pending
- `isPending()`: Check if execution is pending

### useDebounceFn1

```dart
DebouncedFunction1<T> useDebounceFn1<T>(
  void Function(T) fn,
  int delay, {
  List<Object?> keys = const [],
})
```

**Parameters:**
- `fn`: Single-argument function to debounce
- `delay`: Delay in milliseconds
- `keys`: Dependencies that reset the debounce timer

**Returns:** `DebouncedFunction1<T>` with type-safe single argument

## Features

- Delays function execution until user stops invoking
- Cancellable pending executions
- Flushable for immediate execution
- Pending state tracking
- Type-safe variants available
- Automatic cleanup on unmount

## Common Use Cases

1. **Search Input**
   ```dart
   final search = useDebounceFn(() => performSearch(query), 300);
   ```

2. **Auto-save Forms**
   ```dart
   final save = useDebounceFn(() => saveFormData(), 1000);
   ```

3. **API Rate Limiting**
   ```dart
   final apiCall = useDebounceFn(() => fetchSuggestions(), 500);
   ```

4. **Resize Event Handling**
   ```dart
   final handleResize = useDebounceFn(() => recalculateLayout(), 200);
   ```

## Advanced Example

```dart
class SmartSearchField extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final results = useState<List<String>>([]);
    final isSearching = useState(false);
    
    final search = useDebounceFn(() async {
      final query = controller.text.trim();
      if (query.isEmpty) {
        results.value = [];
        return;
      }
      
      isSearching.value = true;
      try {
        results.value = await searchAPI(query);
      } finally {
        isSearching.value = false;
      }
    }, 300);
    
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: (_) => search.call(),
          decoration: InputDecoration(
            hintText: 'Type to search...',
            suffix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (search.isPending() || isSearching.value)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                if (controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      search.cancel();
                      results.value = [];
                    },
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.value.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(results.value[index]),
            ),
          ),
        ),
      ],
    );
  }
}
```