import 'dart:async';

import 'package:agora_flutter_uikit/controllers/session_controller.dart';
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
  }) {
    _initAgoraRtcEngine(
      appId: appId,
      enabledPermission: enabledPermission,
      channelName: channelName,
    );
    print('APP ID: $appId');
  }

  Future<void> _initAgoraRtcEngine({
    required String appId,
    required List<Permission> enabledPermission,
    required String channelName,
  }) async {
    try {
      _callController.initializeEngine(appId, channelName);
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }

    await enabledPermission.request();

    _callController.createEvents();

    _callController.joinVideoChannel(channel: channelName);
  }
}
