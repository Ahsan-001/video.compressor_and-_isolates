import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_compressor_test/views/home/home.dart';
// import 'package:video_compress/video_compress.dart';
import '../providers/video_provider.dart';
import '../widgets/compression_stats_widget.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  const VideoPreviewScreen({super.key});

  @override
  ConsumerState<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  BetterPlayerController? _betterPlayerController;
  late String _currentVideoPath;

  @override
  void initState() {
    super.initState();

    _currentVideoPath = ref.read(currentVideoPathProvider);

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      _currentVideoPath,
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
    final notifier = ref.read(videoStateNotifierProvider.notifier);

    final currentSize = _getSize(_currentVideoPath);
    if (currentSize <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video is already under 2MB.")),
      );
      return;
    }

    await notifier.compress(_currentVideoPath, maxSizeMB: 2);

    final result = ref.read(videoStateNotifierProvider).value;
    if (result != null) {
      _currentVideoPath = result.compressedPath;

      final newDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        _currentVideoPath,
      );

      _betterPlayerController?.setupDataSource(newDataSource);
    }
  }

  double _getSize(String path) {
    final file = File(path);
    if (!file.existsSync()) return 0;
    return file.lengthSync() / 1024 / 1024;
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoStateNotifierProvider);
    final result = videoState.value;

    // final originalPath = result?.originalPath ?? _currentVideoPath;
    final originalPath = ref.watch(originalVideoPathProvider);
    final compressedPath = result?.compressedPath ?? _currentVideoPath;

    final originalSize = _getSize(originalPath);
    final currentSize = _getSize(compressedPath);

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
            Text("Current Playing Size: ${currentSize.toStringAsFixed(2)} MB"),
            const Divider(),

            if (result != null) ...[
              const Text(
                "Currently Playing: Compressed Video",
                style: TextStyle(color: Colors.green),
              ),
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
            // Spacer(),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                final compressedSize = _getSize(compressedPath);
                if (compressedSize <= 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Video exceeds 2MB. Please compress it again.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Submit Video", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
