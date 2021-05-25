import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraSettings {
  ChannelProfile? channelProfile;
  ClientRole? userRole;
  VideoEncoderConfiguration? videoEncoderConfiguration;
  bool? setCameraAutoFocusFaceModeEnabled;
  bool? enableDualStreamMode;
  StreamFallbackOptions? localPublishFallbackOption;
  StreamFallbackOptions? remoteSubscribeFallbackOption;
  AudioProfile? audioProfile;
  AudioScenario? audioScenario;
  BeautyOptions? setBeautyEffectOptions;
  bool? setCameraTorchOn;
  bool? muteAllRemoteVideoStreams;
  bool? muteAllRemoteAudioStreams;

  AgoraSettings({
    this.channelProfile,
    this.userRole,
    this.videoEncoderConfiguration,
    this.setCameraAutoFocusFaceModeEnabled,
    this.enableDualStreamMode,
    this.localPublishFallbackOption,
    this.remoteSubscribeFallbackOption,
    this.audioProfile,
    this.audioScenario,
    this.setBeautyEffectOptions,
    this.setCameraTorchOn,
    this.muteAllRemoteVideoStreams,
    this.muteAllRemoteAudioStreams,
  });
}
