import 'package:flutter/material.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/src/user_profile.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class AddFriend extends StatelessWidget {
  final ValueChanged<V2TimConversation>? directToChat;
  final VoidCallback? closeFunc;

  const AddFriend({Key? key, this.directToChat, this.closeFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: TIMUIKitAddFriend(
          closeFunc: closeFunc,
          onTapAlreadyFriendsItem: (String userID) async {
            final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
            final conversationID = "c2c_$userID";
            final res = await _sdkInstance.getConversationManager().getConversation(conversationID: conversationID);

            if (res.code == 0) {
              final conversation = res.data ?? V2TimConversation(conversationID: conversationID, userID: userID, type: 1);
              if (directToChat != null) {
                directToChat!(conversation);
              }
            }
          },
        ),
        defaultWidget: Scaffold(
          appBar: AppBar(
            shadowColor: Colors.white,
            title: Text(
              TIM_t("添加好友"),
              style: TextStyle(color: hexToColor("1f2329"), fontSize: 16),
            ),
            backgroundColor: hexToColor("f2f3f5"),
            leading: IconButton(
              padding: const EdgeInsets.only(left: 16),
              icon: Icon(
                Icons.arrow_back_ios,
                color: hexToColor("2a2e35"),
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: TIMUIKitAddFriend(
            onTapAlreadyFriendsItem: (String userID) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(userID: userID),
                  ));
            },
          ),
        ));
  }
}
