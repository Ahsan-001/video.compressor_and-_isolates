
import 'package:flutter/material.dart';
import 'package:video_compressor_test/isolates/models/dummy_data.dart';
import 'package:video_compressor_test/isolates/services/parser.dart';

class JsonParserScreen extends StatefulWidget {
  const JsonParserScreen({super.key});

  @override
  _JsonParserScreenState createState() => _JsonParserScreenState();
}

class _JsonParserScreenState extends State<JsonParserScreen> {
  List<Map<String, dynamic>> parsedData = [];
  bool isLoading = false;

  void _parseJson() async {
    setState(() {
      isLoading = true;
    });

    // Call isolate function
    parsedData = await parseJsonInIsolate(largeJson);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isolate Demo'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading ? null : _parseJson,
            child: Text('Parse Large JSON'),
          ),
          SizedBox(height: 20),
          if (isLoading) CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: parsedData.length,
              itemBuilder: (context, index) {
                final item = parsedData[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(item['id'].toString())),
                  title: Text(item['name']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}