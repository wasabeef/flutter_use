# `useNetworkVideo`

Creates `VideoPlayerController` using [video_player](https://pub.dev/packages/video_player), plays video obtained from the network, tracks its state, and exposes playback controls.

## Installation

Required [video_player](https://pub.dev/packages/video_player).

```yaml
dependencies:
  video_player:
  flutter_use_video: ^1.0.0
```

## Usage

```dart
class Counter extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final videoController = useNetworkVideo(
      dataSource: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      autoPlay: true,
      looping: true,
    );

    return Container(
      child: VideoPlayer(videoController),
    );
  }
}
```
