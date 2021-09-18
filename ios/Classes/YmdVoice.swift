//
//  YmdVoice.swift
//  ymdbusiness
//
//  Created by lijunlin on 2020/9/18.
//  Copyright © 2020 xxwheng. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class YmdVoice: NSObject {
    
    static let `default` = YmdVoice()
    
    
    static var lockObj:Int = 0
    
    //根据参数播放声音
    func playVoice( voiceType:Int ,voiceValue:String ){
        var filesArray = [String]()
        //修改
        if voiceType == 1 {
            /// 支付语音播报文件
            filesArray = self.voiceOfMoney(money:voiceValue)
        }
        /// 您有一笔配送订单需要及时处理，请查看
        else if voiceType == 2 {
            filesArray = ["tts_neworder"]
        }
        /// 您有一笔自提订单需要及时处理，请查看
        else if voiceType == 3 {
            filesArray = ["tts_new_zitiorder"]
        }
        /// 您有一笔自提订单需要及时处理，请查看
        else if voiceType == 4 {
            filesArray = ["tts_refundorder"]
        }
        /// 您有一笔自提订单需要及时处理，请查看
        else if voiceType == 5 {
            filesArray = ["tts_refundorder_nottake"]
        }
        let myThread = Thread(target:self,selector:#selector(self.playVoiceArray(_:)),object:filesArray)
        myThread.start()
    }
    
    
    /// 金额的声音数组
    func voiceOfMoney(money:String) -> [String] {
        //首先取得中文
        let chinese=self.chineseOfMoney(money: money)
        //然后进行拼接
        var audioFiles:[String]=[String]()
        //播放第一条语音
        audioFiles.append("tts_pre")
        //转换为数组
        for i in 0...chinese.count-1 {
            var str = String(chinese[chinese.index(chinese.startIndex, offsetBy: i)])
            if ( str=="零" ){
                str = "0";
            }else if( str=="十" ){
                str = "ten";
            }else if( str=="百" ){
                str = "hundred";
            }else if( str=="千" ){
                str = "thousand";
            }else if( str=="万" ){
                str = "ten_thousand";
            }else if( str=="点" ){
                str = "dot";
            }else if( str=="元" ){
                str = "yuan";
            }
            audioFiles.append(String(format: "tts_%@",str))
        }
        //返回数据
        return audioFiles
    }
    
    /// 根据我们的算法，算出金额，翻译于oc代码
    func chineseOfMoney(money:String ) -> String  {
        let numberchar:[String] = ["0","1","2","3","4","5","6","7","8","9"]
        let inunitchar:[String] =  ["","十","百","千"]
        let unitname:[String] =  ["","万","亿"]
        let valstr=String(format: "%.2f", (money as NSString).doubleValue)
        var prefix=""
        // 将金额分为整数部分和小数部分
        let count=valstr.count;
        let head=valstr.prefix(count-3)
        let foot=valstr.suffix(2)
        //只支持到千万，抱歉哈
        if (head.count>8) {
            return "";
        }
        // 处理整数部分
        if(head == "0") {
            prefix = "0"
        }else{
            let ch:NSMutableArray=NSMutableArray.init()
            for index in 0...head.count-1 {
                //ascall码转换
                let str=String(format: "%x", (head as NSString).character(at: index)-48)
                ch.add(str)
            }
            var zeronum=0
            for i in 0...ch.count-1{
                let index = (ch.count-1 - i)%4 ;
                let indexloc = (ch.count-1 - i)/4 ;
                
                if( ch.object(at: i) as! String=="0" ){
                    zeronum += 1
                }else{
                    if (zeronum != 0) {
                        if (index != 3) {
                            prefix=prefix.appending("零");
                        }
                        zeronum = 0;
                    }
                    let memone:Int=Int((ch.object(at: i) as! NSString).intValue)
                    prefix=prefix.appending(numberchar[memone])
                    prefix=prefix.appending(inunitchar[index])
                    if( index == 0 && zeronum < 4 ){
                        prefix=prefix.appending(unitname[indexloc])
                    }
                }
                
            }
        }
        //如果是零，直接不要零零了
        if( foot == "00"){
            prefix = prefix.appending("元")
        }else{
            prefix = prefix.appending(String(format: "点%@元",(foot as NSString)))
        }
        //这个只是翻译没有仔细看，写个备注以表尊敬
        if( prefix.hasPrefix("1十") ){
            prefix=prefix.replacingOccurrences(of: "1十", with: "十")
        }
        return prefix
    }
    
    /// 金额 赚语音文件 列表
    func voiceFilesFromMoney(_ money: String) -> [String] {
        
        if let total = Double(money), total >= 100000 {
            return ["pre"]
        }
        
        /// 将要播报的语音文件
        var filesArray = [String]()
        /// 一美多到账
        
        let ddArr = money.split(separator: ".")
        /// 百位以上
        var hundred = "0"
        /// 百位以下
        var last = ""
        
        // 是否有小数
        if ddArr.count == 1 { // 没有小数
            hundred = "\(Int(ddArr[0])!/100)"
            last = "\(Int(ddArr[0])!%100)"
        } else if ddArr.count == 2 { // 有小数
            hundred = "\(Int(ddArr[0])!/100)"
            
            /// 处理小数点尾数是0的问题
            var pointStr = "." + String(ddArr[1])
            while String(pointStr.last!)=="0" {
                pointStr = String(pointStr.prefix(pointStr.count-1))
            }
            if pointStr == "." {
                last = "\(Int(ddArr[0])!%100)"
            } else {
                last = "\(Int(ddArr[0])!%100)" + pointStr
            }
        }
        if Int(hundred)! > 0 {
            filesArray = self.getBigFileStrArray(num: Int(hundred)!)
            if let hasLastNum = Double(last), hasLastNum > 0 {
                filesArray.append("\(last)yuan")
            } else {
                filesArray.append("yuan")
            }
        } else {
            /// 百位以内，直接找last文件
            filesArray = ["\(last)yuan"]
        }
        
        filesArray.insert("pre", at: 0)
        return filesArray
        
    }
    
    /// 播报语音文件
    @objc func playVoiceArray(_ filesArray: [String]) {
        
        let  dat:Date = Date.init(timeIntervalSinceNow: 0)
        let  a:TimeInterval = dat.timeIntervalSince1970;
        let  timep:Int = Int(a)
        let  timeLeft:Int = timep - YmdVoice.lockObj
        //如果大于
        if timeLeft > 0{
            YmdVoice.lockObj = timep + 5
        }else{
            YmdVoice.lockObj = YmdVoice.lockObj + 5
            let delay:Double=(Double)(YmdVoice.lockObj - 5 - timep)
            if delay > 0 {
                Thread.sleep(forTimeInterval:  delay)
            }
        }
        
        //定义最后读的文件
        var lastFile = ""
        //间隔时间
        var nextDuration  = 0.0
        //主要队列
        let newque:DispatchQueue=DispatchQueue.main
        
        for i in 0..<filesArray.count {
            let semaphore = DispatchSemaphore.init(value: 0)
            if i > 1 && filesArray.count > 2 {
                
                if(lastFile == "tts_dot"){
                    nextDuration = 0.34
                }else if(lastFile == "tts_ten"){
                    nextDuration = 0.34
                }else if(lastFile.hasPrefix("tts_handred")){
                    nextDuration = 0.34
                }else if(lastFile.hasPrefix("tts_ten_thousand")){
                    nextDuration = 0.34
                }else{
                    nextDuration = 0.40
                }
                //防止同一个文件被覆盖了不播放，这里贱贱的加两套文件
                if lastFile == filesArray[i]{
                    lastFile=filesArray[i].appending("_more")
                }
                else{
                    lastFile=filesArray[i]
                }
            } else if i == 1 {
                nextDuration = 1.35
                lastFile=filesArray[i]
            }else{
                lastFile=filesArray[i]
            }
            
            //秒后执行
            newque.asyncAfter(deadline: .now()+nextDuration, execute: {
                self.registerNotification(string: lastFile, handler: {
                    //下一个
                    semaphore.signal()
                })
            })
            //等待nextDuration
            semaphore.wait()
        }
    }
    
    /// 百 千 万 音频
    var bigVoiceArray = ["hundred","thounds","ten_thounds"]
    /// 获取百位及以上语音文件
    func getBigFileStrArray(num: Int) -> [String] {
        var bigNum = num
        var resArr = [String]()
        var unit = 0
        while bigNum > 0 {
            let fileNum = bigNum%10
            if fileNum > 0 {
                resArr.insert("\(fileNum)\(bigVoiceArray[unit])", at: 0)
            }
            unit += 1
            bigNum /= 10
            if unit > 2 {
                break;
            }
        }
        return resArr
    }
    
    
    /// 发送本地通知
    func registerNotification(string: String, handler: @escaping()->Void) {
        let opts: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: opts) { (granted, error) in
            if granted {
                let content = UNMutableNotificationContent.init()
                //不需要title
                content.title = ""
                //不需要subtitle
                content.subtitle = ""
                //不需要body
                content.body = ""
                //获取bundle
                let bundle = Bundle.init(for: YmdVoice.self).path(forResource: "voiceBundle", ofType: "bundle")
                //获取bundle
                let bundlePath = Bundle.init(path: bundle!)!.bundlePath
                //获取Libaray地址
                let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
                //获取Sounds地址
                let url = path[0].appendingPathComponent("Sounds", isDirectory: true)
                //创建
                try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
                //复制文件进去
                if(!FileManager.default.fileExists(atPath: url.path + "/\(string).mp3")){
                    //没有复制进去就复制进去
                    try? FileManager.default.copyItem(atPath: bundlePath + "/\(string).mp3", toPath: url.path + "/\(string).mp3")
                }
                content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init("/\(string).mp3"))
                let indentifier = "categoryIndentifier\(string)"
                content.categoryIdentifier = indentifier
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.01, repeats: false)
                let request = UNNotificationRequest.init(identifier: indentifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    handler()
                }
            }else{
                handler()
            }
        }
    }
    
}
