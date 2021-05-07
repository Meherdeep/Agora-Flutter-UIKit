import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'enums.dart';

class AgoraVideoViewer extends StatefulWidget {
  final Layout layoutType;
  final double floatingLayoutContainerHeight;
  final double floatingLayoutContainerWidth;

  const AgoraVideoViewer({
    Key key,
    this.layoutType,
    this.floatingLayoutContainerHeight,
    this.floatingLayoutContainerWidth,
  }) : super(key: key);

  @override
  _AgoraVideoViewerState createState() => _AgoraVideoViewerState();
}

class _AgoraVideoViewerState extends State<AgoraVideoViewer> {
  var userList = <int>[];
  int activeState = 0;

  ScrollController scrollController = ScrollController(
    initialScrollOffset: 1, // or whatever offset you wish
    keepScrollOffset: true,
  );

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    globals.users.value
        .forEach((uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
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
    var views = _getRenderViews();
    print("VIEWS: $views");

    return views.length > 1
        ? Column(
            children: [
              Container(
                padding: EdgeInsets.all(3),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomLeft,
                child: ReorderableListView(
                  scrollDirection: Axis.horizontal,
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final Widget item = views.removeAt(oldIndex);
                      views.insert(newIndex, item);
                    });
                  },
                  children: <Widget>[
                    for (var index = 1; index < views.length; index++)
                      Container(
                        padding: EdgeInsets.only(right: 3),
                        key: Key('$index'),
                        height: widget.floatingLayoutContainerHeight == null
                            ? MediaQuery.of(context).size.height * 0.2
                            : widget.floatingLayoutContainerHeight,
                        width: widget.floatingLayoutContainerWidth == null
                            ? MediaQuery.of(context).size.width / 3
                            : widget.floatingLayoutContainerWidth,
                        child: Column(
                          children: [
                            _videoView(views[index]),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                  child: Column(
                    children: [
                      _videoView(views[activeState]),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
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
