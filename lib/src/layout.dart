import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/controllers/call_controller.dart';
import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:agora_flutter_uikit/models/call_user.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'enums.dart';

class AgoraVideoViewer extends StatefulWidget {
  const AgoraVideoViewer({
    Key? key,
  }) : super(key: key);

  @override
  _AgoraVideoViewerState createState() => _AgoraVideoViewerState();
}

class _AgoraVideoViewerState extends State<AgoraVideoViewer> {
  int activeState = 0;
  bool statusCheck = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    activeState = 0;
    super.dispose();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (globals.clientRole.value == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    callController.value.users.forEach((CallUser user) => list.add(RtcRemoteView.SurfaceView(uid: user.uid)));
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
    if (views.length == 0) {
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

  // Floating Video Layout
  Widget viewFloat() {
    return globals.users.value.length > 0
        ? Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: globals.users.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      key: Key('$index'),
                      padding: const EdgeInsets.fromLTRB(3, 3, 0, 3),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          children: [
                            globals.users.value[index] == globals.localUid.value
                                ? Expanded(
                                    child: Container(
                                      color: Colors.black,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Text(
                                              'Local User',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              _videoView(_getLocalViews()),
                                            ],
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await _pinView(index);
                                                  },
                                                  child: Container(
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.network(
                                                      'https://i.ibb.co/JrJ7R3w/unpin-icon.png',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : globals.videoDisabledUsers.value.contains(globals.users.value[index])
                                    ? Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              color: Colors.black,
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await _pinView(index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Icon(
                                                        Icons.push_pin_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                _videoView(_getRemoteViews(globals.users.value[index])),
                                              ],
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await _pinView(index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Icon(
                                                        Icons.push_pin_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                          ],
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
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.black,
                              child: Center(
                                child: Text(
                                  'Local User',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                _videoView(_getLocalViews()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                        child: Column(
                          children: [_videoView(_getRemoteViews(globals.maxUid.value))],
                        ),
                      ),
                    ),
            ],
          )
        : globals.clientRole.value == ClientRole.Broadcaster
            ? Container(
                child: Column(
                  children: <Widget>[_videoView(_getLocalViews())],
                ),
              )
            : Column(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'Waiting for the host to join.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )),
                ],
              );
  }

  Widget localAVStateWidget() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: globals.isLocalVideoDisabled.value ? Colors.blue : Colors.white,
                shape: BoxShape.circle,
              ),
              child: globals.isLocalVideoDisabled.value
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.videocam_off,
                        color: Colors.white,
                        size: 15,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.videocam,
                        color: Colors.blue,
                        size: 15,
                      ),
                    ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              decoration: BoxDecoration(
                color: globals.isLocalUserMuted.value ? Colors.blue : Colors.white,
                shape: BoxShape.circle,
              ),
              child: globals.isLocalUserMuted.value
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.mic_off,
                        color: Colors.white,
                        size: 15,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.mic,
                        color: Colors.blue,
                        size: 15,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget remoteAVStateWidget(int index) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: globals.videoDisabledUsers.value.contains(globals.users.value[index]) ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: globals.videoDisabledUsers.value.contains(globals.users.value[index])
                    ? Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                          size: 15,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.videocam,
                          color: Colors.blue,
                          size: 15,
                        ),
                      ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: globals.mutedUsers.value.contains(globals.users.value[index]) ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: globals.mutedUsers.value.contains(globals.users.value[index])
                    ? Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.mic_off,
                          color: Colors.white,
                          size: 15,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.mic,
                          color: Colors.blue,
                          size: 15,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget disabledVideoWidget() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: Image.network(
        'https://i.ibb.co/q5RysSV/image.png',
      ),
    );
  }

  Future<void> _pinView(int index) async {
    setState(
      () {
        if (globals.users.value[index] == globals.localUid.value) {
          globals.isActiveSpeakerEnabled = true;
        } else {
          globals.isActiveSpeakerEnabled = false;
        }
        final int temp = globals.maxUid.value;
        globals.maxUid.value = globals.users.value[index];
        globals.users.value.removeAt(index);
        globals.users.value.insert(index, temp);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: callController,
      builder: (context, counter, widget) {
        return GestureDetector(
          child: Center(child: viewGrid()),
          onTap: () {
            setState(() {
              globals.isButtonVisible.value = !globals.isButtonVisible.value;
            });
            print("globals.isButtonVisible.value : ${globals.isButtonVisible.value}");
          },
        );
      },
    );
  }
}
