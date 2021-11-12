# `useTimeout`

Re-builds the component after a specified duration.
Provides handles to cancel and/or reset the timeout.

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    
    final timeout = useTimeout(const Duration(milliseconds: 300));

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

- **`delay`**_`: Duration`_ - delay
- **`isReady`**_`: bool`_ - function returning current timeout state:
    - `false` - pending re-build
    - `true` - re-build performed
    - `null` - re-build cancelled
- **`cancel()`** - cancel the timeout (component will not be re-builded)
- **`reset()`** - reset the timeout