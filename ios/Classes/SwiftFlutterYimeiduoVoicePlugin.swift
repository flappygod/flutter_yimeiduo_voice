import Flutter
import UIKit

public class SwiftFlutterYimeiduoVoicePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_yimeiduo_voice", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterYimeiduoVoicePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    //如果是播放
    if(call.method=="playVoice"){
        
        let arguments:Dictionary=call.arguments as! Dictionary<String, Any>
        //类型
        let voiceType:Int=arguments["voiceType"] as! Int
        //值
        let voiceValue:String=arguments["voiceValue"] as! String
        //播放声音
        YmdVoice.init().playVoice(voiceType: voiceType, voiceValue: voiceValue)
    
    }
    result(true)
  }
}
