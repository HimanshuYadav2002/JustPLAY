import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/Streaming_Logic/core_streaming_functions.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeAudioSource extends StreamAudioSource {
  final String videoId;
  final CoreStreamingFunctions streamingFunctions = CoreStreamingFunctions();

  YoutubeAudioSource({required this.videoId, super.tag});

  // function used by just audio
  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    StreamInfo audioStream = await streamingFunctions.getStreamInfo(videoId);

    start ??= 0;
    end ??= (audioStream.isThrottled
        ? (end ?? (start + 10379935))
        : audioStream.size.totalBytes);
    if (end > audioStream.size.totalBytes) {
      end = audioStream.size.totalBytes;
    }

    try {
      // here we fetch real stream from url of streaminfo
      final stream = streamingFunctions.getStream(
        audioStream,
        start: start,
        end: end,
      );
      return StreamAudioResponse(
        sourceLength: audioStream.size.totalBytes,
        contentLength: end - start,
        offset: start,
        stream: stream,
        contentType: audioStream.codec.mimeType,
      );
    } catch (e) {
      throw Exception('Failed to load audio: $e');
    }
  }
}
