import 'dart:async';

import 'package:agora_flutter_uikit/controllers/call_controller.dart';
import 'package:agora_flutter_uikit/controllers/engine_controller.dart';
import 'package:agora_flutter_uikit/models/call_user.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraFlutterUIKit {
  static const MethodChannel _channel = const MethodChannel('agora_flutter_uikit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  AgoraFlutterUIKit({
    required String appId,
    required List<Permission> enabledPermission,
  }) {
    _initAgoraRtcEngine(
      appId: appId,
      enabledPermission: enabledPermission,
    );
    print('APP ID: $appId');
  }

  Future<void> _initAgoraRtcEngine({
    required String appId,
    required List<Permission> enabledPermission,
  }) async {
    try {
      engineController.initializeEngine(appId);
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }

    await enabledPermission.request();

    await engineController.value?.engine.setChannelProfile(ChannelProfile.LiveBroadcasting);

    await engineController.value?.engine.setClientRole(ClientRole.Broadcaster);

    engineController.value?.engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        final info = 'onError: $code';
        print(info);
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        final info = 'onJoinChannel: $channel, uid: $uid';
        print(info);
      },
      leaveChannel: (stats) {
        callController.clearUsers();
      },
      userJoined: (uid, elapsed) {
        final info = 'userJoined: $uid';
        print(info);
        callController.addUser(callUser: CallUser(uid: uid, remote: false, muted: false, videoDisabled: false));
      },
      userOffline: (uid, reason) {
        final info = 'userOffline: $uid , reason: $reason';
        print(info);
        callController.removeUser(uid: uid);
      },
    ));

    await engineController.value?.engine.enableVideo();
    engineController.value?.engine.joinChannel(null, "tadas", null, 0);
  }
}
