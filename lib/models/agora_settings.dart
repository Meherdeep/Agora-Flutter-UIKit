import 'package:agora_rtc_engine/rtc_engine.dart';

import 'package:agora_flutter_uikit/models/agora_connection_data.dart';

import 'agora_user.dart';

class AgoraSettings {
  final RtcEngine? engine;
  final AgoraConnectionData? connectionData;
  final List<AgoraUser> users;
  final bool isLocalUserMuted;
  final bool isLocalVideoDisabled;
  final bool visible;
  final bool isButtonVisible;
  final ClientRole clientRole;
  final int maxUid;
  final int localUid;
  String? generatedToken;

  AgoraSettings({
    this.engine,
    this.connectionData,
    required this.users,
    required this.isLocalUserMuted,
    required this.isLocalVideoDisabled,
    required this.visible,
    required this.isButtonVisible,
    required this.clientRole,
    required this.maxUid,
    required this.localUid,
    this.generatedToken,
  });

  AgoraSettings copyWith({
    RtcEngine? engine,
    AgoraConnectionData? connectionData,
    List<AgoraUser>? users,
    bool? isLocalUserMuted,
    bool? isLocalVideoDisabled,
    bool? visible,
    bool? isButtonVisible,
    ClientRole? clientRole,
    int? maxUid,
    int? localUid,
    String? generatedToken,
  }) {
    return AgoraSettings(
      engine: engine ?? this.engine,
      connectionData: connectionData ?? this.connectionData,
      users: users ?? this.users,
      isLocalUserMuted: isLocalUserMuted ?? this.isLocalUserMuted,
      isLocalVideoDisabled: isLocalVideoDisabled ?? this.isLocalVideoDisabled,
      visible: visible ?? this.visible,
      isButtonVisible: isButtonVisible ?? this.isButtonVisible,
      clientRole: clientRole ?? this.clientRole,
      maxUid: maxUid ?? this.maxUid,
      localUid: localUid ?? this.localUid,
      generatedToken: generatedToken ?? this.generatedToken,
    );
  }
}
