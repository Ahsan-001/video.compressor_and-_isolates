import 'package:flutter/material.dart';
import 'package:video_compressor_test/isolates/services/parser.dart';

class LoopScreen extends StatefulWidget {
  const LoopScreen({super.key});

  @override
  _LoopScreenState createState() => _LoopScreenState();
}

class _LoopScreenState extends State<LoopScreen> {
  List<Map<String, dynamic>> repeatedList = [];
  bool isLoading = false;

  void loadData() async {
    setState(() {
      isLoading = true;
      repeatedList = [];
    });

    // Set a realistic number (1 million). Do NOT set to 1 trillion!
    repeatedList = await repeatJsonListInIsolate(1000000); // 1 million

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Dummy List")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: isLoading ? null : loadData,
            child: Text("Generate Dummy Data"),
          ),
          if (isLoading) CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: repeatedList.length,
              itemBuilder: (context, index) {
                final item = repeatedList[index];
                return ListTile(
                  title: Text("${item['name']}"),
                  subtitle: Text("Index: $index, ID: ${item['id']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
