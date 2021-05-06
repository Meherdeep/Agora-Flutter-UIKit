import 'package:flutter/material.dart';

import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;

class AgoraVideoButtons extends StatefulWidget {
  final List<BuiltInButtons> enabledButtons;
  final List<Widget> extraButtons;
  final bool autoHideButtons;
  // The default auto hide time = 5 seconds
  final int autoHideButtonTime;
  final Color muteButtonColor;
  final Color unmuteButtonColor;
  final Color muteButtonBgColor;
  final Color unmuteButtonBgColor;
  final Color enableVideoColor;
  final Color disableVideoColor;
  final Color enableVideoBgColor;
  final Color disableVideoBgColor;
  // Default button size = 20.0
  final double buttonSize;
  // Default disconnect button size = 20.0
  final double disconnectButtonSize;
  // Adds a vertical padding to the set of button
  final double bottomPadding;
  final Alignment buttonAlignment;

  const AgoraVideoButtons(
      {Key key,
      this.enabledButtons,
      this.extraButtons,
      this.autoHideButtons,
      this.autoHideButtonTime,
      this.muteButtonColor,
      this.unmuteButtonColor,
      this.muteButtonBgColor,
      this.unmuteButtonBgColor,
      this.enableVideoColor,
      this.disableVideoColor,
      this.enableVideoBgColor,
      this.disableVideoBgColor,
      this.buttonSize,
      this.disconnectButtonSize,
      this.bottomPadding,
      this.buttonAlignment})
      : super(key: key);

  @override
  _AgoraVideoButtonsState createState() => _AgoraVideoButtonsState();
}

class _AgoraVideoButtonsState extends State<AgoraVideoButtons> {
  bool muted = false;

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
    return RawMaterialButton(
      onPressed: _onToggleMute,
      child: Icon(
        muted ? Icons.mic_off : Icons.mic,
        color: muted
            ? widget.muteButtonColor == null
                ? Colors.white
                : widget.muteButtonColor
            : widget.unmuteButtonColor == null
                ? Colors.blueAccent
                : widget.unmuteButtonColor,
        size: widget.buttonSize == null ? 20.0 : widget.buttonSize,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: muted
          ? widget.muteButtonBgColor == null
              ? Colors.blueAccent
              : widget.muteButtonBgColor
          : widget.unmuteButtonBgColor == null
              ? Colors.white
              : widget.unmuteButtonBgColor,
      padding: const EdgeInsets.all(12.0),
    );
  }

  Widget disconnectCallButton() {
    return RawMaterialButton(
      onPressed: () => _onCallEnd(context),
      child: Icon(
        Icons.call_end,
        color: Colors.white,
        size: widget.disconnectButtonSize == null
            ? 35.0
            : widget.disconnectButtonSize,
      ),
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
        size: widget.buttonSize == null ? 20.0 : widget.buttonSize,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    globals.engine.muteLocalAudioStream(muted);
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
