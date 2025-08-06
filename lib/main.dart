import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_compressor_test/isolates/views/home_screen.dart';
import 'package:video_compressor_test/method%20channels/method_channel.dart';
// import 'package:video_compressor_test/isolates/views/loop_json_parser_screen.dart';
// import 'package:video_compressor_test/isolates/views/single_json_parser_screen.dart';
// import 'video compressor/views/video_capture_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Compression & Isolates Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const VideoCaptureScreen(),
      // home: JsonParserScreen(),
      // home: HomePage(),
      home: BatteryScreen(),
    );
  }
}
