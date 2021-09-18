import 'package:flutter_yimeiduo_voice/flutter_yimeiduo_voice.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _playVoice,
          child: const Center(
            child: Text('Click To Play'),
          ),
        ),
      ),
    );
  }

  //播放声音
  void _playVoice() {
    FlutterYimeiduoVoice.playVoice(VoiceType.qrcodePayOrder, "567.55");
  }
}
