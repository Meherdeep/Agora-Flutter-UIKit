import 'package:flutter/material.dart';

import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;

class AgoraVideoButtons extends StatefulWidget {
  final List<BuiltInButtons> enabledButtons;
  final List<Widget> extraButtons;
  final bool autoHideButtons;
  // The default auto hide time = 5 seconds
  final int autoHideButtonTime;
  // Adds a vertical padding to the set of button
  final double bottomPadding;
  final Alignment buttonAlignment;
  final Widget disconnectButtonChild;
  final Widget muteButtonChild;
  final Widget switchCameraButtonChild;
  final Widget disableVideoButtonChild;

  const AgoraVideoButtons(
      {Key key,
      this.enabledButtons,
      this.extraButtons,
      this.autoHideButtons,
      this.autoHideButtonTime,
      this.bottomPadding,
      this.buttonAlignment,
      this.disconnectButtonChild,
      this.muteButtonChild,
      this.switchCameraButtonChild,
      this.disableVideoButtonChild})
      : super(key: key);

  @override
  _AgoraVideoButtonsState createState() => _AgoraVideoButtonsState();
}

class _AgoraVideoButtonsState extends State<AgoraVideoButtons> {
  bool muted = false;
  bool disabledVideo = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      widget.autoHideButtonTime == null
          ? const Duration(seconds: 5)
          : Duration(seconds: widget.autoHideButtonTime),
      () {
        if (this.mounted) {
          setState(() {
            globals.visible.value = !globals.visible.value;
          });
        }
      },
    );
    globals.isButtonVisible.addListener(() {
      if (globals.isButtonVisible.value) {
        setState(() {
          globals.visible.value = !globals.visible.value;
        });
        Future.delayed(
          widget.autoHideButtonTime == null
              ? const Duration(seconds: 5)
              : Duration(seconds: widget.autoHideButtonTime),
          () {
            setState(() {
              globals.visible.value = !globals.visible.value;
              globals.isButtonVisible.value = !globals.isButtonVisible.value;
            });
            print("globals.visible.value : ${globals.visible.value}");
          },
        );
      }
    });
  }

  Widget toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: widget.bottomPadding == null
          ? const EdgeInsets.symmetric(vertical: 48)
          : EdgeInsets.symmetric(
              vertical: widget.bottomPadding,
            ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Align(
          alignment: widget.buttonAlignment == null
              ? Alignment.bottomCenter
              : widget.buttonAlignment,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              muteMicButton(),
              disconnectCallButton(),
              switchCameraButton(),
              disableVideoButton(),
              if (widget.extraButtons != null)
                for (var i = 0; i < widget.extraButtons.length; i++)
                  widget.extraButtons[i]
            ],
          ),
        ),
      ),
    );
  }

  Widget muteMicButton() {
    return widget.muteButtonChild != null
        ? RawMaterialButton(
            onPressed: _onToggleMute,
            child: widget.muteButtonChild,
          )
        : RawMaterialButton(
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
    return widget.disconnectButtonChild != null
        ? RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: widget.disconnectButtonChild,
          )
        : RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(Icons.call_end, color: Colors.white, size: 35),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          );
  }

  Widget switchCameraButton() {
    return widget.switchCameraButtonChild != null
        ? RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: widget.switchCameraButtonChild,
          )
        : RawMaterialButton(
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
    return widget.disableVideoButtonChild != null
        ? RawMaterialButton(
            onPressed: _onToggleCamera,
            child: widget.disableVideoButtonChild,
          )
        : RawMaterialButton(
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
    await globals.engine.leaveChannel();
    await globals.engine.destroy();
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
      globals.isLocalUserMuted.value = !globals.isLocalUserMuted.value;
    });
    globals.engine.muteLocalAudioStream(muted);
  }

  void _onToggleCamera() {
    setState(() {
      disabledVideo = !disabledVideo;
      globals.isLocalVideoDisabled.value = !globals.isLocalVideoDisabled.value;
    });
    globals.engine.muteLocalVideoStream(disabledVideo);
    if (disabledVideo) {
      globals.engine.disableVideo();
    } else {
      globals.engine.enableVideo();
    }
  }

  void _onSwitchCamera() {
    globals.engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return widget.autoHideButtons != null
        ? widget.autoHideButtons
            ? Visibility(
                visible: globals.visible.value,
                child: toolbar(),
              )
            : toolbar()
        : toolbar();
  }
}
