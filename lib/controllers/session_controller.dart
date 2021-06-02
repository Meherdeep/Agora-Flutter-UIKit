import 'dart:convert';

import 'package:agora_flutter_uikit/models/agora_settings.dart';
import 'package:agora_flutter_uikit/models/agora_user.dart';
import 'package:agora_flutter_uikit/models/agora_connection_data.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SessionController extends ValueNotifier<AgoraSettings> {
  SessionController()
      : super(
          AgoraSettings(
              users: [],
              isLocalUserMuted: false,
              isLocalVideoDisabled: false,
              visible: true,
              isButtonVisible: false,
              clientRole: ClientRole.Broadcaster,
              maxUid: 0,
              localUid: 0,
              generatedToken: null),
        );

  void initializeEngine(
      {required String appId,
      required String channelName,
      AreaCode? areaCode,
      String? tempToken,
      String? tokenUrl,
      int? uid}) async {
    value = value.copyWith(
      connectionData: AgoraConnectionData(
        engine: await RtcEngine.createWithConfig(
            RtcEngineConfig(appId, areaCode: areaCode)),
        appId: appId,
        channelName: channelName,
        tempToken: tempToken,
        tokenUrl: tokenUrl,
        uid: uid,
        areaCode: areaCode,
      ),
    );
  }

  void createEvents() async {
    value.connectionData?.engine.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {
          final info = 'onError: $code';
          print(info);
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          final info = 'onJoinChannel: $channel, uid: $uid';
          print(info);
          value = value.copyWith(localUid: uid);
          value = value.copyWith(maxUid: uid);
        },
        leaveChannel: (stats) {
          clearUsers();
        },
        userJoined: (uid, elapsed) {
          final info = 'userJoined: $uid';
          print(info);
          addUser(
            callUser: AgoraUser(
              uid: uid,
              remote: false,
              muted: false,
              videoDisabled: false,
              clientRole: ClientRole.Broadcaster,
            ),
          );
        },
        userOffline: (uid, reason) {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          checkForMaxUser(uid: uid);
          removeUser(uid: uid);
        },
        tokenPrivilegeWillExpire: (token) async {
          await getToken(
            tokenUrl: value.connectionData!.tokenUrl,
            channelName: value.connectionData!.channelName,
            uid: value.connectionData!.uid,
          );
          await value.connectionData!.engine.renewToken(token);
        },
      ),
    );
  }

  void joinVideoChannel() async {
    await value.connectionData?.engine.enableVideo();
    if (value.connectionData!.tokenUrl != null) {
      await getToken(
        tokenUrl: value.connectionData!.tokenUrl,
        channelName: value.connectionData!.channelName,
        uid: value.connectionData!.uid,
      );
    }
    value.connectionData?.engine.joinChannel(
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
    value.connectionData?.engine.muteLocalAudioStream(value.isLocalUserMuted);
  }

  void toggleCamera() async {
    var status = await Permission.camera.status;
    if (value.isLocalVideoDisabled && status.isDenied) {
      await Permission.camera.request();
    }
    value = value.copyWith(isLocalVideoDisabled: !(value.isLocalVideoDisabled));
    value.connectionData?.engine
        .muteLocalVideoStream(value.isLocalVideoDisabled);
  }

  void switchCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
    value.connectionData?.engine.switchCamera();
  }

  void endCall() {
    value.connectionData?.engine.leaveChannel();
    value.connectionData?.engine.destroy();
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

  Future<void> getToken(
      {String? tokenUrl, String? channelName, int? uid}) async {
    uid = uid ?? 0;
    final response = await http
        .get(Uri.parse('$tokenUrl/rtc/$channelName/publisher/uid/$uid'));
    if (response.statusCode == 200) {
      print("TOKEN BODY " + response.body);
      value =
          value.copyWith(generatedToken: jsonDecode(response.body)['rtcToken']);
      // jsonDecode(response.body)['rtcToken'];
      print('Token : ${value.connectionData!.tempToken}');
    } else {
      print(response.reasonPhrase);
      print('Failed to generate the token : ${response.statusCode}');
    }
  }
}
