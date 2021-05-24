import 'package:agora_flutter_uikit/models/engine_settings.dart';

import 'call_user.dart';

class CallSettings {
  final EngineSettings? engineSettings;
  final List<CallUser> users;

  CallSettings({required this.users, this.engineSettings});

  CallSettings copyWith({
    EngineSettings? engineSettings,
    List<CallUser>? users,
  }) {
    return CallSettings(
      engineSettings: engineSettings ?? this.engineSettings,
      users: users ?? this.users,
    );
  }
}
