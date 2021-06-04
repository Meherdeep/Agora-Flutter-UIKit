import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/src/layout/widgets/disabled_video_widget.dart';
import 'package:agora_flutter_uikit/src/layout/widgets/user_av_state_widget.dart';
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
  final bool? showAVState;
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
    this.showAVState = false,
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

  Widget viewFloat() {
    print(
        "USERS LENGTH: ${widget.client.sessionController.value.users.length}");
    return widget.client.sessionController.value.users.isNotEmpty
        ? Column(
            children: [
              Container(
                height: widget.floatingLayoutContainerHeight ??
                    MediaQuery.of(context).size.height * 0.2,
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
                            padding: widget.floatingLayoutSubViewPadding ??
                                const EdgeInsets.fromLTRB(3, 3, 0, 3),
                            child: Container(
                              width: widget.floatingLayoutContainerWidth ??
                                  MediaQuery.of(context).size.width / 3,
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
                                                    : widget.disabledVideoWidget ??
                                                        DisabledVideoWidget(),
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
                                                          await widget.client
                                                              .sessionController
                                                              .swapUser(
                                                                  index: index);
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
                                                widget.showAVState!
                                                    ? UserAVStateWidget(
                                                        videoDisabled: widget
                                                            .client
                                                            .sessionController
                                                            .value
                                                            .isLocalVideoDisabled,
                                                        muted: widget
                                                            .client
                                                            .sessionController
                                                            .value
                                                            .isLocalUserMuted)
                                                    : Container(),
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
                                                  widget.disabledVideoWidget ??
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
                                                            await widget.client
                                                                .sessionController
                                                                .swapUser(
                                                                    index:
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
                                                  widget.showAVState!
                                                      ? UserAVStateWidget(
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
                                                              .muted)
                                                      : Container(),
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
                                                            await widget.client
                                                                .sessionController
                                                                .swapUser(
                                                                    index:
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
                                                  widget.showAVState!
                                                      ? UserAVStateWidget(
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
                                                              .muted)
                                                      : Container(),
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
                        padding: widget.floatingLayoutMainViewPadding ??
                            const EdgeInsets.fromLTRB(3, 0, 3, 3),
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
                        padding: widget.floatingLayoutMainViewPadding ??
                            const EdgeInsets.fromLTRB(3, 0, 3, 3),
                        child: widget.client.sessionController.value
                                .isLocalVideoDisabled
                            ? widget.disabledVideoWidget ??
                                DisabledVideoWidget()
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
                    children: [
                      Expanded(
                          child: widget.disabledVideoWidget ??
                              DisabledVideoWidget())
                    ],
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
