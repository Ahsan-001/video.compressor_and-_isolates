import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_compressor_test/isolates/services/parser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  double a = 0;
  double b = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,

        title: const Text(
          "Async Vs Isolates",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Image.asset('assets/gifs/g2.json'),
                Lottie.asset('assets/gifs/g2.json'),
                //Blocking UI task
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(150, 50),
                        maximumSize: const Size(150, 50),
                        elevation: 2,
                        shadowColor: Colors.black12,
                      ),
                      onPressed: () async {
                        a = await complexTask1();
                        setState(() {});
                        debugPrint('Result 1: $a');
                      },
                      child: const Text(
                        'Using Async',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    (a != 0)
                        ? Text(
                          "Data Received",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        )
                        : const CircularProgressIndicator(color: Colors.green),
                  ],
                ),
                //Isolate
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(150, 50),
                        maximumSize: const Size(150, 50),
                        elevation: 2,
                        shadowColor: Colors.black12,
                      ),
                      onPressed: () async {
                        final receivePort = ReceivePort();
                        await Isolate.spawn(complexTask2, receivePort.sendPort);
                        receivePort.listen((total) {
                          debugPrint('Result 2: $total');
                          b = total;
                          setState(() {});
                        });
                      },
                      child: const Text(
                        'Using Isolate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    (b != 0)
                        ? Text(
                          "Data Received",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        )
                        : const CircularProgressIndicator(color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
