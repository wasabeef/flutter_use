import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

/// Creates `VideoPlayerController` using [video_player](ref link), plays video
/// obtained from the network, tracks its state, and exposes playback controls.
/// [ref link](https://pub.dev/packages/video_player)
VideoPlayerController useNetworkVideo({
  required String dataSource,
  bool autoPlay = false,
  bool looping = false,
  Future<ClosedCaptionFile>? closedCaptionFile,
  VideoPlayerOptions? videoPlayerOptions,
  Map<String, String> httpHeaders = const {},
}) {
  final controller = useMemoized(
    () => VideoPlayerController.networkUrl(
      Uri.parse(dataSource),
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders: httpHeaders,
    ),
    [dataSource, closedCaptionFile, videoPlayerOptions, httpHeaders],
  );

  useEffect(() {
    controller
      ..initialize()
      ..setLooping(looping);

    if (autoPlay) {
      controller.play();
    }

    return controller.dispose;
  }, [dataSource, closedCaptionFile, videoPlayerOptions, httpHeaders]);

  return controller;
}
