import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraConnectionData {
  String appId;
  String channelName;
  int? uid;
  AreaCode? areaCode;
  String? tokenUrl;
  String? tempToken;

  AgoraConnectionData({
    required this.appId,
    required this.channelName,
    this.uid,
    this.areaCode,
    this.tokenUrl,
    this.tempToken,
  });
}
