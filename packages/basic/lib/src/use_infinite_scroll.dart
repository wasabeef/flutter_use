import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// State container and controller for infinite scroll functionality.
///
/// This class encapsulates all the state and behavior needed for implementing
/// infinite scrolling lists. It provides loading state, error handling, and
/// the methods needed to control the scrolling behavior and data loading.
///
/// The state automatically manages the scroll detection and loading triggers
/// based on the configured threshold, while providing external control through
/// the loadMore and reset methods when manual intervention is needed.
class InfiniteScrollState {
  /// Creates an [InfiniteScrollState] with the specified state and control functions.
  ///
  /// [loading] indicates whether more data is currently being loaded.
  /// [hasMore] indicates whether there is more data available to load.
  /// [error] contains any error that occurred during the last load attempt.
  /// [scrollController] is the controller attached to the scrollable widget.
  /// [loadMore] is the function to manually trigger loading more data.
  /// [reset] is the function to reset the infinite scroll state.
  const InfiniteScrollState({
    required this.loading,
    required this.hasMore,
    required this.error,
    required this.scrollController,
    required this.loadMore,
    required this.reset,
  });

  /// Whether more data is currently being loaded.
  ///
  /// This is true from the moment a load operation begins until it completes
  /// (either successfully or with an error). Use this to show loading indicators
  /// or disable additional load triggers.
  final bool loading;

  /// Whether there is more data available to load.
  ///
  /// This is determined by the return value of the load function. When false,
  /// no further automatic loading will occur, and load indicators should be hidden.
  final bool hasMore;

  /// Error that occurred during the last loading attempt, if any.
  ///
  /// This will be null if no error occurred or if the error has been cleared
  /// by a successful subsequent load or reset.
  final Object? error;

  /// The scroll controller attached to the scrollable widget.
  ///
  /// This controller is used to detect scroll position and trigger loading
  /// when the user scrolls near the end of the content. It can also be used
  /// for programmatic scrolling.
  final ScrollController scrollController;

  /// Manually triggers loading more data.
  ///
  /// This function can be called to load more data outside of the automatic
  /// scroll-based triggering. It respects the current loading state and
  /// hasMore flag to prevent redundant requests.
  final Future<void> Function() loadMore;

  /// Resets the infinite scroll state to its initial configuration.
  ///
  /// This clears any errors, resets the hasMore flag to true, and stops
  /// any loading state. It's useful for refresh scenarios or when starting
  /// a new search/filter.
  final void Function() reset;
}

/// Flutter hook that manages infinite scroll functionality with automatic loading detection.
///
/// This hook provides a complete infinite scrolling solution by automatically
/// detecting when the user has scrolled near the end of the content and triggering
/// a load function. It manages all the state needed for infinite scrolling including
/// loading status, error handling, and scroll position monitoring.
///
/// The hook automatically attaches a scroll listener to detect when the user
/// approaches the bottom of the scrollable content based on the specified threshold.
/// When triggered, it calls the load function and manages the loading state to
/// prevent duplicate requests.
///
/// [loadMore] is the function called to load additional data. It must return a
/// [Future<bool>] where true indicates more data is available and false indicates
/// no more data exists. This function should handle adding the new data to your
/// data source and return the appropriate boolean.
///
/// [threshold] is the distance in pixels from the bottom at which loading should
/// be triggered. Defaults to 200.0 pixels. A larger threshold loads data earlier,
/// while a smaller threshold loads data closer to the bottom.
///
/// [controller] is an optional [ScrollController] to use. If not provided, one
/// will be created automatically.
///
/// [initialLoad] determines whether to trigger an initial load when the hook
/// is first created. Defaults to true. Set to false if you want to manually
/// control the first load.
///
/// Returns an [InfiniteScrollState] object that provides:
/// - [loading]: indicates if data is currently being loaded
/// - [hasMore]: indicates if more data is available
/// - [error]: contains any error from the last load attempt
/// - [scrollController]: the controller to attach to your scrollable widget
/// - [loadMore]: method to manually trigger loading
/// - [reset]: method to reset the scroll state
///
/// The load function should return true if more data might be available and
/// false if no more data exists. This controls whether future scroll triggers
/// will attempt to load more data.
///
/// Example with basic infinite scroll:
/// ```dart
/// final items = useState<List<String>>([]);
/// final currentPage = useState(1);
///
/// final infiniteScroll = useInfiniteScroll(
///   loadMore: () async {
///     final newItems = await api.fetchItems(
///       page: currentPage.value,
///       limit: 20,
///     );
///
///     if (newItems.isNotEmpty) {
///       items.value = [...items.value, ...newItems];
///       currentPage.value++;
///     }
///
///     return newItems.length >= 20; // More data if full page
///   },
///   threshold: 200,
/// );
///
/// ListView.builder(
///   controller: infiniteScroll.scrollController,
///   itemCount: items.value.length + (infiniteScroll.loading ? 1 : 0),
///   itemBuilder: (context, index) {
///     if (index == items.value.length) {
///       return Padding(
///         padding: EdgeInsets.all(16),
///         child: Center(child: CircularProgressIndicator()),
///       );
///     }
///     return ListTile(title: Text(items.value[index]));
///   },
/// )
/// ```
///
/// Example with error handling:
/// ```dart
/// final infiniteScroll = useInfiniteScroll(
///   loadMore: () async {
///     try {
///       final newItems = await api.fetchItems(page: currentPage);
///       // Update your state...
///       return newItems.isNotEmpty;
///     } catch (e) {
///       // Error is automatically captured by the hook
///       rethrow;
///     }
///   },
/// );
///
/// // Display error if present
/// if (infiniteScroll.error != null) {
///   return Text('Error: ${infiniteScroll.error}');
/// }
/// ```
///
/// See also:
///  * [usePaginatedInfiniteScroll], for automatic pagination management
///  * [InfiniteScrollState], the returned state object
InfiniteScrollState useInfiniteScroll({
  required Future<bool> Function() loadMore,
  double threshold = 200.0,
  ScrollController? controller,
  bool initialLoad = true,
}) {
  final scrollController = controller ?? useScrollController();
  final loading = useState(false);
  final hasMore = useState(true);
  final error = useState<Object?>(null);
  final isInitialized = useRef(false);

  final handleLoadMore = useCallback(
    () async {
      if (loading.value || !hasMore.value) {
        return;
      }

      loading.value = true;
      error.value = null;

      try {
        final moreAvailable = await loadMore();
        hasMore.value = moreAvailable;
      } on Object catch (e) {
        error.value = e;
      } finally {
        loading.value = false;
      }
    },
    [],
  );

  final reset = useCallback(
    () {
      loading.value = false;
      hasMore.value = true;
      error.value = null;
      isInitialized.value = false;
    },
    [],
  );

  useEffect(
    () {
      void onScroll() {
        if (!scrollController.hasClients) {
          return;
        }

        final position = scrollController.position;
        final maxScroll = position.maxScrollExtent;
        final currentScroll = position.pixels;

        if (maxScroll - currentScroll <= threshold) {
          handleLoadMore();
        }
      }

      scrollController.addListener(onScroll);

      // Initial load if requested
      if (initialLoad && !isInitialized.value) {
        isInitialized.value = true;
        // Use post frame callback to ensure the scroll controller is attached
        WidgetsBinding.instance.addPostFrameCallback((_) {
          handleLoadMore();
        });
      }

      return () => scrollController.removeListener(onScroll);
    },
    [scrollController, threshold, handleLoadMore, initialLoad],
  );

  return InfiniteScrollState(
    loading: loading.value,
    hasMore: hasMore.value,
    error: error.value,
    scrollController: scrollController,
    loadMore: handleLoadMore,
    reset: reset,
  );
}

/// Configuration settings for paginated infinite scroll behavior.
///
/// This class defines the pagination parameters used by [usePaginatedInfiniteScroll]
/// to control how data is loaded in pages. It standardizes the page size and
/// starting page number for consistent pagination behavior.
class PaginationConfig {
  /// Creates a [PaginationConfig] with the specified pagination settings.
  ///
  /// [pageSize] determines how many items to request per page. Defaults to 20.
  /// [initialPage] is the page number to start from. Defaults to 1.
  const PaginationConfig({
    this.pageSize = 20,
    this.initialPage = 1,
  });

  /// Number of items to request per page.
  ///
  /// This value is used to determine the batch size for data loading and
  /// to calculate whether more data might be available based on the number
  /// of items returned by each fetch operation.
  final int pageSize;

  /// The page number to start loading from.
  ///
  /// This is typically 1 for 1-based pagination or 0 for 0-based pagination,
  /// depending on your API's pagination scheme.
  final int initialPage;
}

/// Extended state container for paginated infinite scroll with automatic item management.
///
/// This class extends [InfiniteScrollState] to provide additional functionality
/// for pagination-based infinite scrolling. It automatically manages the list
/// of loaded items and current page number, making it easier to implement
/// paginated APIs without manual state management.
///
/// The state handles the complexity of merging new pages of data with existing
/// items and provides convenient access to the complete dataset and pagination
/// information.
class PaginatedInfiniteScrollState<T> extends InfiniteScrollState {
  /// Creates a [PaginatedInfiniteScrollState] with pagination-specific state.
  ///
  /// [items] is the current list of all loaded items across all pages.
  /// [currentPage] is the next page number to be loaded.
  /// [refresh] is the function to refresh the entire list from the beginning.
  /// All other parameters are inherited from [InfiniteScrollState].
  const PaginatedInfiniteScrollState({
    required super.loading,
    required super.hasMore,
    required super.error,
    required super.scrollController,
    required super.loadMore,
    required super.reset,
    required this.items,
    required this.currentPage,
    required this.refresh,
  });

  /// The complete list of loaded items from all pages.
  ///
  /// This list is automatically maintained as new pages are loaded and
  /// provides a flattened view of all the data that has been fetched.
  /// Items are added to this list in the order they are received.
  final List<T> items;

  /// The next page number that will be loaded.
  ///
  /// This is automatically incremented after each successful page load
  /// and is reset when the scroll state is reset or refreshed.
  final int currentPage;

  /// Refreshes the entire list by clearing all items and reloading from the first page.
  ///
  /// This is useful for implementing pull-to-refresh functionality or when
  /// the underlying data has changed and you need to start over from the beginning.
  /// It clears the current items, resets the page number, and triggers a fresh load.
  final Future<void> Function() refresh;
}

/// Flutter hook that provides advanced paginated infinite scroll with automatic item and page management.
///
/// This hook builds upon [useInfiniteScroll] to handle the common pattern of
/// paginated APIs. It automatically manages the list of items, current page
/// number, and pagination logic, eliminating the need for manual state management
/// of these common infinite scroll concerns.
///
/// Unlike [useInfiniteScroll], this hook manages the items list internally and
/// provides it through the returned state. It handles merging new pages of data
/// with existing items and automatically increments the page number after each
/// successful load.
///
/// [fetchPage] is the function called to load a specific page of data. It receives
/// the page number as a parameter and should return a [Future<List<T>>] containing
/// the items for that page. The hook automatically handles page incrementing and
/// determines if more data is available based on the returned list size.
///
/// [config] specifies the pagination configuration including page size and initial
/// page number. Defaults to [PaginationConfig] with 20 items per page starting from page 1.
///
/// [threshold] is the distance in pixels from the bottom at which loading should
/// be triggered. Defaults to 200.0 pixels.
///
/// [controller] is an optional [ScrollController] to use. If not provided, one
/// will be created automatically.
///
/// [initialLoad] determines whether to trigger an initial load when the hook
/// is first created. Defaults to true.
///
/// Returns a [PaginatedInfiniteScrollState<T>] object that provides:
/// - [items]: the complete list of loaded items from all pages
/// - [currentPage]: the next page number to be loaded
/// - [refresh]: method to clear all items and reload from the first page
/// - All properties from [InfiniteScrollState]: loading, hasMore, error, etc.
///
/// The hook determines if more data is available by comparing the number of
/// returned items to the configured page size. If a page returns fewer items
/// than the page size, it assumes no more data is available.
///
/// Example with typed data:
/// ```dart
/// final postScroll = usePaginatedInfiniteScroll<Post>(
///   fetchPage: (page) async {
///     final response = await api.getPosts(
///       page: page,
///       limit: 20,
///     );
///     return response.posts;
///   },
///   config: PaginationConfig(pageSize: 20, initialPage: 1),
/// );
///
/// RefreshIndicator(
///   onRefresh: postScroll.refresh,
///   child: ListView.builder(
///     controller: postScroll.scrollController,
///     itemCount: postScroll.items.length + (postScroll.loading ? 1 : 0),
///     itemBuilder: (context, index) {
///       if (index == postScroll.items.length) {
///         return Padding(
///           padding: EdgeInsets.all(16),
///           child: Center(child: CircularProgressIndicator()),
///         );
///       }
///       return PostCard(post: postScroll.items[index]);
///     },
///   ),
/// )
/// ```
///
/// Example with error handling:
/// ```dart
/// final dataScroll = usePaginatedInfiniteScroll<Data>(
///   fetchPage: (page) async {
///     try {
///       return await api.fetchData(page);
///     } catch (e) {
///       // Log error or handle it
///       print('Failed to load page $page: $e');
///       rethrow; // Re-throw to let the hook handle the error state
///     }
///   },
/// );
///
/// if (dataScroll.error != null) {
///   return Column(
///     children: [
///       Text('Error loading data: ${dataScroll.error}'),
///       ElevatedButton(
///         onPressed: dataScroll.loadMore,
///         child: Text('Retry'),
///       ),
///     ],
///   );
/// }
/// ```
///
/// Example with custom pagination:
/// ```dart
/// final customScroll = usePaginatedInfiniteScroll<Item>(
///   fetchPage: (page) async {
///     // 0-based pagination starting from page 0
///     return await api.getItems(offset: page * 10, limit: 10);
///   },
///   config: PaginationConfig(pageSize: 10, initialPage: 0),
///   threshold: 100, // Load earlier
/// );
/// ```
///
/// See also:
///  * [useInfiniteScroll], for basic infinite scroll without automatic item management
///  * [PaginatedInfiniteScrollState], the returned state object
///  * [PaginationConfig], for configuring pagination behavior
PaginatedInfiniteScrollState<T> usePaginatedInfiniteScroll<T>({
  required Future<List<T>> Function(int page) fetchPage,
  PaginationConfig config = const PaginationConfig(),
  double threshold = 200.0,
  ScrollController? controller,
  bool initialLoad = true,
}) {
  final items = useState<List<T>>([]);
  final currentPage = useState(config.initialPage);

  final loadMore = useCallback(
    () async {
      final newItems = await fetchPage(currentPage.value);
      if (newItems.isNotEmpty) {
        items.value = [...items.value, ...newItems];
        currentPage.value++;
      }
      return newItems.length >= config.pageSize;
    },
    [currentPage.value],
  );

  final baseState = useInfiniteScroll(
    loadMore: loadMore,
    threshold: threshold,
    controller: controller,
    initialLoad: initialLoad,
  );

  final refresh = useCallback(
    () async {
      items.value = [];
      currentPage.value = config.initialPage;
      baseState.reset();
      await baseState.loadMore();
    },
    [],
  );

  return PaginatedInfiniteScrollState<T>(
    loading: baseState.loading,
    hasMore: baseState.hasMore,
    error: baseState.error,
    scrollController: baseState.scrollController,
    loadMore: baseState.loadMore,
    reset: () {
      items.value = [];
      currentPage.value = config.initialPage;
      baseState.reset();
    },
    items: items.value,
    currentPage: currentPage.value,
    refresh: refresh,
  );
}
