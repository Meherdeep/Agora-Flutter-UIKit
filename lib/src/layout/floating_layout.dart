import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/models/agora_user.dart';
import 'package:agora_flutter_uikit/src/layout/widgets/disabled_video_widget.dart';
import 'package:agora_flutter_uikit/src/layout/widgets/remote_av_state_widget.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class FloatingLayout extends StatefulWidget {
  final AgoraClient client;
  final double? floatingLayoutContainerHeight;
  final double? floatingLayoutContainerWidth;
  final EdgeInsets? floatingLayoutMainViewPadding;
  final EdgeInsets? floatingLayoutSubViewPadding;
  final bool? enableActiveSpeaker;
  final Widget? disabledVideoWidget;
  final bool? showRemoteAVState;
  final bool? showLocalAVState;
  final bool? showNumberOfUsers;

  const FloatingLayout({
    Key? key,
    required this.client,
    this.floatingLayoutContainerHeight,
    this.floatingLayoutContainerWidth,
    this.floatingLayoutMainViewPadding,
    this.floatingLayoutSubViewPadding,
    this.enableActiveSpeaker,
    this.disabledVideoWidget,
    this.showRemoteAVState,
    this.showLocalAVState,
    this.showNumberOfUsers,
  }) : super(key: key);

  @override
  _FloatingLayoutState createState() => _FloatingLayoutState();
}

class _FloatingLayoutState extends State<FloatingLayout> {
  Widget _getLocalViews() {
    return rtc_local_view.SurfaceView();
  }

  Widget _getRemoteViews(int uid) {
    return rtc_remote_view.SurfaceView(
      uid: uid,
    );
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
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
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
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
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
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

  Widget viewFloat() {
    print(
        "USERS LENGTH: ${widget.client.sessionController.value.users.length}");
    return widget.client.sessionController.value.users.isNotEmpty
        ? Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.client.sessionController.value.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return widget.client.sessionController.value.users[index]
                                .uid !=
                            widget.client.sessionController.value.maxUid
                        ? Padding(
                            key: Key('$index'),
                            padding: const EdgeInsets.fromLTRB(3, 3, 0, 3),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Column(
                                children: [
                                  widget.client.sessionController.value
                                              .users[index].uid ==
                                          widget.client.sessionController.value
                                              .localUid
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
                                                !widget
                                                        .client
                                                        .sessionController
                                                        .value
                                                        .isLocalVideoDisabled
                                                    ? Column(
                                                        children: [
                                                          _videoView(
                                                              _getLocalViews()),
                                                        ],
                                                      )
                                                    : DisabledVideoWidget(),
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await _pinView(index);
                                                        },
                                                        child: Container(
                                                          height: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue,
                                                            shape:
                                                                BoxShape.circle,
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
                                                localAVStateWidget()
                                              ],
                                            ),
                                          ),
                                        )
                                      : widget.client.sessionController.value
                                              .users[index].videoDisabled
                                          ? Expanded(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: Colors.black,
                                                  ),
                                                  DisabledVideoWidget(),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await _pinView(
                                                                index);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Icon(
                                                              Icons
                                                                  .push_pin_rounded,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  RemoteAVState(
                                                      videoDisabled: widget
                                                          .client
                                                          .sessionController
                                                          .value
                                                          .users[index]
                                                          .videoDisabled,
                                                      muted: widget
                                                          .client
                                                          .sessionController
                                                          .value
                                                          .users[index]
                                                          .muted),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      _videoView(
                                                          _getRemoteViews(widget
                                                              .client
                                                              .sessionController
                                                              .value
                                                              .users[index]
                                                              .uid)),
                                                    ],
                                                  ),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await _pinView(
                                                                index);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Icon(
                                                              Icons
                                                                  .push_pin_rounded,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  RemoteAVState(
                                                      videoDisabled: widget
                                                          .client
                                                          .sessionController
                                                          .value
                                                          .users[index]
                                                          .videoDisabled,
                                                      muted: widget
                                                          .client
                                                          .sessionController
                                                          .value
                                                          .users[index]
                                                          .muted),
                                                ],
                                              ),
                                            ),
                                ],
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
              ),
              widget.client.sessionController.value.maxUid !=
                      widget.client.sessionController.value.localUid
                  ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
                        child: Column(
                          children: [
                            _videoView(_getRemoteViews(
                                widget.client.sessionController.value.maxUid))
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
                        child: widget.client.sessionController.value
                                .isLocalVideoDisabled
                            ? DisabledVideoWidget()
                            : Stack(
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
                    ),
            ],
          )
        : widget.client.sessionController.value.clientRole ==
                ClientRole.Broadcaster
            ? widget.client.sessionController.value.isLocalVideoDisabled
                ? Column(
                    children: [Expanded(child: DisabledVideoWidget())],
                  )
                : Container(
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
                    ),
                  ),
                ],
              );
  }

  Future<void> _pinView(int index) async {
    setState(
      () {
        final int oldMaxUid = widget.client.sessionController.value.maxUid;
        final int newMaxUid =
            widget.client.sessionController.value.users[index].uid;
        widget.client.sessionController.value =
            widget.client.sessionController.value.copyWith(maxUid: newMaxUid);
        List<AgoraUser> tempList = <AgoraUser>[];
        tempList = widget.client.sessionController.value.users;
        for (int i = 0; i < tempList.length; i++) {
          if (tempList[i].uid == newMaxUid) {
            tempList.remove(tempList[i]);
          }
        }
        widget.client.sessionController.value =
            widget.client.sessionController.value.copyWith(
          users: [
            ...tempList,
            AgoraUser(
                uid: oldMaxUid,
                remote:
                    oldMaxUid == widget.client.sessionController.value.localUid,
                muted: false,
                videoDisabled: false,
                clientRole: ClientRole.Broadcaster),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.client.sessionController,
      builder: (context, counter, widget) {
        return GestureDetector(
          child: Center(child: viewFloat()),
          onTap: () {},
        );
      },
    );
  }
}
