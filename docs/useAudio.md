# `useAudio`

Creates `AudioPlayer`, tracks its state and exposes playback controls.

## Installation

Required [just_audio](https://pub.dev/packages/just_audio).

```yaml
dependencies:
  just_audio:
  flutter_use_audio: ^1.0.0
```

## Usage

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
