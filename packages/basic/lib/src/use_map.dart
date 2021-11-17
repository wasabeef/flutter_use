import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Flutter state hook that tracks a value of an object.
MapAction<K, V> useMap<K, V>(Map<K, V> initialMap) {
  final map = useState(initialMap);

  final mapCallback = useCallback<Map<K, V> Function()>(() {
    return map.value;
  }, const []);

  final add = useCallback<void Function(K key, V entry)>((key, entry) {
    map.value = {
      ...map.value,
      ...{key: entry}
    };
  }, const []);

  final addAll = useCallback<void Function(Map<K, V>)>((value) {
    map.value = {...map.value, ...value};
  }, const []);

  final replace = useCallback<void Function(Map<K, V>)>((newMap) {
    map.value = newMap;
  }, const []);

  final remove = useCallback<void Function(K key)>((key) {
    final removedMap = {...map.value};
    removedMap.remove(key);
    map.value = removedMap;
  }, const []);

  final reset = useCallback<VoidCallback>(() {
    map.value = initialMap;
  }, const []);

  final state =
      useRef(MapAction<K, V>(mapCallback, add, addAll, replace, remove, reset));
  return state.value;
}

class MapAction<K, V> {
  const MapAction(
    this._map,
    this.add,
    this.addAll,
    this.replace,
    this.remove,
    this.reset,
  );

  final void Function(K key, V entry) add;
  final void Function(Map<K, V>) addAll;
  final void Function(Map<K, V>) replace;
  final void Function(K key) remove;
  final VoidCallback reset;
  final Map<K, V> Function() _map;
  V? get(K key) => map[key];

  Map<K, V> get map => _map();
}
