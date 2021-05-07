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
  final agView = AgoraFlutterUIKit(
    appId: '<--Add your App Id Here--->',
    enabledPermission: [EnabledPermission.camera, EnabledPermission.microphone],
    channelName: 'test',
  );

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
              ),
              AgoraVideoButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
