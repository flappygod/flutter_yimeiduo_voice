package com.flappy.flutter_yimeiduo_voice.media;

import android.content.Context;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.os.Handler;
import android.os.Message;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MediaPlay {
    private MediaPlay() {
        // 禁止被外部类实例化
    }

    //播放音频
    public static void startMedia(Context context, int audioId) {
        stopMedia();
        mMediaPlayer = MediaPlayer.create(context, audioId);
        mMediaPlayer.start();
        mMediaPlayer.setOnCompletionListener(new OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                if (null != mp) {
                    mp.stop();
                    mp.release();
                }
                mMediaPlayer = null;
            }
        });
    }

    //handler
    private static Handler handler = new Handler() {
        public void handleMessage(Message message) {
            //等待多久
            try {
                int s = message.what;
                ArrayList<MediaPlayer> mediaPlayers = (ArrayList<MediaPlayer>) message.obj;
                //开始播放
                mediaPlayers.get(s).start();
                if (s - 1 >= 0) {
                    mediaPlayers.get(s - 1).stop();
                    mediaPlayers.get(s - 1).release();
                }
                if (s == mediaPlayers.size() - 1) {
                    mediaPlayers.get(s).setOnCompletionListener(new OnCompletionListener() {
                        @Override
                        public void onCompletion(MediaPlayer mp) {
                            if (mp != null) {
                                mp.stop();
                                mp.release();
                            }
                        }
                    });
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };

    //开始播放一个列表
    public static void startMediaPlayList(Context context, ArrayList<MediaPlayModel> playList) {
        if (null == playList || playList.size() == 0) {
            return;
        }
        List<MediaPlayer> mediaPlayers = new ArrayList<>();
        for (int s = 0; s < playList.size(); s++) {
            MediaPlayer mMediaPlayer = MediaPlayer.create(context, playList.get(s).resourceID);
            mMediaPlayer.setVolume(1.0f, 1.0f);
            try {
                mMediaPlayer.prepare();
            } catch (IllegalStateException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            mediaPlayers.add(mMediaPlayer);
        }
        new Thread() {
            public void run() {
                for (int s = 0; s < playList.size(); s++) {

                    Message message = handler.obtainMessage(s, mediaPlayers);
                    handler.sendMessage(message);
                    try {
                        Thread.sleep(playList.get(s).duration);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }.start();

    }

    //开始播放一个列表
    public static void startMediaPlayList(Context context, MediaPlayCallBack soundPlayCallBack, ArrayList<Integer> playList, int startIndex) {
        if (null == playList || playList.size() == 0 || startIndex >= playList.size()) {
            return;
        }
        mMediaPlayerCallBack = soundPlayCallBack;
        mAudioPlayIdList = new ArrayList<Integer>();
        mAudioPlayIdList = playList;
        mCurrentListIndex = startIndex;
        if (null != mMediaPlayerCallBack) {
            mMediaPlayerCallBack.mediaPlayCallBack(MediaPlayCallBack.TYPE_ID, MediaPlayCallBack.STATE_START, 0);
        }
        startMediaId(context, mAudioPlayIdList.get(mCurrentListIndex));
    }

    //开始播放
    private static void startMediaId(final Context context, int audioId) {
        mMediaPlayer = MediaPlayer.create(context, audioId);
        try {
            mMediaPlayer.prepare();
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        mMediaPlayer.start();
        mMediaPlayer.setOnCompletionListener(new OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                if (null != mp) {
                    mp.stop();
                    mp.release();
                }
                mMediaPlayer = null;
                if (null != mAudioPlayIdList) {
                    mCurrentListIndex++;
                    if (mCurrentListIndex < mAudioPlayIdList.size()) {
                        mMediaPlayerCallBack.mediaPlayCallBack(MediaPlayCallBack.TYPE_ID, MediaPlayCallBack.STATE_CUT, mCurrentListIndex);
                        startMediaId(context, mAudioPlayIdList.get(mCurrentListIndex));
                    } else {
                        if (null != mMediaPlayerCallBack) {
                            mMediaPlayerCallBack.mediaPlayCallBack(MediaPlayCallBack.TYPE_ID, MediaPlayCallBack.STATE_STOP, mAudioPlayIdList.size());
                        }
                    }
                }
            }
        });
    }

    //停止播放
    public static void stopMedia() {
        if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {
            mMediaPlayer.stop();
            mMediaPlayer = null;

            if (null != mAudioPlayIdList) {
                if (null != mMediaPlayerCallBack) {
                    mMediaPlayerCallBack.mediaPlayCallBack(MediaPlayCallBack.TYPE_ID, MediaPlayCallBack.STATE_PAUSE, -1);
                    mMediaPlayerCallBack = null;
                }
                mAudioPlayIdList = null;
            }
            mCurrentListIndex = 0;
            if (null != mMediaPlayerCallBack) {
                mMediaPlayerCallBack.mediaPlayCallBack(MediaPlayCallBack.TYPE_PATH, MediaPlayCallBack.STATE_PAUSE, -1);
            }
        }
    }


    private static int mCurrentListIndex = 0;
    private static MediaPlayer mMediaPlayer = null;
    private static MediaPlayCallBack mMediaPlayerCallBack = null;
    private static ArrayList<Integer> mAudioPlayIdList = null;
}