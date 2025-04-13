import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform checks
import 'package:ant_media_flutter/ant_media_flutter.dart'; // For AntMedia permissions
import 'play.dart'; // Import the PlayScreen file
import 'publish.dart'; // Import the PublishScreen file

// Define a constant for the host URL
const String hostUrl = 'wss://ams.pm.tts.live:5443/TestIradaAPP/websocket';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Enter Stream ID'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _streamIdController = TextEditingController();

  Future<void> _requestPermissionsAndNavigate(
      BuildContext context, Widget targetScreen) async {
    // Request permissions
    AntMediaFlutter.requestPermissions();

    // For Android, start the foreground service
    if (!kIsWeb && Platform.isAndroid) {
      AntMediaFlutter.startForegroundService();
    }

    // Navigate to the target screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _streamIdController,
              decoration: const InputDecoration(
                labelText: 'Stream ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final streamId = _streamIdController.text.trim();
                if (streamId.isNotEmpty) {
                  _requestPermissionsAndNavigate(
                    context,
                    PlayScreen(streamId: streamId, hostUrl: hostUrl),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a Stream ID')),
                  );
                }
              },
              child: const Text('Load Stream'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final streamId = _streamIdController.text.trim();
                if (streamId.isNotEmpty) {
                  _requestPermissionsAndNavigate(
                    context,
                    PublishScreen(streamId: streamId, hostUrl: hostUrl),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a Stream ID')),
                  );
                }
              },
              child: const Text('Create Stream'),
            ),
          ],
        ),
      ),
    );
  }
}
