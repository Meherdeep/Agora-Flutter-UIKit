import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraUser {
  int uid;
  final bool remote;
  final bool muted;
  final bool videoDisabled;
  final ClientRole clientRole;

  AgoraUser({
    required this.uid,
    required this.remote,
    required this.muted,
    required this.videoDisabled,
    required this.clientRole,
  });

  AgoraUser copyWith({
    int? uid,
    bool? remote,
    bool? muted,
    bool? videoDisabled,
    ClientRole? clientRole,
  }) {
    return AgoraUser(
      uid: uid ?? this.uid,
      remote: remote ?? this.remote,
      muted: muted ?? this.muted,
      videoDisabled: videoDisabled ?? this.videoDisabled,
      clientRole: clientRole ?? this.clientRole,
    );
  }
}
