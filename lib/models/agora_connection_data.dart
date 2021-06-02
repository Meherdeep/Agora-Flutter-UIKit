import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraConnectionData {
  final RtcEngine engine;
  final String appId;
  final String channelName;

  AgoraConnectionData(
      {required this.engine, required this.appId, required this.channelName});

  AgoraConnectionData copyWith({
    RtcEngine? engine,
    String? appId,
    String? channelName,
  }) {
    return AgoraConnectionData(
      engine: engine ?? this.engine,
      appId: appId ?? this.appId,
      channelName: channelName ?? this.channelName,
    );
  }
}
