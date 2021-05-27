import 'package:agora_flutter_uikit/models/agora_connection_data.dart';

import 'agora_user.dart';

class AgoraSettings {
  final AgoraConnectionData? connectionData;
  final List<AgoraUser> users;
  final bool isLocalUserMuted;
  final bool isLocalVideoDisabled;
  final bool visible;
  final bool isButtonVisible;

  AgoraSettings({
    this.connectionData,
    required this.users,
    required this.isLocalUserMuted,
    required this.isLocalVideoDisabled,
    required this.visible,
    required this.isButtonVisible,
  });

  AgoraSettings copyWith({
    AgoraConnectionData? connectionData,
    List<AgoraUser>? users,
    bool? isLocalUserMuted,
    bool? isLocalVideoDisabled,
    bool? visible,
    bool? isButtonVisible,
  }) {
    return AgoraSettings(
      connectionData: connectionData ?? this.connectionData,
      users: users ?? this.users,
      isLocalUserMuted: isLocalUserMuted ?? this.isLocalUserMuted,
      isLocalVideoDisabled: isLocalVideoDisabled ?? this.isLocalVideoDisabled,
      visible: visible ?? this.visible,
      isButtonVisible: isButtonVisible ?? this.isButtonVisible,
    );
  }
}
