import 'dart:convert';
import 'dart:isolate';

// getting single list one time using isolates

Future<List<Map<String, dynamic>>> parseJsonInIsolate(String jsonStr) async {
  final response = ReceivePort();

  await Isolate.spawn(_isolateEntry, [response.sendPort, jsonStr]);

  return await response.first;
}

void _isolateEntry(List<dynamic> args) {
  SendPort sendPort = args[0];
  String jsonString = args[1];

  List<dynamic> parsedList = jsonDecode(jsonString);
  List<Map<String, dynamic>> result =
      parsedList.map((item) => Map<String, dynamic>.from(item)).toList();

  sendPort.send(result);
}

// getting list with trillion times of loop using isolates

Future<List<Map<String, dynamic>>> repeatJsonListInIsolate(
  int repeatCount,
) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_repeatJsonList, [receivePort.sendPort, repeatCount]);
  return await receivePort.first;
}

void _repeatJsonList(List args) {
  SendPort sendPort = args[0];
  int repeatCount = args[1];

  const String originalJson = '''
  [
    {"id": 1, "name": "Apple"},
    {"id": 2, "name": "Banana"},
    {"id": 3, "name": "Orange"},
    {"id": 4, "name": "Mango"},
    {"id": 5, "name": "Peach"}
  ]
  ''';

  List<dynamic> parsed = jsonDecode(originalJson);
  List<Map<String, dynamic>> fullList = [];

  for (int i = 0; i < repeatCount; i++) {
    fullList.addAll(parsed.map((e) => Map<String, dynamic>.from(e)));
  }

  sendPort.send(fullList);
}

// for animation using isolates

Future<double> complexTask1() async {
  var total = 0.0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  return total;
}

complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
