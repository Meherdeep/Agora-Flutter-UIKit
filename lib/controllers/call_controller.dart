import 'package:agora_flutter_uikit/models/agora_settings.dart';
import 'package:agora_flutter_uikit/models/call_user.dart';
import 'package:agora_flutter_uikit/models/engine_settings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class CallController extends ValueNotifier<AgoraSettings> {
  CallController() : super(AgoraSettings(users: [], isLocalUserMuted: false));

  void initializeEngine(String appId) async {
    value = value.copyWith(
      connectionData: AgoraConnectionData(
        engine: await RtcEngine.createWithConfig(RtcEngineConfig(appId)),
        appId: appId,
      ),
    );
  }

  void createEvents() async {
    value.connectionData?.engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        final info = 'onError: $code';
        print(info);
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        final info = 'onJoinChannel: $channel, uid: $uid';
        print(info);
      },
      leaveChannel: (stats) {
        clearUsers();
      },
      userJoined: (uid, elapsed) {
        final info = 'userJoined: $uid';
        print(info);
        addUser(callUser: CallUser(uid: uid, remote: false, muted: false, videoDisabled: false));
      },
      userOffline: (uid, reason) {
        final info = 'userOffline: $uid , reason: $reason';
        print(info);
        removeUser(uid: uid);
      },
    ));
  }

  void joinVideoChannel({required String channel}) async {
    await value.connectionData?.engine.enableVideo();
    value.connectionData?.engine.joinChannel(null, channel, null, 0);
  }

  void addUser({required CallUser callUser}) {
    value = value.copyWith(users: [...value.users, callUser]);
  }

  void clearUsers() {
    value = value.copyWith(users: []);
  }

  void removeUser({required int uid}) {
    List<CallUser> tempList = <CallUser>[];
    tempList = value.users;
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].uid == uid) {
        tempList.remove(tempList[i]);
      }
    }
    value = value.copyWith(users: tempList);
  }

  void toggleMute() {
    value = value.copyWith(isLocalUserMuted: !value.isLocalUserMuted);
    value.connectionData?.engine.muteLocalAudioStream(value.isLocalUserMuted);
  }

  void endCall() {
    value.connectionData?.engine.leaveChannel();
    value.connectionData?.engine.destroy();
    dispose();
  }
}
