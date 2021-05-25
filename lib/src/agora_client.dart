import 'dart:async';

import 'package:agora_flutter_uikit/controllers/call_controller.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraClient {
  static const MethodChannel _channel = const MethodChannel('agora_flutter_uikit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // This is our "state" object that the UI Kit works with
  final CallController _callController = CallController();
  CallController get callController {
    return _callController;
  }

  AgoraClient({
    required String appId,
    required List<Permission> enabledPermission,
  }) {
    _initAgoraRtcEngine(
      appId: appId,
      enabledPermission: enabledPermission,
    );
    print('APP ID: $appId');
  }

  Future<void> _initAgoraRtcEngine({
    required String appId,
    required List<Permission> enabledPermission,
  }) async {
    try {
      _callController.initializeEngine(appId);
    } catch (e) {
      print("Error occured while initializing Agora RtcEngine: $e");
    }

    await enabledPermission.request();

    _callController.createEvents();

    _callController.joinVideoChannel(channel: "tadas");
  }
}
