import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraConnectionData {
  final String appId;
  final String channelName;
  final int? uid;
  final String? tokenUrl;
  final String? tempToken;
  final AreaCode? areaCode;

  AgoraConnectionData({
    required this.appId,
    required this.channelName,
    this.uid,
    this.tokenUrl,
    this.tempToken,
    this.areaCode,
  });

  AgoraConnectionData copyWith({
    String? appId,
    String? channelName,
    int? uid,
    String? tempToken,
    String? tokenUrl,
    AreaCode? areaCode,
  }) {
    return AgoraConnectionData(
      appId: appId ?? this.appId,
      channelName: channelName ?? this.channelName,
      uid: uid ?? this.uid,
      tempToken: tempToken ?? this.tempToken,
      tokenUrl: tokenUrl ?? this.tokenUrl,
      areaCode: areaCode ?? this.areaCode,
    );
  }
}
