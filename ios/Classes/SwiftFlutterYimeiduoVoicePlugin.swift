import Flutter
import UIKit

public class SwiftFlutterYimeiduoVoicePlugin: NSObject, FlutterPlugin {
    
    //注册
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_yimeiduo_voice", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterYimeiduoVoicePlugin()
        initVoiceFiles()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    //复制声音文件到/Sounds文件夹
    public static func initVoiceFiles(){
        //获取bundle
        let bundle = Bundle.init(for: YmdVoice.self).path(forResource: "voiceBundle", ofType: "bundle")
        //获取bundle
        let bundlePath = Bundle.init(path: bundle!)!.bundlePath
        //获取Libaray地址
        let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        //获取Sounds地址
        let url = path[0]
        //创建
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        //复制文件进去
        if(!FileManager.default.fileExists(atPath: url.path)){
            //没有复制进去就复制进去
            try? FileManager.default.copyItem(atPath: bundlePath , toPath: url.path)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //如果是播放
        if(call.method=="playVoice"){
            //参数
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
