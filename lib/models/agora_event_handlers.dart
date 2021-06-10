import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraEventHandlers {
  Function(int uid, int elapsed)? userJoined;
  Function(String channel, int uid, int elapsed)? joinChannelSuccess;
  Function(ErrorCode errorCode)? onError;
  Function(RtcStats stats)? leaveChannel;
  Function(int uid, UserOfflineReason reason)? userOffline;
  Function(String token)? tokenPrivilegeWillExpire;
  Function(int uid, VideoRemoteState state, VideoRemoteStateReason reason,
      int elapsed)? remoteVideoStateChanged;
  Function(int uid, AudioRemoteState state, AudioRemoteStateReason reason,
      int elapsed)? remoteAudioStateChanged;
  Function(AudioLocalState state, AudioLocalError error)?
      localAudioStateChanged;
  Function(LocalVideoStreamState localVideoState, LocalVideoStreamError error)?
      localVideoStateChanged;
  Function(int uid)? activeSpeaker;

  AgoraEventHandlers({
    this.userJoined,
    this.joinChannelSuccess,
    this.onError,
    this.activeSpeaker,
    this.leaveChannel,
    this.localAudioStateChanged,
    this.localVideoStateChanged,
    this.remoteAudioStateChanged,
    this.remoteVideoStateChanged,
    this.tokenPrivilegeWillExpire,
    this.userOffline,
  });

  AgoraEventHandlers copyWith({
    Function(int uid, int elapsed)? userJoined,
    Function(String channel, int uid, int elapsed)? joinChannelSuccess,
    Function(ErrorCode errorCode)? onError,
    Function(RtcStats stats)? leaveChannel,
    Function(int uid, UserOfflineReason reason)? userOffline,
    Function(String token)? tokenPrivilegeWillExpire,
    Function(int uid, VideoRemoteState state, VideoRemoteStateReason reason,
            int elapsed)?
        remoteVideoStateChanged,
    Function(int uid, AudioRemoteState state, AudioRemoteStateReason reason,
            int elapsed)?
        remoteAudioStateChanged,
    Function(AudioLocalState state, AudioLocalError error)?
        localAudioStateChanged,
    Function(
            LocalVideoStreamState localVideoState, LocalVideoStreamError error)?
        localVideoStateChanged,
    Function(int uid)? activeSpeaker,
  }) {
    return AgoraEventHandlers(
      userJoined: userJoined ?? this.userJoined,
      joinChannelSuccess: joinChannelSuccess ?? this.joinChannelSuccess,
      onError: onError ?? this.onError,
      leaveChannel: leaveChannel ?? this.leaveChannel,
      userOffline: userOffline ?? this.userOffline,
      tokenPrivilegeWillExpire:
          tokenPrivilegeWillExpire ?? this.tokenPrivilegeWillExpire,
      remoteVideoStateChanged:
          remoteVideoStateChanged ?? this.remoteVideoStateChanged,
      remoteAudioStateChanged:
          remoteAudioStateChanged ?? this.remoteAudioStateChanged,
      localVideoStateChanged:
          localVideoStateChanged ?? this.localVideoStateChanged,
      localAudioStateChanged:
          localAudioStateChanged ?? this.localAudioStateChanged,
      activeSpeaker: activeSpeaker ?? this.activeSpeaker,
    );
  }
}
