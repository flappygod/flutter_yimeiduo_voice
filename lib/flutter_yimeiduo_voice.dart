import 'package:flutter/services.dart';
import 'dart:async';

//语音类型
enum VoiceType {
  //线下支付订单
  qrcodePayOrder,
  //新的配送订单
  newOnlineOrder,
  //新的自提订单
  newOfflineOrder,
  //订单退款
  refundOrder,
  //流失的订单
  washedOrder,
}

//播放声音
class FlutterYimeiduoVoice {
  //channel
  static const MethodChannel _channel = MethodChannel('flutter_yimeiduo_voice');

  //播放声音
  static Future<void> playVoice(VoiceType voiceType, String voiceValue) async {
    //通知播放声音
    await _channel.invokeMethod('playVoice', {
      "voiceType": getOrderType(voiceType),
      "voiceValue": voiceValue,
    });
  }

  //订单类型
  static int getOrderType(VoiceType voiceType) {
    switch (voiceType) {
      case VoiceType.qrcodePayOrder:
        return 1;
      case VoiceType.newOnlineOrder:
        return 2;
      case VoiceType.newOfflineOrder:
        return 3;
      case VoiceType.refundOrder:
        return 4;
      case VoiceType.washedOrder:
        return 5;
    }
  }

  //声音类型
  static VoiceType getVoiceType(int type) {
    switch (type) {
      case 1:
        return VoiceType.qrcodePayOrder;
      case 2:
        return VoiceType.newOnlineOrder;
      case 3:
        return VoiceType.newOfflineOrder;
      case 4:
        return VoiceType.refundOrder;
      case 5:
        return VoiceType.washedOrder;
      default:
        return VoiceType.qrcodePayOrder;
    }
  }
}
