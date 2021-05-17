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
  @override
  void initState() {
    super.initState();
    AgoraFlutterUIKit(
      appId: '<----APP ID---->',
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
      userRole: ClientRole.Broadcaster,
      channelName: 'test',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                layoutType: Layout.Floating,
                enableActiveSpeaker: false,
              ),
              AgoraVideoButtons()
            ],
          ),
        ),
      ),
    );
  }
}
