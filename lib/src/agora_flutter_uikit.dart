import 'dart:async';

import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:agora_flutter_uikit/src/connection_data.dart';
import 'package:agora_flutter_uikit/src/settings.dart';
import 'package:agora_flutter_uikit/src/tokens.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_flutter_uikit/src/events.dart';

late AgoraTokens tokens;

class AgoraFlutterUIKit {
  static const MethodChannel _channel =
      const MethodChannel('agora_flutter_uikit');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  AgoraFlutterUIKit({
    required AgoraConnectionData agoraConnectionData,
    required List<Permission> enabledPermission,
    AgoraSettings? agoraSettings,
  }) {
    _initAgoraRtcEngine(
      agoraConnectionData: agoraConnectionData,
      enabledPermission: enabledPermission,
      agoraSettings: agoraSettings,
    );
  }

  Future<void> _initAgoraRtcEngine({
    required AgoraConnectionData agoraConnectionData,
    required List<Permission> enabledPermission,
    AgoraSettings? agoraSettings,
  }) async {
    try {
      globals.engine = await RtcEngine.createWithConfig(
        RtcEngineConfig(agoraConnectionData.appId,
            areaCode: agoraConnectionData.areaCode ?? AreaCode.GLOB),
      );
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }

    await enabledPermission.request();

    AgoraEvents events = AgoraEvents(
      globals.engine,
      agoraConnectionData.channelName,
      agoraConnectionData.tokenUrl,
      agoraConnectionData.uid,
    );

    if (agoraConnectionData.tokenUrl != null) {
      tokens = AgoraTokens(
          channelName: agoraConnectionData.channelName,
          baseUrl: agoraConnectionData.tokenUrl);
    }
    await globals.engine.setChannelProfile(
        agoraSettings!.channelProfile ?? ChannelProfile.Communication);

    if (agoraSettings.userRole != null) {
      if (agoraSettings.channelProfile == ChannelProfile.LiveBroadcasting) {
        globals.clientRole.value = agoraSettings.userRole!;
        print("USER ROLE: ${agoraSettings.userRole!}");
        await globals.engine.setClientRole(agoraSettings.userRole!);
      } else {
        print("You can set the user role only for live broadcasting mode");
      }
    }
    await globals.engine.enableAudioVolumeIndication(200, 3, true);

    events.addAgoraEventHandlers(
      globals.engine,
      agoraConnectionData.channelName,
      agoraConnectionData.tokenUrl,
      agoraConnectionData.uid,
    );

    if (agoraSettings.videoEncoderConfiguration != null) {
      await globals.engine.setVideoEncoderConfiguration(
          agoraSettings.videoEncoderConfiguration!);
    }

    globals.engine.setCameraAutoFocusFaceModeEnabled(
        agoraSettings.setCameraAutoFocusFaceModeEnabled ?? false);

    globals.engine.setCameraTorchOn(agoraSettings.setCameraTorchOn ?? false);

    await globals.engine.setAudioProfile(
        agoraSettings.audioProfile ?? AudioProfile.Default,
        agoraSettings.audioScenario ?? AudioScenario.Default);

    await globals.engine.enableVideo();

    await globals.engine.muteAllRemoteVideoStreams(
        agoraSettings.muteAllRemoteVideoStreams ?? false);

    await globals.engine.muteAllRemoteAudioStreams(
        agoraSettings.muteAllRemoteAudioStreams ?? false);

    if (agoraSettings.setBeautyEffectOptions != null) {
      globals.engine
          .setBeautyEffectOptions(true, agoraSettings.setBeautyEffectOptions!);
    }

    await globals.engine
        .enableDualStreamMode(agoraSettings.enableDualStreamMode ?? false);

    if (agoraSettings.localPublishFallbackOption != null) {
      await globals.engine.setLocalPublishFallbackOption(
          agoraSettings.localPublishFallbackOption!);
    }

    if (agoraSettings.remoteSubscribeFallbackOption != null) {
      await globals.engine.setRemoteSubscribeFallbackOption(
          agoraSettings.remoteSubscribeFallbackOption!);
    }

    if (agoraConnectionData.tokenUrl != null) {
      await tokens.getToken(agoraConnectionData.tokenUrl,
          agoraConnectionData.channelName, agoraConnectionData.uid);
      await globals.engine.joinChannel(globals.token.value,
          agoraConnectionData.channelName, null, agoraConnectionData.uid ?? 0);
    } else {
      await globals.engine.joinChannel(agoraConnectionData.tempToken ?? null,
          agoraConnectionData.channelName, null, agoraConnectionData.uid ?? 0);
    }
  }
}
