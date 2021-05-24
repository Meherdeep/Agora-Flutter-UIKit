import 'package:agora_flutter_uikit/models/call_settings.dart';
import 'package:agora_flutter_uikit/models/call_user.dart';
import 'package:agora_flutter_uikit/models/engine_settings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class CallController extends ValueNotifier<CallSettings> {
  CallController() : super(CallSettings(users: []));

  void initializeEngine(String appId) async {
    value = value.copyWith(
      engineSettings: EngineSettings(
        engine: await RtcEngine.createWithConfig(RtcEngineConfig(appId)),
        appId: appId,
      ),
    );
  }

  void createEvents() async {
    value.engineSettings?.engine.setEventHandler(RtcEngineEventHandler(
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

  void endCall() {
    value.engineSettings?.engine.leaveChannel();
    value.engineSettings?.engine.destroy();
    dispose();
  }
}
