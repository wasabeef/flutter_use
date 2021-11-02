<div align="center">
  <h1>
    <br/>
    <br/>
    👍
    <br />
    flutter_use
    <br />
    <br />
    <br />
    <br />
  </h1>
  <div>
    <br />
    <a href="https://pub.dev/packages/flutter_lints">
      <img src="https://img.shields.io/badge/style-flutter__lints-40c4ff.svg" alt="flutter_lints" />
    </a>
    <br />
    Inspired by <a href="https://github.com/streamich/react-use">react-use</a>.
    <br />
  </div>
  <br />
  <br />
</div>

- **Sensors**
  - `useBattery` &mdash; tracks device battery state. ![battery_plus](https://img.shields.io/badge/required-battery__plus-brightgreen)
  - `useGeolocation` &mdash; tracks geo location state of user's device. ![geolocator](https://img.shields.io/badge/required-geolocator-brightgreen)
  - `useNetworkState` &mdash; tracks the state of browser's network connection. ![connectivity_plus](https://img.shields.io/badge/required-connectivity__plus-brightgreen)
  - `useScroll` &mdash; tracks a widget's scroll position.
  - `useScrolling` &mdash; tracks whether widget is scrolling.
  - `useAccelerometer`, `useUserAccelerometer`, `useGyroscope,` and `useMagnetometer` &mdash; tracks accelerometer, gyroscope, and magnetometer sensors state of user's device. ![sensor_plus](https://img.shields.io/badge/required-sensor__plus-brightgreen)
    <br/>
    <br/>
- **UI**
  - `useFullscreen` &mdash; display an element or video full-screen.
  - `useAudio` &mdash; plays audio and exposes its controls. ![just_audio](https://img.shields.io/badge/required-just__audio-brightgreen)
  - [`useAssetVideo`](./docs/useAssetVideo.md) and [`useNetworkVideo`](./docs/useNetworkVideo.md) &mdash; plays video, tracks its state, and exposes playback controls. ![video_player](https://img.shields.io/badge/required-video__player-brightgreen) 
  - `useCamera` &mdash; plays camera, tracks its state, and its controls. ![camera](https://img.shields.io/badge/required-camera-brightgreen) 
    <br/>
    <br/>
- **Animations**
  - `useInterval` and `useHarmonicIntervalFn` &mdash; re-renders component on a set interval using `setInterval`.
  - `useTimeout` &mdash; re-renders component after a timeout.
  - `useTimeoutFn` &mdash; calls given function after a timeout.
    <br/>
    <br/>
- **Side-effects**
  - `useAsync`, `useAsyncFn`, and `useAsyncRetry` &mdash; resolves an `async` function.
  - `useCopyToClipboard` &mdash; copies text to clipboard.
  - `useDebounce` &mdash; debounces a function.
  - `useError` &mdash; error dispatcher.
  - `useThrottle` and `useThrottleFn` &mdash; throttles a function.
    <br/>
    <br/>
- **Lifecycles**
  - [`useEffectOnce`](./docs/useEffectOnce.md) &mdash; a modified [`useEffect`](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/useEffect.html) hook that only runs once.
  - `useEvent` &mdash; subscribe to events.
  - `useLifecycles` &mdash; calls `mount` and `unmount` callbacks.
  - `usePromise` &mdash; resolves promise only while component is mounted.
  - `useLogger` &mdash; logs in console as component goes through life-cycles.
  - `useUpdateEffect` &mdash; run an `effect` only on updates.
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
  - `useToggle` and `useBoolean` &mdash; tracks state of a boolean.
  - `useCounter` and `useNumber` &mdash; tracks state of a number.
  - `useList` &mdash; tracks state of an array.
  - `useMap` &mdash; tracks state of an object.
  - `useSet` &mdash; tracks state of a Set.
  - `useQueue` &mdash; implements simple queue.
  - `useStateValidator` &mdash; tracks state of an object.
  - `useMultiStateValidator` &mdash; alike the `useStateValidator`, but tracks multiple states at a time.
  - `useMethods` &mdash; neat alternative to `useReducer`.
