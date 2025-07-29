import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_compress/video_compress.dart';
import '../models/video_compression_result.dart';
import '../services/video_compression_service.dart';

final videoStateNotifierProvider =
    StateNotifierProvider<VideoNotifier, AsyncValue<VideoCompressionResult?>>(
      (ref) => VideoNotifier(),
    );

final currentVideoPathProvider = StateProvider<String>((ref) => '');
final originalVideoPathProvider = StateProvider<String>((ref) => '');

class VideoNotifier extends StateNotifier<AsyncValue<VideoCompressionResult?>> {
  VideoNotifier() : super(const AsyncValue.data(null));

  // Future<void> compress(
  //   String path, {
  //   VideoQuality quality = VideoQuality.MediumQuality,
  // }) async {
  //   state = const AsyncValue.loading();
  //   try {
  //     final result = await VideoCompressionService().compress(
  //       path,
  //       quality: quality,
  //     );
  //     state = AsyncValue.data(result);
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }

  Future<void> compress(String path, {int maxSizeMB = 2}) async {
    state = const AsyncValue.loading();
    try {
      String currentPath = path;
      late VideoCompressionResult result;
      int attempt = 0;
      const int maxAttempts = 3;

      while (attempt < maxAttempts) {
        attempt++;

        final quality =
            attempt == 1 ? VideoQuality.MediumQuality : VideoQuality.LowQuality;

        final compressionResult = await VideoCompressionService().compress(
          currentPath,
          quality: quality,
        );

        final compressedSizeMB = compressionResult.compressedSize / 1024 / 1024;
        result = compressionResult;

        if (compressedSizeMB <= maxSizeMB) {
          break;
        }

        currentPath = compressionResult.compressedPath;
      }

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() => state = const AsyncValue.data(null);
}
