class CallUser {
  final int uid;
  final bool remote;
  final bool muted;
  final bool videoDisabled;

  CallUser({required this.uid, required this.remote, required this.muted, required this.videoDisabled});

  CallUser copyWith({
    int? uid,
    bool? remote,
    bool? muted,
    bool? videoDisabled,
  }) {
    return CallUser(
      uid: uid ?? this.uid,
      remote: remote ?? this.remote,
      muted: muted ?? this.muted,
      videoDisabled: videoDisabled ?? this.videoDisabled,
    );
  }
}
