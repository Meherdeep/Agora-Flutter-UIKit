import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/src/layout/floating_layout.dart';
import 'package:agora_flutter_uikit/src/layout/grid_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AgoraVideoViewer extends StatefulWidget {
  final AgoraClient client;
  final Layout layoutType;
  final double? floatingLayoutContainerHeight;
  final double? floatingLayoutContainerWidth;
  final EdgeInsets? floatingLayoutMainViewPadding;
  final EdgeInsets? floatingLayoutSubViewPadding;
  final bool? enableActiveSpeaker;
  final Widget? disabledVideoWidget;
  final bool? showAVState;
  final bool? showNumberOfUsers;

  const AgoraVideoViewer({
    Key? key,
    required this.client,
    this.layoutType = Layout.grid,
    this.floatingLayoutContainerHeight,
    this.floatingLayoutContainerWidth,
    this.floatingLayoutMainViewPadding,
    this.floatingLayoutSubViewPadding,
    this.enableActiveSpeaker,
    this.disabledVideoWidget,
    this.showAVState = false,
    this.showNumberOfUsers,
  }) : super(key: key);

  @override
  _AgoraVideoViewerState createState() => _AgoraVideoViewerState();
}

class _AgoraVideoViewerState extends State<AgoraVideoViewer> {
  @override
  void initState() {
    super.initState();
    if (widget.enableActiveSpeaker == false) {
      widget.client.sessionController.value = widget
          .client.sessionController.value
          .copyWith(isActiveSpeakerDisabled: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LAYOUT TYPE : ${widget.layoutType}");
    return GestureDetector(
      child: Center(
        child: widget.layoutType == Layout.floating
            ? FloatingLayout(
                client: widget.client,
                disabledVideoWidget: widget.disabledVideoWidget,
                floatingLayoutContainerHeight:
                    widget.floatingLayoutContainerHeight,
                floatingLayoutContainerWidth:
                    widget.floatingLayoutContainerWidth,
                floatingLayoutMainViewPadding:
                    widget.floatingLayoutMainViewPadding,
                floatingLayoutSubViewPadding:
                    widget.floatingLayoutSubViewPadding,
                showAVState: widget.showAVState,
                showNumberOfUsers: widget.showNumberOfUsers,
              )
            : GridLayout(
                client: widget.client,
                showNumberOfUsers: widget.showNumberOfUsers,
              ),
      ),
      onTap: () {},
    );
  }
}
