## 1.0.0

**First Stable Release**

Device motion and orientation made accessible. Perfect for fitness apps, games,
and innovative user interactions that respond to device movement.

**Features**
- `useAccelerometer()` - Track device acceleration forces
- `useUserAccelerometer()` - User-generated acceleration without gravity
- `useGyroscope()` - Rotation rate detection for orientation changes
- `useMagnetometer()` - Magnetic field sensing for compass functionality
- High-frequency data updates with configurable sampling rates
- Smooth performance across different device capabilities

**Engineering Quality**
- Optimized for battery efficiency
- Handles sensor availability gracefully
- Precise calibration and filtering
- Real-world tested across device types

## 0.0.5

- Updated `flutter_hooks` to `^0.21.0`. See [PR #62](https://github.com/wasabeef/flutter_use/pull/62) for details.

## 0.0.4

**Development**
Update to require sdk >= 2.17.0 same as flutter_hooks 0.20.0
Update to flutter_hooks ^0.20.0

## 0.0.3

**Development**
Update to Flutter v3
Update to require sdk >= 2.14.0
Update to flutter_hooks ^0.18.5+1
Update to sensors_plus ^1.2.1

## 0.0.2

**Features**
Add `useAccelerometer()` hook.
Add `useUserAccelerometer()` hook.
Add `useGyroscope()` hook.
Add `useMagnetometer()` hook.
