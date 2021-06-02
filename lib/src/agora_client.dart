import 'dart:async';

import 'package:agora_flutter_uikit/controllers/session_controller.dart';
import 'package:agora_flutter_uikit/models/agora_connection_data.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraClient {
  static const MethodChannel _channel = MethodChannel('agora_flutter_uikit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // This is our "state" object that the UI Kit works with
  final SessionController _callController = SessionController();
  SessionController get callController {
    return _callController;
  }

  AgoraClient({
    required String appId,
    required List<Permission> enabledPermission,
    required String channelName,
    int? uid,
    String? tempToken,
    String? tokenUrl,
    AreaCode? areaCode,
  }) {
    _initAgoraRtcEngine(
      appId: appId,
      enabledPermission: enabledPermission,
      channelName: channelName,
      uid: uid,
      tempToken: tempToken,
      tokenUrl: tokenUrl,
      areaCode: areaCode,
    );
    print('APP ID: $appId');
  }

  Future<void> _initAgoraRtcEngine({
    required String appId,
    required List<Permission> enabledPermission,
    required String channelName,
    int? uid,
    String? tempToken,
    String? tokenUrl,
    AreaCode? areaCode,
  }) async {
    try {
      _callController.initializeEngine(
        appId: appId,
        channelName: channelName,
        tempToken: tempToken,
        tokenUrl: tokenUrl,
        uid: uid,
        areaCode: areaCode,
      );
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }

    await enabledPermission.request();

    _callController.createEvents();

    _callController.joinVideoChannel();
  }
}
