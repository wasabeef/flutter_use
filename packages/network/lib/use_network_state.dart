import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks the state of network connection using [connectivity_plus](ref link).
/// [ref link](https://pub.dev/packages/connectivity_plus)
ValueNotifier<NetworkState> useNetworkState() {
  final state = useState(const NetworkState(fetched: false));
  final connectivity = useMemoized(() => Connectivity());
  final connectivityChanged = useStream(connectivity.onConnectivityChanged);

  final newState = NetworkState(
      fetched: connectivityChanged.hasData,
      connectivity: connectivityChanged.data);

  if (state.value != newState) {
    state.value = newState;
  }

  return state;
}

@immutable
class NetworkState {
  const NetworkState({
    required this.fetched,
    ConnectivityResult? connectivity,
  }) : _connectivity = connectivity ?? ConnectivityResult.none;

  final bool fetched;

  final ConnectivityResult _connectivity;
  ConnectivityResult get connectivity => _connectivity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkState &&
          runtimeType == other.runtimeType &&
          fetched == other.fetched &&
          _connectivity == other._connectivity;

  @override
  int get hashCode => fetched.hashCode ^ _connectivity.hashCode;
}
