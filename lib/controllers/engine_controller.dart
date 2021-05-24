import 'package:agora_flutter_uikit/models/engine_settings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

EngineController engineController = EngineController();

class EngineController extends ValueNotifier<EngineSettings?> {
  EngineController() : super(null);

  EngineSettings copyWith({RtcEngine? engine, String? appId}) {
    return EngineSettings(engine: engine ?? value!.engine, appId: appId ?? value!.appId);
  }

  void initializeEngine(String appId) async {
    value = EngineSettings(
      engine: await RtcEngine.createWithConfig(RtcEngineConfig(appId)),
      appId: appId,
    );
  }
}
