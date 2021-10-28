import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class HostControls extends StatefulWidget {
  final AgoraClient client;
  final bool videoDisabled;
  final bool muted;
  final int index;

  const HostControls({
    Key? key,
    required this.videoDisabled,
    required this.muted,
    required this.client,
    required this.index,
  }) : super(key: key);

  @override
  _HostControlsState createState() => _HostControlsState();
}

class _HostControlsState extends State<HostControls> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      enableFeedback: true,
      tooltip: 'Host Controls',
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              widget.client.sessionController.askForUserMic(
                  index: widget.index, isMicEnabled: widget.muted);
            },
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    widget.muted ? Icons.mic_off : Icons.mic,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  widget.muted
                      ? Text(
                          'Ask User to unmute the mic',
                          style: TextStyle(fontSize: 15),
                        )
                      : Text(
                          'Ask User to mute the mic',
                          style: TextStyle(fontSize: 15),
                        )
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              widget.client.sessionController.askForUserCamera(
                  index: widget.index, isCameraEnabled: !widget.videoDisabled);
            },
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    widget.videoDisabled ? Icons.videocam_off : Icons.videocam,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  widget.videoDisabled
                      ? Text(
                          'Ask User to enable the video',
                          style: TextStyle(fontSize: 15),
                        )
                      : Text(
                          'Ask User to disable the video',
                          style: TextStyle(fontSize: 15),
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
