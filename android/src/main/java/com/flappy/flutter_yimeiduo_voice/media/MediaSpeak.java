package com.flappy.flutter_yimeiduo_voice.media;

import com.flappy.flutter_yimeiduo_voice.R;

import java.text.DecimalFormat;

import android.content.Context;

import java.util.ArrayList;
import java.util.List;

//语音播报的声音
public class MediaSpeak {


    //播放本地语音
    public static void speak(Context context, int voiceType, String voiceValue) {
        if (voiceType == 1) {
            String amount = voiceValue;
            double price = Double.parseDouble(amount);
            //构造方法的字符格式这里如果小数不足2位,会以0补足.  ".00"  "##.00"
            DecimalFormat decimalFormat = new DecimalFormat("##0.00");
            amount = decimalFormat.format(price);
            ArrayList<Integer> playArray = voiceOfMoney(amount);
            ArrayList<MediaPlayModel> playModels = new ArrayList<>();
            for (int s = 0; s < playArray.size(); s++) {
                MediaPlayModel model = new MediaPlayModel();
                model.resourceID = playArray.get(s);
                //第一句长
                if (s == 0) {
                    model.duration = 1800;
                } else {
                    model.duration = 345;
                }
                //如果是单位就变短
                if (model.resourceID == R.raw.tts_hundred ||
                        model.resourceID == R.raw.tts_ten ||
                        model.resourceID == R.raw.tts_ten_thousand ||
                        model.resourceID == R.raw.tts_thousand) {
                    model.duration = 360;
                    if (s - 1 > 0) {
                        playModels.get(s - 1).duration = 320;
                    }
                }
                playModels.add(model);
            }
            MediaPlay.startMediaPlayList(context, playModels);
        }
        if (voiceType == 2) {
            MediaPlay.startMedia(context, R.raw.tts_neworder);
        }
        if (voiceType == 3) {
            MediaPlay.startMedia(context, R.raw.tts_new_zitiorder);
        }
        if (voiceType == 4) {
            MediaPlay.startMedia(context, R.raw.tts_refundorder);
        }
        if (voiceType == 5) {
            MediaPlay.startMedia(context, R.raw.tts_refundorder_nottake);
        }
    }

    //转换
    private static ArrayList<Integer> voiceOfMoney(String amount) {

        String chinese = chineseOfMoney(amount);
        ArrayList<Integer> audioFiles = new ArrayList<>();
        audioFiles.add(R.raw.tts_pre);
        for (int s = 0; s < chinese.length(); s++) {
            int resource = 0;
            String str = chinese.substring(s, s + 1);
            if (str.equals("0")) {
                resource = R.raw.tts_0;
            } else if (str.equals("1")) {
                resource = R.raw.tts_1;
            } else if (str.equals("2")) {
                resource = R.raw.tts_2;
            } else if (str.equals("3")) {
                resource = R.raw.tts_3;
            } else if (str.equals("4")) {
                resource = R.raw.tts_4;
            } else if (str.equals("5")) {
                resource = R.raw.tts_5;
            } else if (str.equals("6")) {
                resource = R.raw.tts_6;
            } else if (str.equals("7")) {
                resource = R.raw.tts_7;
            } else if (str.equals("8")) {
                resource = R.raw.tts_8;
            } else if (str.equals("9")) {
                resource = R.raw.tts_9;
            } else if (str.equals("零")) {
                resource = R.raw.tts_0;
            } else if (str.equals("十")) {
                resource = R.raw.tts_ten;
            } else if (str.equals("百")) {
                resource = R.raw.tts_hundred;
            } else if (str.equals("千")) {
                resource = R.raw.tts_thousand;
            } else if (str.equals("万")) {
                resource = R.raw.tts_ten_thousand;
            } else if (str.equals("点")) {
                resource = R.raw.tts_dot;
            } else if (str.equals("元")) {
                resource = R.raw.tts_yuan;
            }
            if (resource != 0) {
                audioFiles.add(resource);
            }
        }
        return audioFiles;
    }

    //组装声音
    private static String chineseOfMoney(String money) {
        String[] numberchar = new String[]{"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
        String[] inunitchar = new String[]{"", "十", "百", "千"};
        String[] unitname = new String[]{"", "万", "亿"};
        String prefix = "";
        String head = money.substring(0, money.length() - 3);
        String foot = money.substring(money.length() - 2, money.length());
        if (head.length() > 8) {
            return "";
        }
        if (head.equals("0")) {
            prefix = "0";
        } else {
            List<String> ch = new ArrayList<>();
            for (int s = 0; s < head.length(); s++) {
                int pos = head.charAt(s) - 48;
                String str = String.format("%x", pos);
                ch.add(str);
            }
            int zeronum = 0;
            for (int i = 0; i < ch.size(); i++) {
                int index = (ch.size() - 1 - i) % 4;
                int indexloc = (ch.size() - 1 - i) / 4;
                if (ch.get(i).equals("0")) {
                    zeronum += 1;
                } else {
                    if (zeronum != 0) {
                        if (index != 3) {
                            prefix = prefix + "零";
                        }
                        zeronum = 0;
                    }
                    int memone = Integer.parseInt(ch.get(i).toString());
                    prefix = prefix + numberchar[memone];
                    prefix = prefix + inunitchar[index];
                    if (index == 0 && zeronum < 4) {
                        prefix = prefix + unitname[indexloc];
                    }
                }
            }
        }
        if (foot.equals("00")) {
            prefix = prefix + "元";
        } else {
            prefix = prefix + "点" + foot + "元";
        }
        if (prefix.startsWith("1十")) {
            prefix = prefix.replace("1十", "十");
        }
        return prefix;
    }
}
