import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //注册
        GeneratedPluginRegistrant.register(with: self)
        
        //注册本地推送
        UNUserNotificationCenter.current().requestAuthorization(options:[.sound, .badge, .alert]) { (success, error) in
            
        }
        //设置代理
        UNUserNotificationCenter.current().delegate = self
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    //iOS10新增：处理前台收到通知的代理方法
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound, .badge, .alert])
        
    }
    
    
    //iOS10新增：处理后台点击通知的代理方法
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
}

