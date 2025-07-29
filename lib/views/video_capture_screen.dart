import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'video_preview_screen.dart';
import '../providers/video_provider.dart';

class VideoCaptureScreen extends ConsumerWidget {
  const VideoCaptureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateNotifierProvider);
    final videoNotifier = ref.read(videoStateNotifierProvider.notifier);
    final picker = ImagePicker();

    Future<void> recordVideo() async {
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 10),
        preferredCameraDevice: CameraDevice.rear,
      );

      if (video != null) {
        videoNotifier.reset();
        ref.read(currentVideoPathProvider.notifier).state = video.path;
        ref.read(originalVideoPathProvider.notifier).state = video.path;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VideoPreviewScreen()),
        );
      }
    }

    Future<void> pickFromGallery() async {
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        videoNotifier.reset();
        ref.read(currentVideoPathProvider.notifier).state = video.path;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VideoPreviewScreen()),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Video Compressor Test")),
      body: Center(
        child:
            videoState.isLoading
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: recordVideo,
                      child: const Text("Record Video (Camera)"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: pickFromGallery,
                      child: const Text("Pick Video (Gallery)"),
                    ),
                  ],
                ),
      ),
    );
  }
}
