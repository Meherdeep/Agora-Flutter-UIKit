class AgoraFunctions {
  Function(int, int) userJoined;
  AgoraFunctions({
    required this.userJoined,
  });

  AgoraFunctions copyWith({
    Function(int, int)? userJoined,
  }) {
    return AgoraFunctions(
      userJoined: userJoined ?? this.userJoined,
    );
  }
}
