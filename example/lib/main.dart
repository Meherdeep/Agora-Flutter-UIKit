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
    agoraConnectionData: AgoraConnectionData(
        appId: "<--Add your app id here-->", channelName: "test"),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
    agoraChannelData: AgoraChannelData(
      channelProfile: ChannelProfile.LiveBroadcasting,
      clientRole: ClientRole.Broadcaster,
    ),
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
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                showAVState: true,
              ),
              AgoraVideoButtons(client: client),
            ],
          ),
        ),
      ),
    );
  }
}
