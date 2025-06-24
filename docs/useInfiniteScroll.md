# useInfiniteScroll

A hook that manages infinite scrolling functionality with automatic loading when reaching a threshold.

## Usage

```dart
import 'package:flutter_use/flutter_use.dart';

class InfinitePostList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final posts = useState<List<Post>>([]);
    final currentPage = useState(1);
    
    final infiniteScroll = useInfiniteScroll(
      loadMore: () async {
        final newPosts = await api.getPosts(page: currentPage.value);
        posts.value = [...posts.value, ...newPosts];
        currentPage.value++;
        return newPosts.isNotEmpty; // Has more data
      },
      threshold: 200, // Load more when 200px from bottom
    );
    
    return ListView.builder(
      controller: infiniteScroll.scrollController,
      itemCount: posts.value.length + (infiniteScroll.loading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == posts.value.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return PostCard(post: posts.value[index]);
      },
    );
  }
}
```

## Paginated Version

For easier pagination management:

```dart
class PaginatedProductGrid extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scroll = usePaginatedInfiniteScroll<Product>(
      fetchPage: (page) => api.getProducts(page: page, limit: 20),
      config: const PaginationConfig(
        pageSize: 20,
        initialPage: 1,
      ),
      threshold: 300,
    );
    
    if (scroll.error != null) {
      return ErrorWidget(
        error: scroll.error!,
        onRetry: scroll.refresh,
      );
    }
    
    return RefreshIndicator(
      onRefresh: scroll.refresh,
      child: GridView.builder(
        controller: scroll.scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: scroll.items.length + (scroll.loading ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= scroll.items.length) {
            return const Card(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return ProductCard(product: scroll.items[index]);
        },
      ),
    );
  }
}
```

## API

### useInfiniteScroll

```dart
InfiniteScrollState useInfiniteScroll({
  required Future<bool> Function() loadMore,
  double threshold = 200.0,
  ScrollController? controller,
  bool initialLoad = true,
})
```

**Parameters:**
- `loadMore`: Function that loads more data, returns whether more data exists
- `threshold`: Distance from bottom to trigger loading (in pixels)
- `controller`: Optional custom ScrollController
- `initialLoad`: Whether to load data immediately

**Returns:** `InfiniteScrollState` with:
- `loading`: Whether data is being loaded
- `hasMore`: Whether more data is available
- `error`: Error if loading failed
- `scrollController`: The scroll controller
- `loadMore()`: Manually trigger loading
- `reset()`: Reset the infinite scroll state

### usePaginatedInfiniteScroll

```dart
PaginatedInfiniteScrollState<T> usePaginatedInfiniteScroll<T>({
  required Future<List<T>> Function(int page) fetchPage,
  PaginationConfig config = const PaginationConfig(),
  double threshold = 200.0,
  ScrollController? controller,
  bool initialLoad = true,
})
```

**Parameters:**
- `fetchPage`: Function to fetch a specific page
- `config`: Pagination configuration
- Other parameters same as `useInfiniteScroll`

**Returns:** `PaginatedInfiniteScrollState<T>` with:
- All properties from `InfiniteScrollState`
- `items`: List of all loaded items
- `currentPage`: Current page number
- `refresh()`: Refresh from first page

## Features

- Automatic scroll position monitoring
- Loading state management
- Error handling
- "Has more" state tracking
- Manual loading trigger
- Pull-to-refresh support
- Pagination helpers
- Custom scroll controller support

## Common Use Cases

1. **Social Media Feeds**
   ```dart
   final feed = useInfiniteScroll(
     loadMore: () => loadMorePosts(),
     threshold: 500, // Start loading earlier for smooth experience
   );
   ```

2. **Product Catalogs**
   ```dart
   final products = usePaginatedInfiniteScroll<Product>(
     fetchPage: (page) => api.getProducts(page, pageSize: 50),
   );
   ```

3. **Chat History**
   ```dart
   final messages = useInfiniteScroll(
     loadMore: () => loadOlderMessages(),
     initialLoad: false, // Load on demand
   );
   ```

4. **Search Results**
   ```dart
   final results = usePaginatedInfiniteScroll<SearchResult>(
     fetchPage: (page) => searchAPI(query, page),
     threshold: 100,
   );
   ```

## Advanced Example

```dart
class AdvancedInfiniteList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final filter = useState('all');
    
    final scroll = usePaginatedInfiniteScroll<Item>(
      fetchPage: (page) async {
        final response = await api.getItems(
          page: page,
          filter: filter.value,
          limit: 30,
        );
        return response.items;
      },
      config: const PaginationConfig(pageSize: 30),
      threshold: 400,
    );
    
    // Reset when filter changes
    useEffect(() {
      scroll.reset();
      scroll.loadMore();
      return null;
    }, [filter.value]);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => filter.value = value,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'active', child: Text('Active')),
              const PopupMenuItem(value: 'archived', child: Text('Archived')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: scroll.refresh,
        child: scroll.items.isEmpty && !scroll.loading
            ? const Center(child: Text('No items found'))
            : ListView.separated(
                controller: scroll.scrollController,
                itemCount: scroll.items.length + 
                          (scroll.loading ? 1 : 0) +
                          (!scroll.hasMore && scroll.items.isNotEmpty ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  if (index == scroll.items.length && scroll.loading) {
                    return const LoadingIndicator();
                  }
                  
                  if (index == scroll.items.length && !scroll.hasMore) {
                    return const EndOfListIndicator();
                  }
                  
                  return ItemTile(item: scroll.items[index]);
                },
              ),
      ),
    );
  }
}
```