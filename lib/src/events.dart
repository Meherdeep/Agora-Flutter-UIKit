import 'package:agora_flutter_uikit/global/global_variable.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_super_state/flutter_super_state.dart';

class AgoraEvents extends StoreModule {
  AgoraEvents(Store store, RtcEngine engine) : super(store) {
    addAgoraEventHandlers(engine);
  }

  void addAgoraEventHandlers(RtcEngine engine) {
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
          // print("Updated user list: ${users.value}");
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
        });
        print("Updated user leftlist: ${users.value}");
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          print(info);
        });
      },
    ));
  }
}
