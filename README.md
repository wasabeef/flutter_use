<div align="center">
  <img src="https://github.com/wasabeef/flutter_use/raw/main/art/flutter_use_logo.png" width="480px" alt="flutter_use" />
  <div>
    <br />
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

- **Sensors**
  - [`useBattery`](./docs/useBattery.md) &mdash; tracks device battery state. [![battery_plus](https://img.shields.io/badge/required-battery__plus-brightgreen)](https://pub.dev/packages/battery_plus)
  - [`useGeolocation`](./docs/useGeolocation.md) &mdash; tracks geo location and permission state of user's device. [![geolocator](https://img.shields.io/badge/required-geolocator-brightgreen)](https://pub.dev/packages/geolocator)
  - [`useNetworkState`](./docs/useNetworkState.md) &mdash; tracks the state of apps network connection. [![connectivity_plus](https://img.shields.io/badge/required-connectivity__plus-brightgreen)](https://pub.dev/packages/connectivity_plus)
  - [`useAccelerometer`](./docs/useAccelerometer.md), [`useUserAccelerometer`](./docs/useUserAccelerometer.md), [`useGyroscope`](./docs/useGyroscope.md), and [`useMagnetometer`](./docs/useMagnetometer.md) &mdash; tracks accelerometer, gyroscope, and magnetometer sensors state of user's device. [![sensors_plus](https://img.shields.io/badge/required-sensors__plus-brightgreen)](https://pub.dev/packages/sensors_plus)
  - [`useOrientation`](./docs/useOrientation.md) &mdash; tracks state of device's screen orientation.
  - [`useOrientationFn`](./docs/useOrientationFn.md) &mdash; calls given function changed screen orientation of user's device.
    <br/>
    <br/>
- **UI**
  - [`useAudio`](./docs/useAudio.md) &mdash; plays audio and exposes its controls. [![just_audio](https://img.shields.io/badge/required-just__audio-brightgreen)](https://pub.dev/packages/just_audio)
  - [`useAssetVideo`](./docs/useAssetVideo.md) and [`useNetworkVideo`](./docs/useNetworkVideo.md) &mdash; plays video, tracks its state, and exposes playback controls. [![video_player](https://img.shields.io/badge/required-video__player-brightgreen)](https://pub.dev/packages/video_player)
    <br/>
    <br/>
- **Animations**
  - [`useInterval`](./docs/useInterval.md) &mdash; re-builds component on a set interval using [`Timer.periodic`](https://api.dart.dev/stable/2.14.4/dart-async/Timer/Timer.periodic.html). [![][img-demo]](https://dartpad.dev/?id=d4ce8c315a0157ad18257886d661c8b9&null_safety=true)
  - [`useTimeout`](./docs/useTimeout.md) &mdash; re-builds component after a timeout. [![][img-demo]](https://dartpad.dev/?id=e1cb8d7045982ec96b0b314e9fb58202&null_safety=true)
  - [`useTimeoutFn`](./docs/useTimeoutFn.md) &mdash; calls given function after a timeout. [![][img-demo]](https://dartpad.dev/?id=12449436914e1dec13c8f9c5cf63935b&null_safety=true)
  - [`useUpdate`](./docs/useUpdate.md) &mdash; returns a callback, which re-builds component when called.
    <br/>
    <br/>
- **Side-effects**
  - [`useFutureRetry`](./docs/useFutureRetry.md) &mdash; [`useFuture`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useFuture.html) with an additional retry method.  [![][img-demo]](https://dartpad.dev/?id=ab910cc4170f5e8746229cc958ba845c&null_safety=true)
  - `useDebounce` &mdash; debounces a function.
  - [`useError`](./docs/useError.md) &mdash; error dispatcher. [![][img-demo]](https://dartpad.dev/?id=8e8e4876d546dd38517cb833ee694359&null_safety=true)
  - [`useException`](.docs/useException.md) &mdash; exception dispatcher. [![][img-demo]](https://dartpad.dev/?id=98580d1987dcae38ea0f27ee67a0d089&null_safety=true)
  - `useThrottle` and `useThrottleFn` &mdash; throttles a function.
    <br/>
    <br/>
- **Lifecycles**
  - [`useEffectOnce`](./docs/useEffectOnce.md) &mdash; a modified [`useEffect`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useEffect.html) hook that only runs once.
  - [`useLifecycles`](./docs/useLifecycles.md) &mdash; calls `mount` and `unmount` callbacks.
  - `usePromise` &mdash; resolves promise only while component is mounted.
  - `useLogger` &mdash; logs in console as component goes through life-cycles.
  - [`useUpdateEffect`](./docs/useUpdateEffect.md) &mdash; run an `effect` only on updates. [![][img-demo]](https://dartpad.dev/?id=724fee007fe78419fde61f185b83095b&null_safety=true)
  - `useDeepCompareEffect`, `useShallowCompareEffect`, and `useCustomCompareEffect` &mdash; run an `effect` depending on deep comparison of its dependencies
    <br/>
    <br/>
- **State**
  - `useDefault` &mdash; returns the default value when state is `null` or `undefined`.
  - `useLatest` &mdash; returns the latest state or props
  - `usePreviousDistinct` &mdash; like `usePrevious` but with a predicate to determine if `previous` should update.
  - `useObservable` &mdash; tracks latest value of an `Observable`.
  - `useSetState` &mdash; creates `setState` method which works like `this.setState`.
  - `useStateList` &mdash; circularly iterates over an array.
  - [`useToggle` and `useBoolean`](./docs/useToggle.md) &mdash; tracks state of a boolean. [![][img-demo]](https://dartpad.dev/?id=7e070264db2566b3c990c403dd61c3ff&null_safety=true)
  - `useCounter` and `useNumber` &mdash; tracks state of a number.
  - `useList` &mdash; tracks state of an array.
  - `useMap` &mdash; tracks state of an object.
  - `useSet` &mdash; tracks state of a Set.
  - `useQueue` &mdash; implements simple queue.
  - `useStateValidator` &mdash; tracks state of an object.
  - `useMultiStateValidator` &mdash; alike the `useStateValidator`, but tracks multiple states at a time.
  - [`useFirstMountState`](./docs/useFirstMountState.md) &mdash; check if current build is first. [![][img-demo]](https://dartpad.dev/?id=c9b6853d726ae29dcf902efcf7e85dc6&null_safety=true)
  - [`useBuildsCount`](./docs/useBuildsCount.md) &mdash; count component builds. [![][img-demo]](https://dartpad.dev/?id=d54979d95910abd48054547202e20c12&null_safety=true)
  - `useMethods` &mdash; neat alternative to `useReducer`.

- **TBD**
  - `useCopyToClipboard` &mdash; copies text to clipboard.
  - `useEvent` &mdash; subscribe to events.
  - `useScroll` &mdash; tracks a widget's scroll position.
  - `useScrolling` &mdash; tracks whether widget is scrolling.
  - `useFullscreen` &mdash; display an element or video full-screen.
  - `useClickAway`&mdash; triggers callback when user clicks outside target area.
  - `usePageLeave` &mdash; triggers when mouse leaves page boundaries.
  - `usePermission` &mdash; query permission status for apps APIs.

<br />
<br />
<br />

<p align="center">
  <a href="./LICENSE"><strong>Unlicense</strong></a> &mdash; public domain.
</p>

<br />
<br />


[img-demo]: https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg
