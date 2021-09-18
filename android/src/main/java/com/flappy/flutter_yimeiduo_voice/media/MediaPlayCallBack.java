package com.flappy.flutter_yimeiduo_voice.media;

public interface MediaPlayCallBack {
    public static final int STATE_START 	= 0; // STATE 音频播放状态
    public static final int STATE_PLAY 		= 1;
    public static final int STATE_PAUSE 	= 2;
    public static final int STATE_STOP 		= 3;
    public static final int STATE_CUT 		= 4;

    public static final int TYPE_PATH 		= 0; // TYPE 列表或者单个文件
    public static final int TYPE_ID 		= 1;

    /**
     * @param type     播放模式
     * @param state    播放状态
     * @param position 当前播放的第几个音频
     * */
    public void mediaPlayCallBack( int type, int state, int position );
}