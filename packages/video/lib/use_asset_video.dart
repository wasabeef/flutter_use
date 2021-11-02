library template;

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

/// plays video from an asset using [video_player](ref link) plugin, tracks its state, and exposes playback controls.
/// [ref link](https://pub.dev/packages/video_player)
VideoPlayerController useAssetVideo({
  required String asset,
  String? package,
  bool autoPlay = false,
  bool looping = false,
  Future<ClosedCaptionFile>? closedCaptionFile,
  VideoPlayerOptions? videoPlayerOptions,
}) {
  final controller = useMemoized(
    () => VideoPlayerController.asset(
      asset,
      package: package,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
    ),
    [asset, package, closedCaptionFile, videoPlayerOptions],
  );

  useEffect(() {
    controller
      ..initialize()
      ..setLooping(looping);

    if (autoPlay) {
      controller.play();
    }

    return controller.dispose;
  }, [asset, package, closedCaptionFile, videoPlayerOptions]);

  return controller;
}
