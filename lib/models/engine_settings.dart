import 'package:agora_rtc_engine/rtc_engine.dart';

class EngineSettings {
  final RtcEngine engine;
  final String appId;

  EngineSettings({required this.engine, required this.appId});

  EngineSettings copyWith({
    RtcEngine? engine,
    String? appId,
  }) {
    return EngineSettings(
      engine: engine ?? this.engine,
      appId: appId ?? this.appId,
    );
  }
}
