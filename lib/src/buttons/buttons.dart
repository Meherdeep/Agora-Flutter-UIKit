import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:flutter/material.dart';

class AgoraVideoButtons extends StatefulWidget {
  final AgoraClient client;
  final List<BuiltInButtons>? enabledButtons;
  final List<Widget>? extraButtons;
  final bool? autoHideButtons;
  // The default auto hide time = 5 seconds
  final int? autoHideButtonTime;
  // Adds a vertical padding to the set of button
  final double? verticalButtonPadding;
  final Alignment? buttonAlignment;
  final Widget? disconnectButtonChild;
  final Widget? muteButtonChild;
  final Widget? switchCameraButtonChild;
  final Widget? disableVideoButtonChild;

  const AgoraVideoButtons({
    Key? key,
    required this.client,
    this.enabledButtons,
    this.extraButtons,
    this.autoHideButtons,
    this.autoHideButtonTime,
    this.verticalButtonPadding,
    this.buttonAlignment,
    this.disconnectButtonChild,
    this.muteButtonChild,
    this.switchCameraButtonChild,
    this.disableVideoButtonChild,
  }) : super(key: key);

  @override
  _AgoraVideoButtonsState createState() => _AgoraVideoButtonsState();
}

class _AgoraVideoButtonsState extends State<AgoraVideoButtons> {
  List<Widget> buttonsEnabled = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: widget.autoHideButtonTime ?? 5),
      () {
        if (this.mounted) {
          setState(() {
            widget.client.callController.toggleVisible();
          });
        }
      },
    );

    Map buttonMap = <BuiltInButtons, Widget>{
      BuiltInButtons.ToggleMic: muteMicButton(),
      BuiltInButtons.CallEnd: disconnectCallButton(),
      BuiltInButtons.SwitchCamera: switchCameraButton(),
      BuiltInButtons.ToggleCamera: disableVideoButton(),
    };

    if (widget.enabledButtons != null) {
      for (var i = 0; i < widget.enabledButtons!.length; i++) {
        for (var j = 0; j < buttonMap.length; j++) {
          if (buttonMap.keys.toList()[j] == widget.enabledButtons![i]) {
            buttonsEnabled.add(buttonMap.values.toList()[j]);
          }
        }
      }
    }
  }

  Widget toolbar(List<Widget>? buttonList) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: widget.verticalButtonPadding == null
          ? const EdgeInsets.symmetric(vertical: 48)
          : EdgeInsets.symmetric(
              vertical: widget.verticalButtonPadding!,
            ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Align(
          alignment: widget.buttonAlignment ?? Alignment.bottomCenter,
          child: widget.enabledButtons == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    muteMicButton(),
                    disconnectCallButton(),
                    switchCameraButton(),
                    disableVideoButton(),
                    if (widget.extraButtons != null)
                      for (var i = 0; i < widget.extraButtons!.length; i++) widget.extraButtons![i]
                  ],
                )
              : Row(
                  children: [
                    for (var i = 0; i < buttonList!.length; i++) buttonList[i],
                    if (widget.extraButtons != null)
                      for (var i = 0; i < widget.extraButtons!.length; i++) widget.extraButtons![i]
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
      onPressed: () => widget.client.callController.switchCamera(),
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
      onPressed: () => widget.client.callController.toggleCamera(),
      child: Icon(
        widget.client.callController.value.isLocalVideoDisabled ? Icons.videocam_off : Icons.videocam,
        color: widget.client.callController.value.isLocalVideoDisabled ? Colors.white : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: widget.client.callController.value.isLocalVideoDisabled ? Colors.blueAccent : Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  void _onCallEnd(BuildContext context) {
    widget.client.callController.endCall();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.client.callController,
        builder: (context, counter, something) {
          return widget.autoHideButtons != null
              ? widget.autoHideButtons!
                  ? Visibility(
                      visible: widget.client.callController.value.visible,
                      child: toolbar(widget.enabledButtons == null ? null : buttonsEnabled),
                    )
                  : toolbar(widget.enabledButtons == null ? null : buttonsEnabled)
              : toolbar(widget.enabledButtons == null ? null : buttonsEnabled);
        });
  }
}
