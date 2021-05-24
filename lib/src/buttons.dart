import 'package:agora_flutter_uikit/controllers/engine_controller.dart';
import 'package:flutter/material.dart';
import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;

class AgoraVideoButtons extends StatefulWidget {
  const AgoraVideoButtons({
    Key? key,
  }) : super(key: key);

  @override
  _AgoraVideoButtonsState createState() => _AgoraVideoButtonsState();
}

class _AgoraVideoButtonsState extends State<AgoraVideoButtons> {
  bool muted = false;
  bool disabledVideo = false;

  @override
  void initState() {
    super.initState();

    globals.isButtonVisible.addListener(() {
      if (globals.isButtonVisible.value) {
        setState(() {
          globals.visible.value = !globals.visible.value;
        });
      }
    });
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
      onPressed: _onToggleMute,
      child: Icon(
        muted ? Icons.mic_off : Icons.mic,
        color: muted ? Colors.white : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: muted ? Colors.blueAccent : Colors.white,
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

  void _onCallEnd(BuildContext context) async {
    await engineController.value?.engine.leaveChannel();
    await engineController.value?.engine.destroy();
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
      globals.isLocalUserMuted.value = !globals.isLocalUserMuted.value;
    });
    engineController.value?.engine.muteLocalAudioStream(muted);
  }

  void _onToggleCamera() {
    setState(() {
      disabledVideo = !disabledVideo;
      globals.isLocalVideoDisabled.value = !globals.isLocalVideoDisabled.value;
    });
    engineController.value?.engine.muteLocalVideoStream(disabledVideo);
  }

  void _onSwitchCamera() {
    engineController.value?.engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return toolbar();
  }
}
