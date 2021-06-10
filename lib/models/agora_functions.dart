import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraFunctions {
  Function userJoined;
  AgoraFunctions({
    required this.userJoined,
  });

  AgoraFunctions copyWith({
    Function? userJoined,
  }) {
    return AgoraFunctions(
      userJoined: userJoined ?? this.userJoined,
    );
  }
}
