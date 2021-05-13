import 'dart:async';

import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:agora_flutter_uikit/src/tokens.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_super_state/flutter_super_state.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_flutter_uikit/src/events.dart';

class AgoraFlutterUIKit {
  static const MethodChannel _channel =
      const MethodChannel('agora_flutter_uikit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  final store = Store();

  AgoraFlutterUIKit({
    @required String appId,
    @required String channelName,
    AreaCode areaCode,
    String token,
    String tokenUrl,
    List<Permission> enabledPermission,
    ChannelProfile channelProfile,
    ClientRole userRole,
    VideoEncoderConfiguration videoEncoderConfiguration,
  }) {
    handleCameraAndMicPermission(enabledPermission);
    _initAgoraRtcEngine(
      appId: appId,
      channelName: channelName,
      tempToken: token,
      tokenUrl: tokenUrl,
      areaCode: areaCode,
      channelProfile: channelProfile,
      userRole: userRole,
      videoEncoderConfiguration: videoEncoderConfiguration,
    );
  }

  Future<void> _initAgoraRtcEngine({
    @required String appId,
    @required String channelName,
    String tempToken,
    String tokenUrl,
    AreaCode areaCode,
    ChannelProfile channelProfile,
    ClientRole userRole,
    VideoEncoderConfiguration videoEncoderConfiguration,
  }) async {
    try {
      if (areaCode != null) {
        globals.engine = await RtcEngine.createWithConfig(
          RtcEngineConfig(appId, areaCode: areaCode),
        );
      } else {
        globals.engine = await RtcEngine.createWithConfig(
          RtcEngineConfig(appId),
        );
      }
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }
    await globals.engine.enableVideo();
    AgoraEvents(store, globals.engine, channelName, tokenUrl);
    if (tokenUrl != null) {
      AgoraTokens(store: store, channelName: channelName, baseUrl: tokenUrl);
    }
    if (channelProfile != null) {
      if (channelProfile == ChannelProfile.Communication) {
        await globals.engine.setChannelProfile(ChannelProfile.Communication);
      } else {
        await globals.engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      }
    } else {
      await globals.engine.setChannelProfile(ChannelProfile.Communication);
    }
    if (userRole == ClientRole.Broadcaster || userRole == ClientRole.Audience) {
      if (channelProfile == ChannelProfile.LiveBroadcasting) {
        await globals.engine.setClientRole(userRole == ClientRole.Broadcaster
            ? ClientRole.Broadcaster
            : ClientRole.Audience);
      } else {
        print("You can set the user role only for live broadcasting mode");
      }
    }
    await globals.engine.enableAudioVolumeIndication(200, 3, true);
    store
        .getModule<AgoraEvents>()
        .addAgoraEventHandlers(globals.engine, channelName, tokenUrl);
    if (videoEncoderConfiguration != null) {
      await globals.engine
          .setVideoEncoderConfiguration(videoEncoderConfiguration);
    }
    if (tempToken != null) {
      await globals.engine.joinChannel(tempToken, channelName, null, 0);
    } else {
      if (tokenUrl != null) {
        await store.getModule<AgoraTokens>().getToken(tokenUrl, channelName);
        await globals.engine.joinChannel(
            globals.token.value, channelName, null, globals.uid.value);
      } else {
        await globals.engine.joinChannel(null, channelName, null, 0);
      }
    }
  }

  /// @name handleCameraAndMicPermission
  /// @description Function to request permission for Audio, video and Local Storage
  static Future<void> handleCameraAndMicPermission(
      List<Permission> permissions) async {
    await permissions.request();
  }
}
