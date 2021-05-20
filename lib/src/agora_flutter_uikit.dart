import 'dart:async';

import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
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
    @required String appId,
    @required String channelName,
    int uid,
    AreaCode areaCode,
    String token,
    String tokenUrl,
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
    bool enableDeepLearningDenoise,
    bool setCameraTorchOn,
  }) {
    _initAgoraRtcEngine(
      appId: appId,
      channelName: channelName,
      uid: uid,
      enabledPermission: enabledPermission,
      tempToken: token,
      tokenUrl: tokenUrl,
      areaCode: areaCode,
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
      enableDeepLearningDenoise: enableDeepLearningDenoise,
      setCameraTorchOn: setCameraTorchOn,
    );
  }

  Future<void> _initAgoraRtcEngine({
    @required String appId,
    @required String channelName,
    int uid,
    @required List<Permission> enabledPermission,
    String tempToken,
    String tokenUrl,
    AreaCode areaCode,
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
    bool enableDeepLearningDenoise,
    bool setCameraTorchOn,
  }) async {
    try {
      globals.engine = await RtcEngine.createWithConfig(
        RtcEngineConfig(appId, areaCode: areaCode ?? AreaCode.GLOB),
      );
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }

    await enabledPermission.request();
    AgoraEvents events = AgoraEvents(globals.engine, channelName, tokenUrl);

    if (tokenUrl != null) {
      tokens = AgoraTokens(channelName: channelName, baseUrl: tokenUrl);
    }
    await globals.engine
        .setChannelProfile(channelProfile ?? ChannelProfile.Communication);

    if (userRole != null) {
      if (channelProfile == ChannelProfile.LiveBroadcasting) {
        await globals.engine.setClientRole(userRole);
      } else {
        print("You can set the user role only for live broadcasting mode");
      }
    }
    await globals.engine.enableAudioVolumeIndication(200, 3, true);

    events.addAgoraEventHandlers(globals.engine, channelName, tokenUrl);

    if (videoEncoderConfiguration != null) {
      await globals.engine
          .setVideoEncoderConfiguration(videoEncoderConfiguration);
    }

    await globals.engine.setCameraAutoFocusFaceModeEnabled(
        setCameraAutoFocusFaceModeEnabled ?? false);

    await globals.engine.setCameraTorchOn(setCameraTorchOn ?? false);

    await globals.engine.setAudioProfile(audioProfile ?? AudioProfile.Default,
        audioScenario ?? AudioScenario.Default);

    await globals.engine.enableVideo();

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

    await globals.engine
        .enableDeepLearningDenoise(enableDeepLearningDenoise ?? true);

    if (tokenUrl != null) {
      await tokens.getToken(tokenUrl, channelName);
      await globals.engine.joinChannel(
          globals.token.value, channelName, null, globals.uid.value);
    } else {
      await globals.engine
          .joinChannel(tempToken ?? null, channelName, null, uid ?? 0);
    }
  }
}
