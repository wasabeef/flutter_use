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
  final state = useRef(GeolocationState(
    fetched: false,
    position: initialPosition,
  ));
  final positionChanged =
      useStream(useMemoized(() => Geolocator.getPositionStream()));

  state.value = GeolocationState(
    fetched: positionChanged.hasData,
    position: positionChanged.data ?? initialPosition,
  );

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
}
