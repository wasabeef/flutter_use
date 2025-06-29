# `useGeolocation`

Tracks the state of user's geographic location and permission using [geolocator](https://pub.dev/packages/geolocator).

## Installation

Depends on [geolocator](https://pub.dev/packages/geolocator).

```yaml
dependencies:
  flutter_use_geolocation: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-geolocation)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // You need call `Geolocator.checkPermission() and Geolocator.requestPermission()` yourself.
    final geolocation = useGeolocation();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("-- Geolocation --"),
            Text("permission checked: ${geolocation.fetched}"),
            Text("location: ${geolocation.position}"),
            ElevatedButton(
              onPressed: () async {
                await Geolocator.requestPermission();
              },
              child: const Text('Grant Location permission'),
            ),
          ],
        ),
      ),
    );
  }
}
```
## Reference

**`GeolocationState`**
- **`fetched`**_`: bool`_ - whether geographic location state is fetched;
- **`position`**_`: Position`_ - geographic detailed location state changes.
  - **`longitude`**_`: double`_ - The longitude of the position in degrees normalized to the interval -180 (exclusive) to +180 (inclusive).
  - **`latitude`**_`: double`_ - The latitude of this position in degrees normalized to the interval -90.0 to +90.0 (both inclusive).
  - **`timestamp`**_`: DateTime?`_ - The time at which this position was determined.
  - **`accuracy`**_`: double`_ - The estimated horizontal accuracy of the position in meters. The accuracy is not available on all devices. In these cases the value is 0.0.
  - **`altitude`**_`: double`_ - The altitude of the device in meters. The altitude is not available on all devices. In these cases the returned value is 0.0.
  - **`heading`**_`: double`_ - The heading in which the device is traveling in degrees. The heading is not available on all devices. In these cases the value is 0.0.
  - **`speed`**_`: double`_ - The speed at which the devices is traveling in meters per second over ground. The speed is not available on all devices. In these cases the value is 0.0.
  - **`speedAccuracy`**_`: double`_ - The estimated speed accuracy of this position, in meters per second. The speedAccuracy is not available on all devices. In these cases the value is 0.0.
  - **`floor`**_`: int?`_ - The floor specifies the floor of the building on which the device is located. The floor property is only available on iOS and only when the information is available. In all other cases this value will be null.
