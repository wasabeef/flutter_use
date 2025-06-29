# `useAudio`

Creates `AudioPlayer`, tracks its state and exposes playback controls.

## Installation

Depends on [just_audio](https://pub.dev/packages/just_audio).

```yaml
dependencies:
  flutter_use_audio: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-audio)

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final player = useAudio();
    return ElevatedButton(
      onPressed: () async {
        player.play();
        await player.seek(const Duration(seconds: 10));
        await player.pause();
      },
      child: const Text('Play'),
    );
  }
}
```
