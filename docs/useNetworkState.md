# `useNetworkState`

Tracks network connection.

## Installation

Required [connectivity_plus](https://pub.dev/packages/connectivity_plus).

```yaml
dependencies:
  battery_plus:
  flutter_use_network_state: ^0.0.2
```

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final networkState = useNetworkState();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("-- Network --"),
            Text("fetched: ${networkState.fetched}"),
            Text(
                "connectivityResult: ${networkState.connectivityResult}"),
          ],
        ),
      ),
    );
  }
}
```
## Reference

- **`fetched`**_`: bool`_ - whether network connection state is fetched;
- **`connectivity`**_`: ConnectivityResult`_ - network connection state changes.
  - **`wifi`** - Device connected via Wi-Fi.
  - **`ethernet`** - Device connected to ethernet network.
  - **`mobile`** - Device connected to cellular network.
  - **`none`** - Device not connected to any network.