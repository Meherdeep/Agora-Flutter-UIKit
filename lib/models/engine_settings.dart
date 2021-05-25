import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraConnectionData {
  final RtcEngine engine;
  final String appId;

  AgoraConnectionData({required this.engine, required this.appId});

  AgoraConnectionData copyWith({
    RtcEngine? engine,
    String? appId,
  }) {
    return AgoraConnectionData(
      engine: engine ?? this.engine,
      appId: appId ?? this.appId,
    );
  }
}
