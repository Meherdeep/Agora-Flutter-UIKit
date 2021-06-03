import 'package:agora_flutter_uikit/models/agora_user.dart';
import 'package:flutter/material.dart';
import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class GridLayout extends StatefulWidget {
  final AgoraClient client;

  const GridLayout({Key? key, required this.client}) : super(key: key);
  @override
  _GridLayoutState createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(rtc_local_view.SurfaceView());

    widget.client.sessionController.value.users.forEach((AgoraUser user) => list.add(rtc_remote_view.SurfaceView(uid: user.uid)));
    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget viewGrid() {
    final views = _getRenderViews();
    print("VIEWS LENGTH = ${views.length}");
    if (views.isEmpty) {
      return Expanded(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              'Waiting for the host to join',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    } else if (views.length == 1) {
      return Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        ),
      );
    } else if (views.length == 2) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow([views[0]]),
          _expandedVideoRow([views[1]])
        ],
      ));
    } else if (views.length > 2 && views.length % 2 == 0) {
      return Container(
        child: Column(
          children: [
            for (int i = 0; i < views.length; i = i + 2)
              _expandedVideoRow(
                views.sublist(i, i + 2),
              ),
          ],
        ),
      );
    } else if (views.length > 2 && views.length % 2 != 0) {
      return Container(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < views.length; i = i + 2)
              i == (views.length - 1) ? _expandedVideoRow(views.sublist(i, i + 1)) : _expandedVideoRow(views.sublist(i, i + 2)),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.client.sessionController,
      builder: (context, counter, widget) {
        return GestureDetector(
          child: Center(child: viewGrid()),
          onTap: () {},
        );
      },
    );
  }
}
