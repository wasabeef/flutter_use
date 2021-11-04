import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Tracks the state of browser's network connection using [connectivity_plus](ref link).
/// [ref link](https://pub.dev/packages/connectivity_plus)
ValueNotifier<NetworkState> useNetworkState() {
  final state = useState(const NetworkState(fetched: false));
  final connectivity = useMemoized(() => Connectivity());
  final connectivityChanged = useStream(connectivity.onConnectivityChanged);

  final newState = NetworkState(
      fetched: connectivityChanged.data != null,
      connectivityResult: connectivityChanged.data);

  if (state.value != newState) {
    state.value = newState;
  }

  return state;
}

@immutable
class NetworkState {
  const NetworkState({
    required this.fetched,
    ConnectivityResult? connectivityResult,
  }) : _connectivityResult = connectivityResult ?? ConnectivityResult.none;

  final bool fetched;

  final ConnectivityResult _connectivityResult;
  ConnectivityResult get connectivityResult => _connectivityResult;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkState &&
          runtimeType == other.runtimeType &&
          fetched == other.fetched &&
          _connectivityResult == other._connectivityResult;

  @override
  int get hashCode => fetched.hashCode ^ _connectivityResult.hashCode;
}
