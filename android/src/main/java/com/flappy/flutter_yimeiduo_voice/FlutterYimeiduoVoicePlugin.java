package com.flappy.flutter_yimeiduo_voice;

import com.flappy.flutter_yimeiduo_voice.media.MediaSpeak;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;

import androidx.annotation.NonNull;

import android.content.Context;
import android.app.Activity;

/**
 * FlutterYimeiduoVoicePlugin
 */
public class FlutterYimeiduoVoicePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    //上下文
    private Context context;

    //当前activity
    private Activity activity;

    //binding
    private ActivityPluginBinding activityPluginBinding;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_yimeiduo_voice");
        channel.setMethodCallHandler(this);
        this.context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        context = null;
        activity = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        addBinding(binding);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        addBinding(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onDetachedFromActivity() {
        removeBinding();
    }

    //绑定关系
    private void addBinding(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        activityPluginBinding = binding;
    }

    //移除关系
    private void removeBinding() {
        activity = null;
        activityPluginBinding = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("playVoice")) {
            //声音类型
            int voiceType = call.argument("voiceType");
            //声音的值
            String voiceValue = call.argument("voiceValue");
            //播放语音
            MediaSpeak.speak(context, voiceType, voiceValue);
            //成功
            result.success(true);
        } else {
            result.notImplemented();
        }
    }

}
