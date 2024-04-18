import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation.dart';
import 'package:tencent_cloud_chat_demo/desktop/left_bar.dart';
import 'package:tencent_cloud_chat_demo/setting/tencent_cloud_chat_settings.dart';

final GlobalKey<TencentCloudChatDemoDesktopAppLayoutState> desktopAppLayoutKey =
    GlobalKey<TencentCloudChatDemoDesktopAppLayoutState>();

class TencentCloudChatDemoDesktopAppLayout extends StatefulWidget {
  final VoidCallback onLogOut;

  const TencentCloudChatDemoDesktopAppLayout({
    super.key,
    required this.onLogOut,
  });

  @override
  State<TencentCloudChatDemoDesktopAppLayout> createState() =>
      TencentCloudChatDemoDesktopAppLayoutState();
}

class TencentCloudChatDemoDesktopAppLayoutState
    extends TencentCloudChatState<TencentCloudChatDemoDesktopAppLayout> {
  int homePageIndex = 0;

  navigateToChat(
      {String? groupID,
      String? userID,
      V2TimConversation? conversation}) async {
    V2TimConversation? conv = conversation;
    if (conversation == null &&
        (TencentCloudChatUtils.checkString(groupID) != null ||
            TencentCloudChatUtils.checkString(userID) != null)) {
      conv = await TencentCloudChat.instance.chatSDKInstance.conversationSDK.getConversation(
        userID: userID,
        groupID: groupID,
      );
    }
    setState(() {
      homePageIndex = 0;
    });
    TencentCloudChat.instance.dataInstance.conversation.currentConversation = conv;
  }

  navigateToSettings(
      {String? groupID,
      String? userID,
      V2TimConversation? conversation}) async {
    setState(() {
      homePageIndex = 2;
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: TencentCloudChatThemeWidget(
          build: (BuildContext context, TencentCloudChatThemeColors colorTheme,
                  TencentCloudChatTextStyle textStyle) =>
              Row(
            children: [
              Container(
                width: 64,
                decoration: BoxDecoration(
                    color: colorTheme.desktopBackgroundColorLinearGradientOne),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: LeftBar(
                        index: homePageIndex,
                        onChange: (index) {
                          setState(() {
                            homePageIndex = index;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    if (TencentCloudChatPlatformAdapter().isWindows)
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: colorTheme
                                .desktopBackgroundColorLinearGradientOne),
                        child: Row(
                          children: [
                            Expanded(
                              child: MoveWindow(
                                child: Center(
                                  child: Text(
                                    tL10n.tencentCloudChat,
                                    style: TextStyle(
                                        color: colorTheme.onBackground,
                                        fontSize: textStyle.fontsize_14),
                                  ),
                                ),
                              ),
                            ),
                            MinimizeWindowButton(
                              colors: WindowButtonColors(
                                  iconNormal: colorTheme.onBackground),
                            ),
                            MaximizeWindowButton(
                              colors: WindowButtonColors(
                                  iconNormal: colorTheme.onBackground),
                            ),
                            CloseWindowButton(
                              colors: WindowButtonColors(
                                  iconNormal: colorTheme.onBackground),
                            )
                          ],
                        ),
                      ),
                    Expanded(
                        child: IndexedStack(
                      index: homePageIndex,
                      children: [
                        const TencentCloudChatConversation(),
                        const TencentCloudChatContact(),
                        TencentCloudChatSettings(
                          onLogOut: widget.onLogOut,
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
