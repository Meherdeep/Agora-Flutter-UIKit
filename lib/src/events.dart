import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:agora_flutter_uikit/src/tokens.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_super_state/flutter_super_state.dart';

class AgoraEvents extends StoreModule {
  AgoraEvents(Store store, RtcEngine engine, String channelName, String baseUrl)
      : super(store) {
    addAgoraEventHandlers(engine, channelName, baseUrl);
  }

  void addAgoraEventHandlers(
      RtcEngine engine, String channelName, String baseUrl) {
    engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          print(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          print(info);
          globals.maxUid.value = uid;
          globals.localUid.value = uid;
        });
      },
      leaveChannel: (stats) {
        setState(() {
          globals.users.value = [];
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          globals.users.value = [...globals.users.value, uid];
          print(info);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          var tempList = <dynamic>[];
          tempList = globals.users.value;
          tempList.remove(uid);
          globals.users.value = [...tempList];
          if (globals.maxUid.value == uid) {
            var temp2List = <dynamic>[];
            temp2List = globals.users.value;
            temp2List.remove(globals.localUid.value);
            globals.maxUid.value = globals.localUid.value;
          }
        });
      },
      tokenPrivilegeWillExpire: (token) async {
        await store.getModule<AgoraTokens>().getToken(baseUrl, channelName);
        await engine.renewToken(token);
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          print(info);
        });
      },
      remoteVideoStateChanged: (uid, state, reason, elapsed) {
        print("REMOTE VIDEO MUTED FOR USER : $uid , state: $state");
        if (state == VideoRemoteState.Stopped) {
          setState(() {
            globals.videoDisabledUsers.value = [
              ...globals.videoDisabledUsers.value,
              uid
            ];
          });
        } else if (state == VideoRemoteState.Decoding ||
            reason == VideoRemoteStateReason.RemoteUnmuted) {
          if (globals.videoDisabledUsers.value.contains(uid)) {
            setState(() {
              var tempList = [];
              tempList = globals.videoDisabledUsers.value;
              tempList.remove(uid);
              globals.videoDisabledUsers.value = [...tempList];
            });
          }
        }
      },
      remoteAudioStateChanged: (uid, state, reason, elapsed) {
        print("REMOTE AUDIO MUTED FOR USER : $uid , state: $state");
        if (state == AudioRemoteState.Stopped) {
          setState(() {
            globals.mutedUsers.value = [...globals.mutedUsers.value, uid];
          });
        } else if (state == AudioRemoteState.Decoding &&
            globals.mutedUsers.value.contains(uid)) {
          setState(() {
            var tempList = <dynamic>[];
            tempList = globals.mutedUsers.value;
            tempList.removeWhere((element) => element == uid);
            globals.mutedUsers.value = [...tempList];
          });
        }
      },
      activeSpeaker: (uid) {
        print("Active speaker = $uid");
        if (globals.isActiveSpeakerEnabled && globals.isVideoUnPinned) {
          setState(() {
            globals.speakerUid.value = uid;
            final int temp = globals.maxUid.value;
            globals.maxUid.value = globals.speakerUid.value;
            var tempList = <dynamic>[];
            tempList = globals.users.value;
            tempList
                .removeWhere((element) => element == globals.speakerUid.value);
            globals.users.value = [...tempList];
            globals.users.value = [...globals.users.value, temp];
          });
        }
      },
    ));
  }
}
