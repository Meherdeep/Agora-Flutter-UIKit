import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'enums.dart';

class AgoraVideoViewer extends StatefulWidget {
  final Layout layoutType;
  final double floatingLayoutContainerHeight;
  final double floatingLayoutContainerWidth;
  final bool enableActiveSpeaker;

  const AgoraVideoViewer({
    Key key,
    this.layoutType,
    this.floatingLayoutContainerHeight,
    this.floatingLayoutContainerWidth,
    this.enableActiveSpeaker,
  }) : super(key: key);

  @override
  _AgoraVideoViewerState createState() => _AgoraVideoViewerState();
}

class _AgoraVideoViewerState extends State<AgoraVideoViewer> {
  int activeState = 0;
  bool statusCheck = false;

  @override
  void dispose() {
    activeState = 0;
    super.dispose();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(
      RtcLocalView.SurfaceView(
        zOrderMediaOverlay: true,
      ),
    );
    globals.users.value.forEach(
      (uid) => list.add(
        RtcRemoteView.SurfaceView(
          uid: uid,
          zOrderMediaOverlay: true,
        ),
      ),
    );
    return list;
  }

  List<Widget> _getMaxViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    return list;
  }

  /// Helper function to get list of native views
  List<Widget> _getMinViews() {
    final List<StatefulWidget> list = [];
    globals.users.value
        .forEach((uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  Widget _getLocalViews() {
    return RtcLocalView.SurfaceView();
  }

  Widget _getRemoteViews(int uid) {
    return RtcRemoteView.SurfaceView(
      uid: uid,
    );
  }

  /// Video view wrapper
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

  /// Grid Video layout
  Widget viewGrid() {
    final views = _getRenderViews();
    print("VIEWS LENGTH = ${views.length}");
    if (views.length == 1) {
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
              i == (views.length - 1)
                  ? _expandedVideoRow(views.sublist(i, i + 1))
                  : _expandedVideoRow(views.sublist(i, i + 2)),
          ],
        ),
      );
    }
    return Container();
  }

  // Floating Video Layout
  Widget viewFloat() {
    final minViews = _getMinViews();
    final maxViews = _getMaxViews();

    return minViews.length + maxViews.length > 1 &&
            globals.users.value.length > 0
        ? Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(3),
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: globals.users.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width / 3,
                        child: GestureDetector(
                          onTap: () {
                            print("CLICK REGISTERED : $index");
                            print("USER uid : ${globals.users.value[index]}");
                            setState(
                              () {
                                final int temp = globals.maxUid.value;
                                globals.maxUid.value =
                                    globals.users.value[index];
                                globals.users.value.removeAt(index);
                                globals.users.value.add(temp);
                              },
                            );
                            // print("LIST OF VIEWS : $views");
                          },
                          child: Column(
                            children: [
                              globals.users.value[index] ==
                                      globals.localUid.value
                                  ? _videoView(_getLocalViews())
                                  : _videoView(_getRemoteViews(
                                      globals.users.value[index])),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              globals.maxUid.value == globals.localUid.value
                  ? Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                        child: Column(
                          children: [
                            _videoView(maxViews[0]),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            _videoView(_getRemoteViews(globals.maxUid.value))
                          ],
                        ),
                      ),
                    ),
            ],
          )
        : Container(
            child: Column(
              children: <Widget>[_videoView(_getLocalViews())],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: globals.users,
      builder: (BuildContext context, dynamic value, Widget child) {
        return GestureDetector(
          child: Center(
            child: widget.layoutType == null
                ? viewGrid()
                : widget.layoutType == Layout.Grid
                    ? viewGrid()
                    : widget.layoutType == Layout.Floating
                        ? viewFloat()
                        : viewGrid(),
          ),
          onTap: () {
            setState(() {
              globals.isButtonVisible.value = !globals.isButtonVisible.value;
            });
            print(
                "globals.isButtonVisible.value : ${globals.isButtonVisible.value}");
          },
        );
      },
    );
  }
}
