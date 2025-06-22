import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that manages a Map with reactive updates.
///
/// Provides methods to modify a map. The component re-builds when the map
/// changes through these methods. Direct modification of the map does not
/// trigger re-builds.
///
/// [initialMap] is the starting map value.
///
/// Returns a [MapAction] object that provides access to the current map
/// and all modification methods.
///
/// Example:
/// ```dart
/// final mapActions = useMap<String, int>({'a': 1, 'b': 2});
///
/// // Access the current map
/// print(mapActions.map); // {'a': 1, 'b': 2}
///
/// // Add or update entries
/// mapActions.add('c', 3);
/// mapActions.addAll({'d': 4, 'e': 5});
///
/// // Remove entries
/// mapActions.remove('b');
///
/// // Replace the entire map
/// mapActions.replace({'x': 10, 'y': 20});
///
/// // Reset to initial value
/// mapActions.reset();
/// ```
MapAction<K, V> useMap<K, V>(Map<K, V> initialMap) {
  final map = useState(initialMap);

  final value = useCallback<Map<K, V> Function()>(
    () => map.value,
    const [],
  );

  final add = useCallback<void Function(K key, V entry)>(
    (key, entry) {
      map.value = {
        ...map.value,
        ...{key: entry},
      };
    },
    const [],
  );

  final addAll = useCallback<void Function(Map<K, V>)>(
    (value) {
      map.value = {...map.value, ...value};
    },
    const [],
  );

  final replace = useCallback<void Function(Map<K, V>)>(
    (newMap) {
      map.value = newMap;
    },
    const [],
  );

  final remove = useCallback<void Function(K key)>(
    (key) {
      final removedMap = {...map.value};
      removedMap.remove(key);
      map.value = removedMap;
    },
    const [],
  );

  final reset = useCallback<VoidCallback>(
    () {
      map.value = initialMap;
    },
    const [],
  );

  final state =
      useRef(MapAction<K, V>(value, add, addAll, replace, remove, reset));
  return state.value;
}

/// Provides reactive map manipulation methods.
///
/// This class contains all the methods needed to manipulate a map while
/// ensuring reactive updates that trigger widget rebuilds.
class MapAction<K, V> {
  /// Creates a [MapAction] with all the provided map manipulation functions.
  const MapAction(
    this._map,
    this.add,
    this.addAll,
    this.replace,
    this.remove,
    this.reset,
  );

  /// Adds or updates a single entry in the map.
  final void Function(K key, V entry) add;

  /// Adds all entries from another map to this map.
  final void Function(Map<K, V>) addAll;

  /// Replaces the entire map with a new map.
  final void Function(Map<K, V>) replace;

  /// Removes an entry with the specified key from the map.
  final void Function(K key) remove;

  /// Resets the map to its initial value.
  final VoidCallback reset;

  final Map<K, V> Function() _map;

  /// Gets the value associated with the given key, or null if not found.
  V? get(K key) => map[key];

  /// The current map value.
  Map<K, V> get map => _map();
}
