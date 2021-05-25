import 'package:agora_flutter_uikit/models/engine_settings.dart';

import 'call_user.dart';

class AgoraSettings {
  final AgoraConnectionData? connectionData;
  final List<CallUser> users;
  final bool isLocalUserMuted;

  AgoraSettings({required this.isLocalUserMuted, required this.users, this.connectionData});

  AgoraSettings copyWith({
    AgoraConnectionData? connectionData,
    List<CallUser>? users,
    bool? isLocalUserMuted,
  }) {
    return AgoraSettings(
      connectionData: connectionData ?? this.connectionData,
      users: users ?? this.users,
      isLocalUserMuted: isLocalUserMuted ?? this.isLocalUserMuted,
    );
  }
}
