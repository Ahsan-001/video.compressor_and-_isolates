import 'package:flutter/material.dart';
import 'package:video_compressor_test/models/video_compression_result.dart';

class CompressionStatsWidget extends StatelessWidget {
  final VideoCompressionResult result;

  const CompressionStatsWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final orig = result.originalSize / 1024 / 1024;
    final comp = result.compressedSize / 1024 / 1024;
    final percent = ((orig - comp) / orig * 100).toStringAsFixed(1);

    return Column(
      children: [
        Text("Compressed Size: ${comp.toStringAsFixed(2)} MB"),
        Text("Compression: $percent%"),
        Text("Time taken: ${result.timeTaken.inSeconds}s"),
      ],
    );
  }
}
