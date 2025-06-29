# `useNetworkState`

Tracks network connection.

## Installation

Depends on [connectivity_plus](https://pub.dev/packages/connectivity_plus).

```yaml
dependencies:
  flutter_use_network_state: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-network-state)

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