import 'dart:io';
import 'package:video_compress/video_compress.dart';
import 'package:video_compressor_test/models/video_compression_result.dart';

class VideoCompressionService {
  Future<VideoCompressionResult> compress(
    String videoPath, {
    VideoQuality quality = VideoQuality.MediumQuality,
  }) async {
    final stopwatch = Stopwatch()..start();

    final MediaInfo? info = await VideoCompress.compressVideo(
      videoPath,
      quality: quality,
      deleteOrigin: false,
    );

    stopwatch.stop();

    return VideoCompressionResult(
      originalPath: videoPath,
      compressedPath: info?.path ?? '',
      originalSize: File(videoPath).lengthSync(),
      compressedSize: File(info!.path!).lengthSync(),
      timeTaken: stopwatch.elapsed,
    );
  }
}
