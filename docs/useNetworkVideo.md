# `useNetworkVideo`

Creates `VideoPlayerController` using [video_player](https://pub.dev/packages/video_player), plays video obtained from the network, tracks its state, and exposes playback controls.

## Installation

Depends on [video_player](https://pub.dev/packages/video_player).

```yaml
dependencies:
  flutter_use_video: 
```

## Usage

[![](https://img.shields.io/badge/demo-%20%20%20%F0%9F%9A%80-green.svg)](https://wasabeef.github.io/flutter_use/#/use-network-video)

```dart
class Sample extends HookWidget {
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
