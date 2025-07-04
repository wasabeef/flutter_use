# `useTimeoutFn`

Calls given function after specified duration.

Several thing about it's work:
- does not re-build component;
- automatically cancel timeout on cancel;
- automatically reset timeout on delay change;
- reset function call will cancel previous timeout;
- timeout will NOT be reset on function change. It will be called within the timeout, you have to reset it on your own when needed. 

## Installation

```yaml
dependencies:
  flutter_use: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-timeout-fn)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {

    final timeout = useTimeoutFn(() {
      debugPrint("Timeout");
    }, const Duration(milliseconds: 300));
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("isReady?: ${timeout.isReady}"),
            ElevatedButton(
              onPressed: () => timeout.cancel(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => timeout.reset(),
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
```
## Reference

- **`fn`**_`: VoidCallback`_ - function that will be called;
- **`delay`**_`: Duration`_ - delay
- **`isReady()`**_`: bool?`_ - function returning current timeout state:
    - `false` - pending re-build
    - `true` - re-build performed
    - `null` - re-build cancelled
- **`cancel()`** - cancel the timeout (component will not be re-builded)
- **`reset()`** - reset the timeout