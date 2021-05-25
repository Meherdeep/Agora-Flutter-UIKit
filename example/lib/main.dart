import 'package:flutter/material.dart';
import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AgoraClient client = AgoraClient(
    appId: "<----Insert App ID ---->",
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora Flutter UIKit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client),
              AgoraVideoButtons(client: client),
            ],
          ),
        ),
      ),
    );
  }
}
