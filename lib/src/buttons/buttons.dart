import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:flutter/material.dart';

class AgoraVideoButtons extends StatefulWidget {
  final AgoraClient client;
  const AgoraVideoButtons({
    required this.client,
    Key? key,
  }) : super(key: key);

  @override
  _AgoraVideoButtonsState createState() => _AgoraVideoButtonsState();
}

class _AgoraVideoButtonsState extends State<AgoraVideoButtons> {
  bool disabledVideo = false;

  @override
  void initState() {
    super.initState();
  }

  Widget toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              muteMicButton(),
              disconnectCallButton(),
              switchCameraButton(),
              disableVideoButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget muteMicButton() {
    return RawMaterialButton(
      onPressed: () => widget.client.callController.toggleMute(),
      child: Icon(
        widget.client.callController.value.isLocalUserMuted ? Icons.mic_off : Icons.mic,
        color: widget.client.callController.value.isLocalUserMuted ? Colors.white : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: widget.client.callController.value.isLocalUserMuted ? Colors.blueAccent : Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  Widget disconnectCallButton() {
    return RawMaterialButton(
      onPressed: () => _onCallEnd(context),
      child: Icon(Icons.call_end, color: Colors.white, size: 35),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.redAccent,
      padding: const EdgeInsets.all(15.0),
    );
  }

  Widget switchCameraButton() {
    return RawMaterialButton(
      onPressed: _onSwitchCamera,
      child: Icon(
        Icons.switch_camera,
        color: Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  Widget disableVideoButton() {
    return RawMaterialButton(
      onPressed: _onToggleCamera,
      child: Icon(
        disabledVideo ? Icons.videocam_off : Icons.videocam,
        color: disabledVideo ? Colors.white : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: disabledVideo ? Colors.blueAccent : Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  void _onCallEnd(BuildContext context) {
    widget.client.callController.endCall();
    Navigator.pop(context);
  }

  void _onToggleCamera() {
    // setState(() {
    //   disabledVideo = !disabledVideo;
    //   globals.isLocalVideoDisabled.value = !globals.isLocalVideoDisabled.value;
    // });
    // engineController.value?.engine.muteLocalVideoStream(disabledVideo);
  }

  void _onSwitchCamera() {
    // engineController.value?.engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return toolbar();
  }
}
