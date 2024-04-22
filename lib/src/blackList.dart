// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/user_profile.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class BlackList extends StatelessWidget {
  const BlackList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    Widget blockedUsers() {
      return TIMUIKitBlackList(
        emptyBuilder: (_) {
          return Center(
            child: Text(TIM_t("暂无黑名单")),
          );
        },
        onTapItem: (V2TimFriendInfo friendInfo) {
          final isWideScreen =
              TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
          if (isWideScreen) {
            // TODO
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(userID: friendInfo.userID),
                ));
          }
        },
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: blockedUsers(),
        defaultWidget: Scaffold(
          appBar: AppBar(
              title: Text(
                TIM_t("黑名单"),
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              shadowColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                    theme.primaryColor ?? CommonColor.primaryColor
                  ]),
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              )),
          body: blockedUsers(),
        ));
  }
}
