import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks the state of network connection using [connectivity_plus](ref link).
/// [ref link](https://pub.dev/packages/connectivity_plus)
NetworkState useNetworkState() {
  final state = useRef(const NetworkState(fetched: false));
  final connectivityChanged =
      useStream(useMemoized(() => Connectivity().onConnectivityChanged));

  state.value = NetworkState(
    fetched: connectivityChanged.hasData,
    connectivity: connectivityChanged.data,
  );

  return state.value;
}

/// State object containing current network connectivity information.
///
/// This immutable class holds the current network connectivity state
/// as reported by the device's network interfaces.
@immutable
class NetworkState {
  /// Creates a [NetworkState] with the provided connectivity information.
  const NetworkState({
    required this.fetched,
    ConnectivityResult? connectivity,
  }) : _connectivity = connectivity ?? ConnectivityResult.none;

  /// Whether network connectivity data has been successfully fetched.
  final bool fetched;

  final ConnectivityResult _connectivity;

  /// The current network connectivity state (wifi, mobile, ethernet, none, etc.).
  ConnectivityResult get connectivity => _connectivity;
}
