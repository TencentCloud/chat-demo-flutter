import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/chat.dart';

import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class GroupList extends StatelessWidget {
  final sdkInstance = TIMUIKitCore.getSDKInstance();
  final void Function(V2TimGroupInfo groupInfo, V2TimConversation conversation)?
      onTapItem;

  GroupList({Key? key, this.onTapItem}) : super(key: key);

  _jumpToChatPage(BuildContext context, V2TimGroupInfo groupInfo,
      V2TimConversation conversation) async {
    if (onTapItem != null) {
      onTapItem!(groupInfo, conversation);
    } else {
      final res = await sdkInstance
          .getConversationManager()
          .getConversation(conversationID: "group_${groupInfo.groupID}");
      if (res.code == 0) {
        final conversation = res.data;
        if (conversation != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(selectedConversation: conversation),
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    Widget groupList() {
      return TIMUIKitGroup(
        onTapItem: (groupInfo, conversation) {
          _jumpToChatPage(context, groupInfo, conversation);
        },
        emptyBuilder: (_) {
          return Center(
            child: Text(TIM_t("暂无群聊")),
          );
        },
        groupCollector: (groupInfo) {
          final groupID = groupInfo?.groupID ?? "";
          return !groupID.contains("im_discuss_");
        },
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: groupList(),
        defaultWidget: Scaffold(
          appBar: AppBar(
              title: Text(
                TIM_t("群聊"),
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
          body: groupList(),
        ));
  }
}
