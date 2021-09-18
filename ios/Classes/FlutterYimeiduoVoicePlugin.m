#import "FlutterYimeiduoVoicePlugin.h"
#if __has_include(<flutter_yimeiduo_voice/flutter_yimeiduo_voice-Swift.h>)
#import <flutter_yimeiduo_voice/flutter_yimeiduo_voice-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_yimeiduo_voice-Swift.h"
#endif

@implementation FlutterYimeiduoVoicePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterYimeiduoVoicePlugin registerWithRegistrar:registrar];
}
@end
