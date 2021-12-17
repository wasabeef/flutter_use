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
  final positionChanged = useStream(useMemoized(
      () => Geolocator.getPositionStream(locationSettings: locationSettings)));

  state.value = GeolocationState(
    fetched: positionChanged.hasData,
    position: positionChanged.data,
  );

  return state.value;
}

@immutable
class GeolocationState {
  const GeolocationState({
    this.fetched = false,
    this.position,
  });

  final bool fetched;
  final Position? position;
}
