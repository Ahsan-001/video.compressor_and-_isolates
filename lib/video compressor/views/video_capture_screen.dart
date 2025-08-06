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
        ref.read(originalVideoPathProvider.notifier).state = video.path;
        ref.read(currentVideoPathProvider.notifier).state = video.path;

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
        ref.read(originalVideoPathProvider.notifier).state = video.path;
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
                ? Center(
                  child: const CircularProgressIndicator(color: Colors.white),
                )
                : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          // foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(200, 50),
                        ),
                        onPressed: recordVideo,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Record Video",
                              style: TextStyle(color: Colors.white),
                            ),
                            // const Spacer(),
                            SizedBox(width: 5),
                            const Icon(
                              Icons.camera_alt,
                              size: 24,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          // foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(200, 50),
                        ),
                        onPressed: pickFromGallery,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Text(
                              "From Gallery",
                              style: TextStyle(color: Colors.white),
                            ),
                            // const Spacer(),
                            SizedBox(width: 5),
                            const Icon(
                              Icons.photo_library,
                              size: 24,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
