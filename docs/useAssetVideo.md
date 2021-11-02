# `useAssetVideo`

Creates `VideoPlayerController` using [video_player](https://pub.dev/packages/video_player), plays video obtained from an asset, tracks its state, and exposes playback controls.

## Installation

Required [video_player](https://pub.dev/packages/video_player).

```yaml
dependencies:
  video_player:
  flutter_use_video: ^1.0.0
```

## Usage

```dart
class Sample extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final videoController = useAssetVideo(
      asset: "assets/video/get_started.mp4",
      autoPlay: true,
      looping: true,
    );

    return Container(
      child: VideoPlayer(videoController),
    );
  }
}
```
