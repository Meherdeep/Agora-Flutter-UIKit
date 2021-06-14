import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

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
      appId: "<--Add your App Id here-->",
      channelName: "test",
    ),
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
          title: const Text('Agora UIKit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                showAVState: true,
                enableActiveSpeaker: false,
              ),
              Positioned.fill(
                child: Align(
                  child: AgoraVideoButtons(
                    client: client,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
