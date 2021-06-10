import 'dart:convert';

import 'package:agora_flutter_uikit/models/agora_channel_data.dart';
import 'package:agora_flutter_uikit/models/agora_settings.dart';
import 'package:agora_flutter_uikit/models/agora_user.dart';
import 'package:agora_flutter_uikit/models/agora_connection_data.dart';
import 'package:agora_flutter_uikit/models/agora_event_handlers.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SessionController extends ValueNotifier<AgoraSettings> {
  SessionController()
      : super(
          AgoraSettings(
            engine: null,
            users: [],
            mainAgoraUser: null,
            isLocalUserMuted: false,
            isLocalVideoDisabled: false,
            visible: true,
            isButtonVisible: false,
            clientRole: ClientRole.Broadcaster,
            maxUid: 0,
            localUid: 0,
            generatedToken: null,
            isActiveSpeakerDisabled: false,
          ),
        );

  void initializeEngine(
      {required AgoraConnectionData agoraConnectionData}) async {
    value = value.copyWith(
        engine: await RtcEngine.createWithConfig(RtcEngineConfig(
            agoraConnectionData.appId,
            areaCode: agoraConnectionData.areaCode)),
        connectionData: agoraConnectionData);
  }

  void createEvents(AgoraEventHandlers? agoraEventHandlers) async {
    value.engine?.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {
          final info = 'onError: $code';
          print(info);
          var onErrorFun = agoraEventHandlers?.onError;
          if (onErrorFun != null) onErrorFun(code);
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          final info = 'onJoinChannel: $channel, uid: $uid';
          print(info);
          value = value.copyWith(localUid: uid);
          value = value.copyWith(maxUid: uid);
          value = value.copyWith(
              mainAgoraUser: AgoraUser(
            uid: uid,
            remote: false,
            muted: value.isLocalUserMuted,
            videoDisabled: value.isLocalVideoDisabled,
            clientRole: value.clientRole,
          ));
          var joinChannelSuccessFun = agoraEventHandlers?.joinChannelSuccess;
          if (joinChannelSuccessFun != null) {
            joinChannelSuccessFun(channel, uid, elapsed);
          }
        },
        leaveChannel: (stats) {
          clearUsers();
          var leaveChannelFun = agoraEventHandlers?.leaveChannel;
          if (leaveChannelFun != null) leaveChannelFun(stats);
        },
        userJoined: (uid, elapsed) {
          final info = 'userJoined: $uid';
          print(info);
          addUser(
            callUser: AgoraUser(
              uid: uid,
              remote: true,
              muted: false,
              videoDisabled: false,
              clientRole: ClientRole.Broadcaster,
            ),
          );
          var userJoinedFun = agoraEventHandlers?.userJoined;
          if (userJoinedFun != null) userJoinedFun(uid, elapsed);
        },
        userOffline: (uid, reason) {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          checkForMaxUser(uid: uid);
          removeUser(uid: uid);
          var userOfflineFun = agoraEventHandlers?.userOffline;
          if (userOfflineFun != null) userOfflineFun(uid, reason);
        },
        tokenPrivilegeWillExpire: (token) async {
          await getToken(
            tokenUrl: value.connectionData!.tokenUrl,
            channelName: value.connectionData!.channelName,
            uid: value.connectionData!.uid,
          );
          await value.engine?.renewToken(token);
          var tokenPrivilegeWillExpireFun =
              agoraEventHandlers?.tokenPrivilegeWillExpire;
          if (tokenPrivilegeWillExpireFun != null) {
            tokenPrivilegeWillExpireFun(token);
          }
        },
        remoteVideoStateChanged: (uid, state, reason, elapsed) {
          if (state == VideoRemoteState.Stopped) {
            updateUserVideo(uid: uid, videoDisabled: true);
          } else if (state == VideoRemoteState.Decoding &&
              reason == VideoRemoteStateReason.RemoteUnmuted) {
            updateUserVideo(uid: uid, videoDisabled: false);
          }
          var remoteVideoStateChangedFun =
              agoraEventHandlers?.remoteVideoStateChanged;
          if (remoteVideoStateChangedFun != null) {
            remoteVideoStateChangedFun(uid, state, reason, elapsed);
          }
        },
        remoteAudioStateChanged: (uid, state, reason, elapsed) {
          if (state == AudioRemoteState.Stopped) {
            updateUserAudio(uid: uid, muted: true);
          } else if (state == AudioRemoteState.Decoding &&
              reason == AudioRemoteStateReason.RemoteUnmuted) {
            updateUserAudio(uid: uid, muted: false);
          }
          var remoteAudioStateChangedFun =
              agoraEventHandlers?.remoteAudioStateChanged;
          if (remoteAudioStateChangedFun != null) {
            remoteAudioStateChangedFun(uid, state, reason, elapsed);
          }
        },
        localAudioStateChanged: (state, error) {
          if (state == AudioLocalState.Stopped) {
            updateUserAudio(uid: value.localUid, muted: true);
          } else if (state == AudioLocalState.Recording) {
            updateUserAudio(uid: value.localUid, muted: false);
          }
          var localAudioStateChangedFun =
              agoraEventHandlers?.localAudioStateChanged;
          if (localAudioStateChangedFun != null) {
            localAudioStateChangedFun(state, error);
          }
        },
        localVideoStateChanged: (localVideoState, error) {
          if (localVideoState == LocalVideoStreamState.Stopped) {
            updateUserVideo(uid: value.localUid, videoDisabled: true);
          } else if (localVideoState == LocalVideoStreamState.Capturing) {
            updateUserVideo(uid: value.localUid, videoDisabled: false);
          }
          var localVideoStateChangedFun =
              agoraEventHandlers?.localVideoStateChanged;
          if (localVideoStateChangedFun != null) {
            localVideoStateChangedFun(localVideoState, error);
          }
        },
        activeSpeaker: (uid) {
          if (!value.isActiveSpeakerDisabled!) {
            final int index =
                value.users.indexWhere((element) => element.uid == uid);
            swapUser(index: index);
          }
          var activeSpeakerFun = agoraEventHandlers?.activeSpeaker;
          if (activeSpeakerFun != null) activeSpeakerFun(uid);
        },
      ),
    );
  }

  void setChannelProperties(AgoraChannelData agoraChannelData) async {
    await value.engine?.setChannelProfile(
        agoraChannelData.channelProfile ?? ChannelProfile.Communication);

    if (agoraChannelData.channelProfile == ChannelProfile.LiveBroadcasting) {
      await value.engine?.setClientRole(
          agoraChannelData.clientRole ?? ClientRole.Broadcaster);
    } else {
      print('You can only set channel profile in case of Live Broadcasting');
    }

    await value.engine?.muteAllRemoteVideoStreams(
        agoraChannelData.muteAllRemoteVideoStreams ?? false);

    await value.engine?.muteAllRemoteAudioStreams(
        agoraChannelData.muteAllRemoteAudioStreams ?? false);

    if (agoraChannelData.setBeautyEffectOptions != null) {
      value.engine?.setBeautyEffectOptions(
          true, agoraChannelData.setBeautyEffectOptions!);
    }

    await value.engine
        ?.enableDualStreamMode(agoraChannelData.enableDualStreamMode ?? false);

    if (agoraChannelData.localPublishFallbackOption != null) {
      await value.engine?.setLocalPublishFallbackOption(
          agoraChannelData.localPublishFallbackOption!);
    }

    if (agoraChannelData.remoteSubscribeFallbackOption != null) {
      await value.engine?.setRemoteSubscribeFallbackOption(
          agoraChannelData.remoteSubscribeFallbackOption!);
    }

    if (agoraChannelData.videoEncoderConfiguration != null) {
      await value.engine?.setVideoEncoderConfiguration(
          agoraChannelData.videoEncoderConfiguration!);
    }

    value.engine?.setCameraAutoFocusFaceModeEnabled(
        agoraChannelData.setCameraAutoFocusFaceModeEnabled ?? false);

    value.engine?.setCameraTorchOn(agoraChannelData.setCameraTorchOn ?? false);

    await value.engine?.setAudioProfile(
        agoraChannelData.audioProfile ?? AudioProfile.Default,
        agoraChannelData.audioScenario ?? AudioScenario.Default);
  }

  void joinVideoChannel() async {
    await value.engine?.enableVideo();
    await value.engine?.enableAudioVolumeIndication(200, 3, true);
    if (value.connectionData!.tokenUrl != null) {
      await getToken(
        tokenUrl: value.connectionData!.tokenUrl,
        channelName: value.connectionData!.channelName,
        uid: value.connectionData!.uid,
      );
    }
    value.engine?.joinChannel(
      value.connectionData!.tempToken ?? value.generatedToken,
      value.connectionData!.channelName,
      null,
      value.connectionData!.uid ?? 0,
    );
  }

  void addUser({required AgoraUser callUser}) {
    value = value.copyWith(users: [...value.users, callUser]);
  }

  void clearUsers() {
    value = value.copyWith(users: []);
  }

  void removeUser({required int uid}) {
    List<AgoraUser> tempList = <AgoraUser>[];
    tempList = value.users;
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].uid == uid) {
        tempList.remove(tempList[i]);
      }
    }
    value = value.copyWith(users: tempList);
  }

  void toggleMute() async {
    var status = await Permission.microphone.status;
    if (value.isLocalUserMuted && status.isDenied) {
      await Permission.microphone.request();
    }
    value = value.copyWith(isLocalUserMuted: !(value.isLocalUserMuted));
    value.engine?.muteLocalAudioStream(value.isLocalUserMuted);
  }

  void toggleCamera() async {
    var status = await Permission.camera.status;
    if (value.isLocalVideoDisabled && status.isDenied) {
      await Permission.camera.request();
    }
    value = value.copyWith(isLocalVideoDisabled: !(value.isLocalVideoDisabled));
    value.engine?.muteLocalVideoStream(value.isLocalVideoDisabled);
  }

  void switchCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
    value.engine?.switchCamera();
  }

  void endCall() {
    value.engine?.leaveChannel();
    value.engine?.destroy();
    dispose();
  }

  void toggleVisible() {
    value = value.copyWith(visible: !(value.visible));
  }

  void toggleIsButtonVisible({int? autoHideButtonTime}) {
    if (value.isButtonVisible) {
      toggleVisible();
      Future.delayed(
        Duration(seconds: autoHideButtonTime ?? 5),
        () {
          toggleVisible();
          value = value.copyWith(isButtonVisible: !(value.isButtonVisible));
        },
      );
    }
  }

  void checkForMaxUser({int? uid}) {
    if (uid == value.maxUid) {
      value = value.copyWith(maxUid: value.localUid);
    }
    removeUser(uid: value.localUid);
  }

  void updateUserVideo({required int uid, required bool videoDisabled}) {
    List<AgoraUser> tempList = value.users;
    int indexOfUser = tempList.indexWhere((element) => element.uid == uid);
    tempList[indexOfUser] =
        tempList[indexOfUser].copyWith(videoDisabled: videoDisabled);
    value = value.copyWith(users: tempList);
  }

  void updateUserAudio({required int uid, required bool muted}) {
    List<AgoraUser> tempList = value.users;
    int indexOfUser = tempList.indexWhere((element) => element.uid == uid);
    tempList[indexOfUser] = tempList[indexOfUser].copyWith(muted: muted);
    value = value.copyWith(users: tempList);
  }

  Future<void> swapUser({required int index}) async {
    final int newMaxUid = value.users[index].uid;
    final AgoraUser tempAgoraUser = value.mainAgoraUser!;
    final int xyz =
        value.users.indexWhere((element) => element.uid == newMaxUid);
    value = value.copyWith(mainAgoraUser: value.users[xyz]);
    addUser(callUser: tempAgoraUser);
    value = value.copyWith(maxUid: newMaxUid);
    removeUser(uid: newMaxUid);
  }

  Future<void> getToken(
      {String? tokenUrl, String? channelName, int? uid}) async {
    uid = uid ?? 0;
    final response = await http
        .get(Uri.parse('$tokenUrl/rtc/$channelName/publisher/uid/$uid'));
    if (response.statusCode == 200) {
      print("TOKEN BODY " + response.body);
      value =
          value.copyWith(generatedToken: jsonDecode(response.body)['rtcToken']);
      print('Token : ${value.connectionData!.tempToken}');
    } else {
      print(response.reasonPhrase);
      print('Failed to generate the token : ${response.statusCode}');
    }
  }
}
