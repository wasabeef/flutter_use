import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';

/// Tracks the state of user's geographic location using [geolocator](ref link).
/// [ref link](https://pub.dev/packages/geolocator)
GeolocationState useGeolocation({
  LocationSettings? locationSettings,
}) {
  final state = useRef(const GeolocationState());
  final positionChanged = useStream(
    useMemoized(
      () => Geolocator.getPositionStream(locationSettings: locationSettings),
    ),
  );

  state.value = GeolocationState(
    fetched: positionChanged.hasData,
    position: positionChanged.data,
  );

  return state.value;
}

/// State object containing current geolocation information.
///
/// This immutable class holds the user's current geographic position
/// as determined by the device's location services.
@immutable
class GeolocationState {
  /// Creates a [GeolocationState] with the provided location information.
  const GeolocationState({
    this.fetched = false,
    this.position,
  });

  /// Whether location data has been successfully fetched from location services.
  final bool fetched;

  /// The current geographic position, or null if not yet determined.
  final Position? position;
}
