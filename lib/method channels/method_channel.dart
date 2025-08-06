import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = 'Unknown battery level.';
  String _deviceName = 'Unknown device';

  Future<void> _getBatteryInfo() async {
    String batteryLevel;
    String deviceName;

    try {
      final result = await platform.invokeMethod<Map>('getBatteryInfo');
      batteryLevel = "${result?['battery']}%";
      deviceName = result?['device'] ?? 'Unknown device';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
      deviceName = "Failed to get device name.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
      _deviceName = deviceName;
    });
  }

  @override
  void initState() {
    super.initState();
    // _getBatteryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Battery & Device Info")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _getBatteryInfo, child: Text('Get info')),
            SizedBox(height: 20),

            Text('Device: $_deviceName', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text(
              'Battery Level: $_batteryLevel',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
