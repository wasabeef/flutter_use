import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';

/// Tracks the state of user's geographic location using [geolocator](ref link).
/// [ref link](https://pub.dev/packages/geolocator)
GeolocationState useGeolocation({
  Position initialPosition = const Position(
    longitude: 0,
    latitude: 0,
    timestamp: null,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  ),
}) {
  final state = useState(GeolocationState(
    fetched: false,
    position: initialPosition,
  ));
  final positionChanged = useStream(Geolocator.getPositionStream());

  final newState = GeolocationState(
    fetched: positionChanged.hasData,
    position: positionChanged.data ?? initialPosition,
  );

  if (state.value != newState) {
    state.value = newState;
  }

  return state.value;
}

@immutable
class GeolocationState {
  const GeolocationState({
    required this.fetched,
    required this.position,
  });

  final bool fetched;
  final Position position;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationState &&
          runtimeType == other.runtimeType &&
          fetched == other.fetched &&
          position == other.position;

  @override
  int get hashCode => fetched.hashCode ^ position.hashCode;
}

@immutable
class GeolocationPermissionState {
  const GeolocationPermissionState({
    required this.checked,
    this.serviceEnabled,
    this.permission,
  });

  final bool checked;
  final bool? serviceEnabled;
  final LocationPermission? permission;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationPermissionState &&
          runtimeType == other.runtimeType &&
          checked == other.checked &&
          serviceEnabled == other.serviceEnabled &&
          permission == other.permission;

  @override
  int get hashCode =>
      checked.hashCode ^ serviceEnabled.hashCode ^ permission.hashCode;
}
