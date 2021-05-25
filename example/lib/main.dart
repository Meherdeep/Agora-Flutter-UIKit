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
      agoraConnectionData: AgoraConnectionData(
        appId: '<--Agora App Id-->',
        channelName: 'test',
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
      agoraSettings: AgoraSettings(
        channelProfile: ChannelProfile.LiveBroadcasting,
        userRole: ClientRole.Audience,
      ),
    );
  }

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
            children: [AgoraVideoViewer(), AgoraVideoButtons()],
          ),
        ),
      ),
    );
  }
}
