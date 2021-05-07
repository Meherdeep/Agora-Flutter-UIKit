import 'dart:async';

import 'package:agora_flutter_uikit/global/global_variable.dart';
import 'package:agora_flutter_uikit/src/tokens.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_super_state/flutter_super_state.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_flutter_uikit/src/events.dart';

import 'enums.dart';

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
    List<EnabledPermission> enabledPermission,
    ChannelProfiles channelProfile,
    UserRole userRole,
  }) {
    handleCameraAndMicPermission(enabledPermission);
    _initAgoraRtcEngine(appId, channelName, token, tokenUrl, areaCode,
        channelProfile, userRole);
  }

  Future<void> _initAgoraRtcEngine(
    @required String appId,
    @required String channelName,
    String tempToken,
    String tokenUrl,
    AreaCode areaCode,
    ChannelProfiles channelProfile,
    UserRole userRole,
  ) async {
    try {
      if (areaCode != null) {
        engine = await RtcEngine.createWithConfig(
          RtcEngineConfig(appId, areaCode: areaCode),
        );
      } else {
        engine = await RtcEngine.createWithConfig(
          RtcEngineConfig(appId),
        );
      }
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }
    await engine.enableVideo();
    AgoraEvents(store, engine, channelName, tokenUrl);
    if (tokenUrl != null) {
      AgoraTokens(store: store, channelName: channelName, baseUrl: tokenUrl);
    }
    if (channelProfile != null) {
      if (channelProfile == ChannelProfiles.Communication) {
        await engine.setChannelProfile(ChannelProfile.Communication);
      } else {
        await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      }
    } else {
      await engine.setChannelProfile(ChannelProfile.Communication);
    }
    if (userRole == UserRole.Audience) {
      if (channelProfile == ChannelProfiles.LiveBroadcasting) {
        await engine.setClientRole(ClientRole.Audience);
      } else {
        print("You can set the user role only for live broadcasting mode");
      }
    } else if (userRole == UserRole.Broadcaster) {
      if (channelProfile == ChannelProfiles.LiveBroadcasting) {
        await engine.setClientRole(ClientRole.Broadcaster);
      } else {
        print("You can set the user role only for live broadcasting mode");
      }
    }
    store
        .getModule<AgoraEvents>()
        .addAgoraEventHandlers(engine, channelName, tokenUrl);

    if (tempToken != null) {
      await engine.joinChannel(tempToken, channelName, null, 0);
    } else {
      if (tokenUrl != null) {
        await store.getModule<AgoraTokens>().getToken(tokenUrl, channelName);
        await engine.joinChannel(token.value, channelName, null, uid.value);
      } else {
        await engine.joinChannel(null, channelName, null, 0);
      }
    }
  }

  /// @name handleCameraAndMicPermission
  /// @description Function to request permission for Audio, video and Local Storage
  static Future<void> handleCameraAndMicPermission(
      List<EnabledPermission> permissions) async {
    for (int i = 0; i < permissions.length; i++) {
      if (permissions[i] == EnabledPermission.camera) {
        await Permission.camera.request();
      } else if (permissions[i] == EnabledPermission.microphone) {
        await Permission.microphone.request();
      } else if (permissions[i] == EnabledPermission.storage) {
        await Permission.storage.request();
      }
    }
  }
}
