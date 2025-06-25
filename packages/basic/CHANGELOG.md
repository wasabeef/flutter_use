## 1.0.0

**First Stable Release**

This release marks a major milestone with 36 production-ready Flutter hooks. 
We've focused on providing developers with essential tools for async operations, 
form management, and modern UI interactions.

**New Hooks**
- `useAsync()` - Simplified async operation handling with automatic loading states
- `useAsyncFn()` - Manual async control for complex workflows  
- `useDebounceFn()` - Debounce functions to improve performance
- `useField()` - Smart form field management with built-in validation
- `useForm()` - Complete form solutions with multiple field coordination
- `useInfiniteScroll()` - Effortless infinite scrolling implementation
- `useKeyboard()` - Keyboard state awareness for better UX

**Key Features**
- Production-ready collection of 36 essential hooks
- Built-in validation system with common validators (email, required, length, etc.)
- Type-safe async patterns with automatic cancellation
- Advanced form handling with validation, focus management, and error states
- Infinite scroll with loading states and error recovery
- Responsive keyboard detection
- Comprehensive documentation with interactive examples

**Improvements**
- Better code organization with consistent file structure
- Enhanced type safety throughout the library
- Extensive test coverage for reliability
- Interactive demo app showcasing real-world usage patterns

**Breaking Changes**
- `useAsyncFn` moved to separate file for better maintainability
- Consistent naming convention for function-suffixed hooks

## 0.0.5

- Updated `flutter_hooks` to `^0.21.0`. See [PR #62](https://github.com/wasabeef/flutter_use/pull/62) for details.

## 0.0.3

**Development**
Update to Flutter v3
Update to require sdk >= 2.14.0
Update to flutter_hooks ^0.18.5+1

## 0.0.2

**Features**
- Add `useOrientation()` hook.
- Add `useOrientationFn()` hook.
- Add `useInterval()` hook.
- Add `useTimeout()` hook.
- Add `useTimeoutFn()` hook.
- Add `useUpdate()` hook.
- Add `useEffectOnce()` hook.
- Add `useLifecycle()` hook.
- Add `useUpdateEffect()` hook.
- Add `useToggle()` hook.
- Add `useBoolean()` hook.
- Add `useFirstMountState()` hook.
- Add `useBuildsCount()` hook.
- Add `useError()` hook.
- Add `useException()` hook.
- Add `useFutureRetry()` hook.
- Add `useDebounce()` hook.
- Add `useDefault()` hook.
- Add `useLogger()` hook.
- Add `useMap()` hook.
- Add `useSet()` hook.
- Add `useCustomCompareEffect()` hook.
- Add `useCounter()` hook.
- Add `useNumber()` hook.
- Add `useLatest()` hook.
- Add `useMount()` hook.
- Add `useUnmount()` hook.
