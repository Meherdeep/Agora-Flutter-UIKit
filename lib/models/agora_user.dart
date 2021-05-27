class AgoraUser {
  final int uid;
  final bool remote;
  final bool muted;
  final bool videoDisabled;

  AgoraUser({required this.uid, required this.remote, required this.muted, required this.videoDisabled});

  AgoraUser copyWith({
    int? uid,
    bool? remote,
    bool? muted,
    bool? videoDisabled,
  }) {
    return AgoraUser(
      uid: uid ?? this.uid,
      remote: remote ?? this.remote,
      muted: muted ?? this.muted,
      videoDisabled: videoDisabled ?? this.videoDisabled,
    );
  }
}
