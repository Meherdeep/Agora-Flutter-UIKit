import 'dart:async';

import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:agora_flutter_uikit/src/connection_data.dart';
import 'package:agora_flutter_uikit/src/tokens.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_flutter_uikit/src/events.dart';

AgoraTokens tokens;

class AgoraFlutterUIKit {
  static const MethodChannel _channel =
      const MethodChannel('agora_flutter_uikit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  AgoraFlutterUIKit({
    AgoraConnectionData agoraConnectionData,
    List<Permission> enabledPermission,
    ChannelProfile channelProfile,
    ClientRole userRole,
    VideoEncoderConfiguration videoEncoderConfiguration,
    bool setCameraAutoFocusFaceModeEnabled,
    bool enableDualStreamMode,
    StreamFallbackOptions localPublishFallbackOption,
    StreamFallbackOptions remoteSubscribeFallbackOption,
    AudioProfile audioProfile,
    AudioScenario audioScenario,
    BeautyOptions setBeautyEffectOptions,
    bool setCameraTorchOn,
    bool muteAllRemoteVideoStreams,
    bool muteAllRemoteAudioStreams,
  }) {
    _initAgoraRtcEngine(
      agoraConnectionData: agoraConnectionData,
      enabledPermission: enabledPermission,
      channelProfile: channelProfile,
      userRole: userRole,
      videoEncoderConfiguration: videoEncoderConfiguration,
      setCameraAutoFocusFaceModeEnabled: setCameraAutoFocusFaceModeEnabled,
      enableDualStreamMode: enableDualStreamMode,
      localPublishFallbackOption: localPublishFallbackOption,
      remoteSubscribeFallbackOption: remoteSubscribeFallbackOption,
      audioProfile: audioProfile,
      audioScenario: audioScenario,
      setBeautyEffectOptions: setBeautyEffectOptions,
      setCameraTorchOn: setCameraTorchOn,
      muteAllRemoteVideoStreams: muteAllRemoteVideoStreams,
      muteAllRemoteAudioStreams: muteAllRemoteAudioStreams,
    );
    print('APP ID: ${agoraConnectionData.appId}');
  }

  Future<void> _initAgoraRtcEngine({
    AgoraConnectionData agoraConnectionData,
    @required List<Permission> enabledPermission,
    ChannelProfile channelProfile,
    ClientRole userRole,
    VideoEncoderConfiguration videoEncoderConfiguration,
    bool setCameraAutoFocusFaceModeEnabled,
    bool enableDualStreamMode,
    StreamFallbackOptions localPublishFallbackOption,
    StreamFallbackOptions remoteSubscribeFallbackOption,
    AudioProfile audioProfile,
    AudioScenario audioScenario,
    BeautyOptions setBeautyEffectOptions,
    bool setCameraTorchOn,
    bool muteAllRemoteVideoStreams,
    bool muteAllRemoteAudioStreams,
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
    AgoraEvents events = AgoraEvents(globals.engine,
        agoraConnectionData.channelName, agoraConnectionData.tokenUrl);

    if (agoraConnectionData.tokenUrl != null) {
      tokens = AgoraTokens(
          channelName: agoraConnectionData.channelName,
          baseUrl: agoraConnectionData.tokenUrl);
    }
    await globals.engine
        .setChannelProfile(channelProfile ?? ChannelProfile.Communication);

    if (userRole != null) {
      if (channelProfile == ChannelProfile.LiveBroadcasting) {
        globals.clientRole.value = userRole;
        await globals.engine.setClientRole(userRole);
      } else {
        print("You can set the user role only for live broadcasting mode");
      }
    }
    await globals.engine.enableAudioVolumeIndication(200, 3, true);

    events.addAgoraEventHandlers(globals.engine,
        agoraConnectionData.channelName, agoraConnectionData.tokenUrl);

    if (videoEncoderConfiguration != null) {
      await globals.engine
          .setVideoEncoderConfiguration(videoEncoderConfiguration);
    }

    globals.engine.setCameraAutoFocusFaceModeEnabled(
        setCameraAutoFocusFaceModeEnabled ?? false);

    globals.engine.setCameraTorchOn(setCameraTorchOn ?? false);

    await globals.engine.setAudioProfile(audioProfile ?? AudioProfile.Default,
        audioScenario ?? AudioScenario.Default);

    await globals.engine.enableVideo();

    await globals.engine
        .muteAllRemoteVideoStreams(muteAllRemoteVideoStreams ?? false);

    await globals.engine
        .muteAllRemoteAudioStreams(muteAllRemoteAudioStreams ?? false);

    if (setBeautyEffectOptions != null) {
      globals.engine.setBeautyEffectOptions(true, setBeautyEffectOptions);
    }

    await globals.engine.enableDualStreamMode(enableDualStreamMode ?? false);

    if (localPublishFallbackOption != null) {
      await globals.engine
          .setLocalPublishFallbackOption(localPublishFallbackOption);
    }

    if (remoteSubscribeFallbackOption != null) {
      await globals.engine
          .setRemoteSubscribeFallbackOption(remoteSubscribeFallbackOption);
    }

    if (agoraConnectionData.tokenUrl != null) {
      await tokens.getToken(
          agoraConnectionData.tokenUrl, agoraConnectionData.channelName);
      await globals.engine.joinChannel(globals.token.value,
          agoraConnectionData.channelName, null, globals.uid.value);
    } else {
      await globals.engine.joinChannel(agoraConnectionData.tempToken ?? null,
          agoraConnectionData.channelName, null, agoraConnectionData.uid ?? 0);
    }
  }
}
