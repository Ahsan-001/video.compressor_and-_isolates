import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_compress/video_compress.dart';
import '../providers/video_provider.dart';
import '../widgets/compression_stats_widget.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  const VideoPreviewScreen({super.key});

  @override
  ConsumerState<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    final videoPath = ref.read(currentVideoPathProvider);

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      videoPath,
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: null,
        autoPlay: true,
        looping: true,
        fit: BoxFit.contain,
        handleLifecycle: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  Future<void> _compressAgain() async {
    final currentPath = ref.read(currentVideoPathProvider);

    await ref
        .read(videoStateNotifierProvider.notifier)
        .compress(currentPath, quality: VideoQuality.LowQuality);

    final result = ref.read(videoStateNotifierProvider).value;

    if (result != null) {
      ref.read(currentVideoPathProvider.notifier).state = result.compressedPath;

      final newDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        result.compressedPath,
      );

      _betterPlayerController?.setupDataSource(newDataSource);
    }
  }

  double _getSize(String path) => File(path).lengthSync() / 1024 / 1024;

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoPath = ref.watch(currentVideoPathProvider);
    final videoState = ref.watch(videoStateNotifierProvider);
    final result = videoState.value;

    final originalPath =
        ref.read(videoStateNotifierProvider).value?.originalPath ?? videoPath;
    final compressedPath =
        ref.read(videoStateNotifierProvider).value?.compressedPath;

    final originalSize = _getSize(originalPath);
    final currentSize = _getSize(compressedPath ?? originalPath);

    return Scaffold(
      appBar: AppBar(title: const Text("Video Preview")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: AspectRatio(
                aspectRatio:
                    _betterPlayerController
                        ?.videoPlayerController
                        ?.value
                        .aspectRatio ??
                    9 / 16,
                child: BetterPlayer(controller: _betterPlayerController!),
              ),
            ),
            const SizedBox(height: 10),
            Text("Original Size: ${originalSize.toStringAsFixed(2)} MB"),
            // Text("Current Playing Size: ${currentSize.toStringAsFixed(2)} MB"),
            const Divider(),

            if (result != null) ...[
              // const Text(
              //   "Currently Playing: Compressed Video ",
              //   style: TextStyle(color: Colors.green),
              // ),
              CompressionStatsWidget(result: result),
            ],

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: videoState.isLoading ? null : _compressAgain,
              child:
                  videoState.isLoading
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.compress),
                          SizedBox(width: 8),
                          Text("Compress More"),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
