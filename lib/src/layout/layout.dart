import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/models/agora_user.dart';
import 'package:agora_flutter_uikit/src/layout/floating_layout.dart';
import 'package:agora_flutter_uikit/src/layout/grid_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class AgoraVideoViewer extends StatefulWidget {
  final AgoraClient client;
  final Layout layoutType;
  const AgoraVideoViewer({
    required this.client,
    this.layoutType = Layout.grid,
    Key? key,
  }) : super(key: key);

  @override
  _AgoraVideoViewerState createState() => _AgoraVideoViewerState();
}

class _AgoraVideoViewerState extends State<AgoraVideoViewer> {
  @override
  void initState() {
    super.initState();
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
              )
            : GridLayout(
                client: widget.client,
              ),
      ),
      onTap: () {},
    );
  }
}
