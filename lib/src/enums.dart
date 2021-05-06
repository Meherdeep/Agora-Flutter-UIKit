enum EnabledPermission { camera, microphone, storage }
enum ChannelProfiles { Communication, LiveBroadcasting }
enum UserRole { Audience, Broadcaster }
enum RegionCode {
  /// Mainland China
  CN,

  /// North America
  NA,

  /// Europe
  EU,

  /// Asia, excluding Mainland China
  AS,

  /// Japan
  JP,

  /// India
  IN,

  /// (Default) Global
  GLOB,
}
enum Layout { Grid, Floating }
enum BuiltInButtons { CallEnd, SwitchCamera, ToggleCamera, ToggleMic }
