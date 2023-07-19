// ignore_for_file: unused_import

import 'package:tencent_chat_push_for_china/model/appInfo.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_chat_push_for_china/tencent_chat_push_for_china.dart';
import 'package:tencent_cloud_chat_demo/utils/push/push_constant.dart';

class ChannelPush {
  static final TimUiKitPushPlugin cPush = TimUiKitPushPlugin();

  static init(PushClickAction pushClickAction) async {
    await cPush.init(
      pushClickAction: pushClickAction,
      appInfo: PushConfig.appInfo,
    );

    cPush.createNotificationChannel(
        channelId: "new_message",
        channelName: "消息推送",
        channelDescription: "推送新聊天消息");
    cPush.createNotificationChannel(
        channelId: "high_system",
        channelName: "新消息提醒",
        channelDescription: "推送新聊天消息");
    return;
  }

  static requestPermission() {
    cPush.requireNotificationPermission();
  }

  static Future<String> getDeviceToken() async {
    return cPush.getDevicePushToken();
  }

  static setBadgeNum(int badgeNum) {
    return cPush.setBadgeNum(badgeNum);
  }

  static clearAllNotification() {
    return cPush.clearAllNotification();
  }

  static Future<bool> uploadToken(PushAppInfo appInfo) async {
    return cPush.uploadToken(appInfo);
  }
}
