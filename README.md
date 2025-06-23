<div align="center">
  <img src="https://github.com/wasabeef/flutter_use/raw/main/art/flutter_use_logo.png" width="480px" alt="flutter_use" />
  <div>
    <br />
    <a href="https://pub.dartlang.org/packages/flutter_use">
      <img src="https://img.shields.io/pub/v/flutter_use.svg">
    </a>
    <a href="https://pub.dev/packages/flutter_lints">
      <img src="https://img.shields.io/badge/style-flutter__lints-40c4ff.svg" alt="flutter_lints" />
    </a>
    <br />
    <sup style="font-size: 2px;">Inspired by <a href="https://github.com/streamich/react-use">react-use</a>.</sup>
    <br />
  </div>
  <br />
  <br />
</div>

A collection of Flutter Hooks inspired by React's `react-use` library. This monorepo contains multiple packages providing different categories of hooks for Flutter development.

## 📦 Packages

| Package                                                 | Description                                 | Version                                                                                                                          |
| ------------------------------------------------------- | ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **[`flutter_use`](./packages/basic)**                   | Core hooks library with essential utilities | [![pub package](https://img.shields.io/pub/v/flutter_use.svg)](https://pub.dev/packages/flutter_use)                             |
| **[`flutter_use_audio`](./packages/audio)**             | Audio playback and control hooks            | [![pub package](https://img.shields.io/pub/v/flutter_use_audio.svg)](https://pub.dev/packages/flutter_use_audio)                 |
| **[`flutter_use_battery`](./packages/battery)**         | Battery state monitoring hooks              | [![pub package](https://img.shields.io/pub/v/flutter_use_battery.svg)](https://pub.dev/packages/flutter_use_battery)             |
| **[`flutter_use_geolocation`](./packages/geolocation)** | Location and permission hooks               | [![pub package](https://img.shields.io/pub/v/flutter_use_geolocation.svg)](https://pub.dev/packages/flutter_use_geolocation)     |
| **[`flutter_use_network_state`](./packages/network)**   | Network connectivity hooks                  | [![pub package](https://img.shields.io/pub/v/flutter_use_network_state.svg)](https://pub.dev/packages/flutter_use_network_state) |
| **[`flutter_use_sensors`](./packages/sensors)**         | Device sensors hooks                        | [![pub package](https://img.shields.io/pub/v/flutter_use_sensors.svg)](https://pub.dev/packages/flutter_use_sensors)             |
| **[`flutter_use_video`](./packages/video)**             | Video playbook hooks                        | [![pub package](https://img.shields.io/pub/v/flutter_use_video.svg)](https://pub.dev/packages/flutter_use_video)                 |

## 🚀 Installation

For the core package:

```bash
flutter pub add flutter_use
```

For specialized packages:

```bash
flutter pub add flutter_use_audio    # Audio hooks
flutter pub add flutter_use_battery  # Battery hooks
# ... and so on
```

## 🌐 Interactive Demo Site

Try out all hooks with live examples at: **[https://wasabeef.github.io/flutter_use/](https://wasabeef.github.io/flutter_use/)**

## 📚 Hooks by Category

### 🎭 State Management

_Core package: `flutter_use`_

- [`useToggle` and `useBoolean`](./docs/useToggle.md) &mdash; tracks state of a boolean.
- [`useCounter` and `useNumber`](./docs/useCounter.md) &mdash; tracks state of a number.
- [`useList`](./docs/useList.md) &mdash; tracks state of an array.
- [`useMap`](./docs/useMap.md) &mdash; tracks state of a map.
- [`useSet`](./docs/useSet.md) &mdash; tracks state of a Set.
- [`useStateList`](./docs/useStateList.md) &mdash; circularly iterates over an array.
- [`useDefault`](./docs/useDefault.md) &mdash; returns the default value when state is `null`.
- [`useLatest`](./docs/useLatest.md) &mdash; returns the latest state or props.
- [`usePreviousDistinct`](./docs/usePreviousDistinct.md) &mdash; like [`usePrevious`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/usePrevious.html) but with a predicate to determine if `previous` should update.
- [`useTextFormValidator`](./docs/useTextFormValidator.md) &mdash; reactive form validation with real-time feedback.

### ⏱️ Timing & Animation

_Core package: `flutter_use`_

- [`useInterval`](./docs/useInterval.md) &mdash; re-builds component on a set interval using [`Timer.periodic`](https://api.dart.dev/stable/2.14.4/dart-async/Timer/Timer.periodic.html).
- [`useTimeout`](./docs/useTimeout.md) &mdash; re-builds component after a timeout.
- [`useTimeoutFn`](./docs/useTimeoutFn.md) &mdash; calls given function after a timeout.
- [`useUpdate`](./docs/useUpdate.md) &mdash; returns a callback, which re-builds component when called.

### 🔄 Side Effects & Performance

_Core package: `flutter_use`_

- [`useFutureRetry`](./docs/useFutureRetry.md) &mdash; [`useFuture`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useFuture.html) with an additional retry method.
- [`useDebounce`](./docs/useDebounce.md) &mdash; debounces a function.
- [`useThrottle`](./docs/useThrottle.md) &mdash; throttles a value to update at most once per duration.
- [`useThrottleFn`](./docs/useThrottleFn.md) &mdash; throttles a function to execute at most once per duration.
- [`useError`](./docs/useError.md) &mdash; error dispatcher.
- [`useException`](./docs/useException.md) &mdash; exception dispatcher.

### 🎯 UI Interactions

_Core package: `flutter_use`_

- [`useScroll`](./docs/useScroll.md) &mdash; tracks a widget's scroll position.
- [`useScrolling`](./docs/useScrolling.md) &mdash; tracks whether widget is scrolling.
- [`useClickAway`](./docs/useClickAway.md) &mdash; triggers callback when user clicks outside target area.
- [`useCopyToClipboard`](./docs/useCopyToClipboard.md) &mdash; copies text to clipboard.

### ♻️ Lifecycle Management

_Core package: `flutter_use`_

- [`useEffectOnce`](./docs/useEffectOnce.md) &mdash; a modified [`useEffect`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useEffect.html) hook that only runs once.
- [`useLifecycles`](./docs/useLifecycles.md) &mdash; calls `mount` and `unmount` callbacks.
- [`useMount`](./docs/useMount.md) &mdash; calls `mount` callbacks.
- [`useUnmount`](./docs/useUnmount.md) &mdash; calls `unmount` callbacks.
- [`useUpdateEffect`](./docs/useUpdateEffect.md) &mdash; run an `effect` only on updates.
- [`useCustomCompareEffect`](./docs/useCustomCompareEffect.md) &mdash; run an `effect` depending on deep comparison of its dependencies.
- [`useFirstMountState`](./docs/useFirstMountState.md) &mdash; check if current build is first.
- [`useBuildsCount`](./docs/useBuildsCount.md) &mdash; count component builds.

### 🎨 Development & Debugging

_Core package: `flutter_use`_

- [`useLogger`](./docs/useLogger.md) &mdash; logs in console as component goes through life-cycles.

### 📱 Device Sensors

_Package: `flutter_use_sensors`_

- [`useAccelerometer`](./docs/useAccelerometer.md), [`useUserAccelerometer`](./docs/useUserAccelerometer.md), [`useGyroscope`](./docs/useGyroscope.md), and [`useMagnetometer`](./docs/useMagnetometer.md) &mdash; tracks accelerometer, gyroscope, and magnetometer sensors. [![sensors_plus](https://img.shields.io/badge/required-sensors__plus-brightgreen)](https://pub.dev/packages/sensors_plus)

_Core package: `flutter_use`_

- [`useOrientation`](./docs/useOrientation.md) &mdash; tracks state of device's screen orientation.
- [`useOrientationFn`](./docs/useOrientationFn.md) &mdash; calls given function when screen orientation changes.

### 🔋 Device Information

_Package: `flutter_use_battery`_

- [`useBattery`](./docs/useBattery.md) &mdash; tracks device battery state. [![battery_plus](https://img.shields.io/badge/required-battery__plus-brightgreen)](https://pub.dev/packages/battery_plus)

_Package: `flutter_use_geolocation`_

- [`useGeolocation`](./docs/useGeolocation.md) &mdash; tracks geo location and permission state of user's device. [![geolocator](https://img.shields.io/badge/required-geolocator-brightgreen)](https://pub.dev/packages/geolocator)

_Package: `flutter_use_network_state`_

- [`useNetworkState`](./docs/useNetworkState.md) &mdash; tracks the state of apps network connection. [![connectivity_plus](https://img.shields.io/badge/required-connectivity__plus-brightgreen)](https://pub.dev/packages/connectivity_plus)

### 🎵 Media

_Package: `flutter_use_audio`_

- [`useAudio`](./docs/useAudio.md) &mdash; plays audio and exposes its controls. [![just_audio](https://img.shields.io/badge/required-just__audio-brightgreen)](https://pub.dev/packages/just_audio)

_Package: `flutter_use_video`_

- [`useAssetVideo`](./docs/useAssetVideo.md) and [`useNetworkVideo`](./docs/useNetworkVideo.md) &mdash; plays video, tracks its state, and exposes playback controls. [![video_player](https://img.shields.io/badge/required-video__player-brightgreen)](https://pub.dev/packages/video_player)

## 🚧 Coming Soon

- `useEvent` &mdash; subscribe to events.
- `useFullscreen` &mdash; display an element or video full-screen.
- `usePageLeave` &mdash; triggers when mouse leaves page boundaries.
- `usePermission` &mdash; query permission status for apps APIs.
- `useMethods` &mdash; neat alternative to `useReducer`.
- `useSetState` &mdash; creates `setState` method which works like `this.setState`.
- `usePromise` &mdash; resolves promise only while component is mounted.
- `useObservable` &mdash; tracks latest value of an `Observable`.

<br />
<br />
<br />

<p align="center">
  <a href="./LICENSE"><strong>Unlicense</strong></a> &mdash; public domain.
</p>

<br />
<br />

