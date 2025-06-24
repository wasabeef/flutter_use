import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class UseInfiniteScrollDemo extends HookWidget {
  const UseInfiniteScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo 1: Basic infinite scroll
    final items = useState<List<String>>([]);
    final pageCount = useState(0);

    final infiniteScroll = useInfiniteScroll(
      loadMore: () async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        if (pageCount.value < 5) {
          // Limit to 5 pages for demo
          final newItems = List.generate(
            10,
            (i) => 'Item ${pageCount.value * 10 + i + 1}',
          );
          items.value = [...items.value, ...newItems];
          pageCount.value++;
          return true; // Has more data
        }
        return false; // No more data
      },
      threshold: 200,
      initialLoad: true,
    );

    // Demo 2: Paginated infinite scroll with products
    final productScroll = usePaginatedInfiniteScroll<Map<String, dynamic>>(
      fetchPage: (page) async {
        await Future.delayed(const Duration(milliseconds: 800));

        // Simulate end of data after 3 pages
        if (page > 3) return [];

        return List.generate(
          8,
          (i) => {
            'id': (page - 1) * 8 + i + 1,
            'name': 'Product ${(page - 1) * 8 + i + 1}',
            'price': '\$${((page - 1) * 8 + i + 1) * 10}',
            'image': ['📱', '💻', '⌚', '🎧', '📷', '🖥️', '⌨️', '🖱️'][i % 8],
          },
        );
      },
      config: const PaginationConfig(pageSize: 8),
      threshold: 300,
      initialLoad: false,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('useInfiniteScroll Demo'),
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
              Tab(text: 'Basic List'),
              Tab(text: 'Product Grid'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Basic List
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Loaded ${items.value.length} items • '
                          'Page ${pageCount.value} • '
                          '${infiniteScroll.hasMore ? "Has more" : "All loaded"}',
                        ),
                      ),
                      if (infiniteScroll.error != null)
                        TextButton(
                          onPressed: infiniteScroll.loadMore,
                          child: const Text('Retry'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: infiniteScroll.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text('Error: ${infiniteScroll.error}'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: infiniteScroll.loadMore,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: infiniteScroll.scrollController,
                          itemCount:
                              items.value.length +
                              (infiniteScroll.loading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == items.value.length) {
                              return const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(items.value[index]),
                              subtitle: Text(
                                'Loaded from page ${(index ~/ 10) + 1}',
                              ),
                            );
                          },
                        ),
                ),
                if (!infiniteScroll.hasMore && items.value.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle),
                        SizedBox(width: 8),
                        Text('All items loaded!'),
                      ],
                    ),
                  ),
              ],
            ),

            // Tab 2: Product Grid
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      Text(
                        '${productScroll.items.length} products • '
                        'Page ${productScroll.currentPage - 1}',
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: productScroll.items.isEmpty
                            ? productScroll.loadMore
                            : productScroll.refresh,
                        icon: Icon(
                          productScroll.items.isEmpty
                              ? Icons.download
                              : Icons.refresh,
                        ),
                        label: Text(
                          productScroll.items.isEmpty
                              ? 'Load Products'
                              : 'Refresh',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: productScroll.items.isEmpty && !productScroll.loading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text('No products loaded'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: productScroll.loadMore,
                                child: const Text('Load Products'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: productScroll.refresh,
                          child: GridView.builder(
                            controller: productScroll.scrollController,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount:
                                productScroll.items.length +
                                (productScroll.loading ? 2 : 0),
                            itemBuilder: (context, index) {
                              if (index >= productScroll.items.length) {
                                return Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              }

                              final product = productScroll.items[index];
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Tapped ${product['name']}',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product['image'],
                                          style: const TextStyle(fontSize: 48),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          product['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          product['price'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                if (!productScroll.hasMore && productScroll.items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory),
                        SizedBox(width: 8),
                        Text('No more products'),
                      ],
                    ),
                  ),
              ],
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
        title: const Text('useInfiniteScroll Code Example'),
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
                '''// Basic infinite scroll
final items = useState<List<Item>>([]);

final scroll = useInfiniteScroll(
  loadMore: () async {
    final newItems = await api.loadMore();
    items.value = [...items.value, ...newItems];
    return newItems.isNotEmpty;
  },
  threshold: 200, // Pixels from bottom
);

ListView.builder(
  controller: scroll.scrollController,
  itemCount: items.value.length + 
            (scroll.loading ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == items.value.length) {
      return CircularProgressIndicator();
    }
    return ItemWidget(items.value[index]);
  },
)

// Paginated version
final scroll = usePaginatedInfiniteScroll<Product>(
  fetchPage: (page) => api.getProducts(page),
  config: PaginationConfig(pageSize: 20),
);

// Access loaded items directly
GridView.builder(
  controller: scroll.scrollController,
  itemCount: scroll.items.length,
  itemBuilder: (_, i) => ProductCard(scroll.items[i]),
)

// Pull to refresh
RefreshIndicator(
  onRefresh: scroll.refresh,
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
