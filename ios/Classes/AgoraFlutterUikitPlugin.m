#import "AgoraFlutterUikitPlugin.h"
#if __has_include(<agora_flutter_uikit/agora_flutter_uikit-Swift.h>)
#import <agora_flutter_uikit/agora_flutter_uikit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "agora_flutter_uikit-Swift.h"
#endif

@implementation AgoraFlutterUikitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAgoraFlutterUikitPlugin registerWithRegistrar:registrar];
}
@end
