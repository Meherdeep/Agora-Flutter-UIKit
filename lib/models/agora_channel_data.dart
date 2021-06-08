import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraChannelData {
  final ChannelProfile? channelProfile;
  ClientRole? clientRole;
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

  AgoraChannelData({
    this.channelProfile,
    this.clientRole,
    this.videoEncoderConfiguration,
    this.setCameraAutoFocusFaceModeEnabled,
    this.enableDualStreamMode,
    this.localPublishFallbackOption,
    this.remoteSubscribeFallbackOption,
    this.audioProfile,
    this.audioScenario,
    this.setBeautyEffectOptions,
    this.setCameraTorchOn,
    this.muteAllRemoteAudioStreams,
    this.muteAllRemoteVideoStreams,
  });

  AgoraChannelData copyWith({
    final ChannelProfile? channelProfile,
    ClientRole? clientRole,
    VideoEncoderConfiguration? videoEncoderConfiguration,
    bool? setCameraAutoFocusFaceModeEnabled,
    bool? enableDualStreamMode,
    StreamFallbackOptions? localPublishFallbackOption,
    StreamFallbackOptions? remoteSubscribeFallbackOption,
    AudioProfile? audioProfile,
    AudioScenario? audioScenario,
    BeautyOptions? setBeautyEffectOptions,
    bool? setCameraTorchOn,
    bool? muteAllRemoteVideoStreams,
    bool? muteAllRemoteAudioStreams,
  }) {
    return AgoraChannelData(
      channelProfile: channelProfile ?? this.channelProfile,
      clientRole: clientRole ?? this.clientRole,
      videoEncoderConfiguration:
          videoEncoderConfiguration ?? this.videoEncoderConfiguration,
      setCameraAutoFocusFaceModeEnabled: setCameraAutoFocusFaceModeEnabled ??
          this.setCameraAutoFocusFaceModeEnabled,
      enableDualStreamMode: enableDualStreamMode ?? this.enableDualStreamMode,
      localPublishFallbackOption:
          localPublishFallbackOption ?? this.localPublishFallbackOption,
      remoteSubscribeFallbackOption:
          remoteSubscribeFallbackOption ?? this.remoteSubscribeFallbackOption,
      audioProfile: audioProfile ?? this.audioProfile,
      audioScenario: audioScenario ?? this.audioScenario,
      setBeautyEffectOptions:
          setBeautyEffectOptions ?? this.setBeautyEffectOptions,
      setCameraTorchOn: setCameraTorchOn ?? this.setCameraTorchOn,
      muteAllRemoteAudioStreams:
          muteAllRemoteAudioStreams ?? this.muteAllRemoteAudioStreams,
      muteAllRemoteVideoStreams:
          muteAllRemoteVideoStreams ?? this.muteAllRemoteVideoStreams,
    );
  }
}
