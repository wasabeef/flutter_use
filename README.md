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
  - [`useUpdate`](./docs/useUpdate.md) &mdash; returns a callback, which re-builds component when called. [![][img-demo]](https://dartpad.dev/?id=27a74d481219749f532776a8e73f3464&null_safety=true)
    <br/>
    <br/>
- **Side-effects**
  - [`useFutureRetry`](./docs/useFutureRetry.md) &mdash; [`useFuture`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useFuture.html) with an additional retry method. [![][img-demo]](https://dartpad.dev/?id=ab910cc4170f5e8746229cc958ba845c&null_safety=true)
  - [`useDebounce`](./docs/useDebounce.md) &mdash; debounces a function. [![][img-demo]](https://dartpad.dev/?id=977ee00fc30da8f0dd1888f6808114eb&null_safety=true)
  - [`useError`](./docs/useError.md) &mdash; error dispatcher. [![][img-demo]](https://dartpad.dev/?id=8e8e4876d546dd38517cb833ee694359&null_safety=true)
  - [`useException`](.docs/useException.md) &mdash; exception dispatcher. [![][img-demo]](https://dartpad.dev/?id=98580d1987dcae38ea0f27ee67a0d089&null_safety=true)
    <br/>
    <br/>
- **Lifecycles**
  - [`useEffectOnce`](./docs/useEffectOnce.md) &mdash; a modified [`useEffect`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useEffect.html) hook that only runs once. [![][img-demo]](https://dartpad.dev/?id=adec4d3a92f52bc8a40dc55ff330d2ab&null_safety=true)
  - [`useLifecycles`](./docs/useLifecycles.md) &mdash; calls `mount` and `unmount` callbacks.
  - [`useLogger`](./docs/useLogger.md) &mdash; logs in console as component goes through life-cycles. [![][img-demo]](https://dartpad.dev/?id=c72c9ab0fa46f93dd266f6557a29a3ed&null_safety=true)
  - [`useMount`](./docs/useMount.md) &mdash; calls `mount` callbacks. [![][img-demo]](https://dartpad.dev/?id=aa25e9bc3913779fcc795bef2bdc8d39&null_safety=true)
  - [`useUnmount`](./docs/useUnmount.md) &mdash; calls `unmount` callbacks.
  - [`useUpdateEffect`](./docs/useUpdateEffect.md) &mdash; run an `effect` only on updates. [![][img-demo]](https://dartpad.dev/?id=724fee007fe78419fde61f185b83095b&null_safety=true)
  - [`useCustomCompareEffect`](./docs/useCustomCompareEffect.md) &mdash; run an `effect` depending on deep comparison of its dependencies. [![][img-demo]](https://dartpad.dev/?id=27146b5ca9189664e39ad4dfe9b08abe&null_safety=true)
    <br/>
    <br/>
- **State**
  - [`useDefault`](./docs/useDefault.md) &mdash; returns the default value when state is `null`. [![][img-demo]](https://dartpad.dev/?id=6511219165b2e5c64ec8890b69633da6&null_safety=true)
  - [`useLatest`](./docs/useLatest.md) &mdash; returns the latest state or props. [![][img-demo]](https://dartpad.dev/?id=2a76f5b16c2f27d11c023a140f38ce33&null_safety=true)
  - [`usePreviousDistinct`](./docs/usePreviousDistinct.md) &mdash; like [`usePrevious`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/usePrevious.html) but with a predicate to determine if `previous` should update. [![][img-demo]](https://dartpad.dev/?id=86e0e29f8198095dbd0d68a736c671bb&null_safety=true)
  - [`useStateList`](./docs/useStateList.md) &mdash; circularly iterates over an array. [![][img-demo]](https://dartpad.dev/?id=5761442418062838b04cbe21a36be586&null_safety=true)
  - [`useToggle` and `useBoolean`](./docs/useToggle.md) &mdash; tracks state of a boolean. [![][img-demo]](https://dartpad.dev/?id=7e070264db2566b3c990c403dd61c3ff&null_safety=true)
  - [`useCounter` and `useNumber`](./docs/useCounter.md) &mdash; tracks state of a number.  [![][img-demo]](https://dartpad.dev/?id=5ee82acd2f1947b2d0ca02da4ab327b8&null_safety=true)
  - [`useList`](./docs/useList.md) &mdash; tracks state of an array. [![][img-demo]](https://dartpad.dev/?id=e04b584b8ab67492a1024ea7dd9adcbb&null_safety=true)
  - [`useMap`](./docs/useMap.md) &mdash; tracks state of a map. [![][img-demo]](https://dartpad.dev/?id=325b4737e78d40463fc0f3d3cc317b35&null_safety=true)
  - [`useSet`](./docs/useSet.md) &mdash; tracks state of a Set. [![][img-demo]](https://dartpad.dev/?id=3d1199828a54b19c526a26a6c0021293&null_safety=true)
  - [`useTextFormValidator`](./docs/useTextFormValidator.md) &mdash; tracks state of an object. [![][img-demo]](https://dartpad.dev/?id=23dee1c153a8a9e455d463584537256e&null_safety=true)
  - [`useFirstMountState`](./docs/useFirstMountState.md) &mdash; check if current build is first. [![][img-demo]](https://dartpad.dev/?id=c9b6853d726ae29dcf902efcf7e85dc6&null_safety=true)
  - [`useBuildsCount`](./docs/useBuildsCount.md) &mdash; count component builds. [![][img-demo]](https://dartpad.dev/?id=d54979d95910abd48054547202e20c12&null_safety=true)
    <br/>
    <br/>
- <details><summary><b>TBD</b></summary><div>
  
  - `useCopyToClipboard` &mdash; copies text to clipboard.
  - `useEvent` &mdash; subscribe to events.
  - `useScroll` &mdash; tracks a widget's scroll position.
  - `useScrolling` &mdash; tracks whether widget is scrolling.
  - `useFullscreen` &mdash; display an element or video full-screen.
  - `useClickAway`&mdash; triggers callback when user clicks outside target area.
  - `usePageLeave` &mdash; triggers when mouse leaves page boundaries.
  - `usePermission` &mdash; query permission status for apps APIs.
  - `useMethods` &mdash; neat alternative to `useReducer`.
  - `useSetState` &mdash; creates `setState` method which works like `this.setState`.
  - `usePromise` &mdash; resolves promise only while component is mounted.
  - `useObservable` &mdash; tracks latest value of an `Observable`.
  - `useThrottle` and `useThrottleFn` &mdash; throttles a function.
  
</div></details>


<br />
<br />
<br />

<p align="center">
  <a href="./LICENSE"><strong>Unlicense</strong></a> &mdash; public domain.
</p>

<br />
<br />


[img-demo]: https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg
