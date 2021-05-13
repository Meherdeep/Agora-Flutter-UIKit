import 'package:agora_flutter_uikit/agora_flutter_uikit.dart';
import 'package:agora_flutter_uikit/global/global_variable.dart';
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
          maxUid.value = uid;
          localUid.value = uid;
        });
      },
      leaveChannel: (stats) {
        setState(() {
          users.value = [];
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          users.value = [...users.value, uid];
          print(info);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          var tempList = <dynamic>[];
          tempList = users.value;
          tempList.remove(uid);
          users.value = [...tempList];
          if (maxUid.value == uid) {
            var temp2List = <dynamic>[];
            temp2List = users.value;
            temp2List.remove(localUid.value);
            maxUid.value = localUid.value;
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
      // audioVolumeIndication: (speakers, totalVolume) {
      //   print("Speakers: $speakers with total volume : $totalVolume");
      // },
      // activeSpeaker: (uid) {
      //   print("Active speaker = $uid");
      //   setState(() {
      //     final int temp = maxUid.value;
      //     maxUid.value = speakerUid.value;
      //     users.value.removeWhere((element) => element == speakerUid.value);
      //     users.value.add(temp);
      //   });
      // },
    ));
  }
}
