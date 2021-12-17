import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:just_audio/just_audio.dart';

/// plays audio using [just_audio](ref link) plugin, and exposes its controls.
/// [ref link](https://pub.dev/packages/just_audio)
AudioPlayer useAudio({
  String? userAgent,
  bool handleInterruptions = true,
  bool androidApplyAudioAttributes = true,
  bool handleAudioSessionActivation = true,
  AudioLoadConfiguration? audioLoadConfiguration,
  AudioPipeline? audioPipeline,
}) {
  final audio = useMemoized(
    () => AudioPlayer(
      userAgent: userAgent,
      handleInterruptions: handleInterruptions,
      androidApplyAudioAttributes: androidApplyAudioAttributes,
      handleAudioSessionActivation: handleAudioSessionActivation,
      audioLoadConfiguration: audioLoadConfiguration,
      audioPipeline: audioPipeline,
    ),
    [
      userAgent,
      handleInterruptions,
      androidApplyAudioAttributes,
      handleAudioSessionActivation,
      audioLoadConfiguration,
      audioPipeline,
    ],
  );

  useEffect(() {
    return () {
      audio.stop();
      audio.dispose();
    };
  }, [
    userAgent,
    handleInterruptions,
    androidApplyAudioAttributes,
    handleAudioSessionActivation,
    audioLoadConfiguration,
    audioPipeline,
  ]);

  return audio;
}
