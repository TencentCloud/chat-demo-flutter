import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/calling_message_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

class RenderCustomMessage extends StatefulWidget {
  final V2TimMessage message;
  final BuildContext context;
  const RenderCustomMessage({super.key,
  required this.message, required this.context});

  @override
  State<RenderCustomMessage> createState() => _RenderCustomMessageState();
}

class _RenderCustomMessageState extends State<RenderCustomMessage> {

  String display = TIM_t("[自定义]");

  @override
  initState() {
    super.initState();
    _handleCustomMessage(widget.message);
  }

  _handleCustomMessage(V2TimMessage message) async {
    V2TimValueCallback<List<V2TimMessage>> historyMessageCallBack;
    if (message.groupID != null && message.groupID!.isNotEmpty) {
      historyMessageCallBack = await TencentImSDKPlugin.v2TIMManager.v2TIMMessageManager.getGroupHistoryMessageList(count: 10, groupID: message.groupID!) ;
    } else {
      historyMessageCallBack = await TencentImSDKPlugin.v2TIMManager.v2TIMMessageManager.getC2CHistoryMessageList(count: 10, userID: message.userID!);
    }
    List<V2TimMessage>? historyMessageList = historyMessageCallBack.data;

    if (historyMessageList == null || historyMessageList.isEmpty) {
      display = TIM_t("[自定义]");
      return;
    }

    V2TimMessage? lastMessage;
    for(var msg in historyMessageList) {
      final callingMessageDataProvider = CallingMessageDataProvider(msg);
      if(!callingMessageDataProvider.isCallingSignal || !callingMessageDataProvider.excludeFromHistory) {
        lastMessage = msg;
        break;
      }
    }

    if (lastMessage != null) {
      final customElem = lastMessage.customElem;

      if (customElem?.data == "group_create") {
        display = TIM_t("群聊创建成功！");
      }
      if (TencentCloudChatVotePlugin.isVoteMessage(message)) {
        display =
            TencentCloudChatVotePlugin.getConversationLastMessageInfo(message);
      }

      final callingMessageDataProvider = CallingMessageDataProvider(message);
      if (callingMessageDataProvider.isCallingSignal) {
        display = callingMessageDataProvider.content;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(widget.context).theme;
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(widget.context) == DeviceType.Desktop;

    return Row(children: [
      Expanded(
          child: Text(
            display,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                height: 1,
                color: theme.weakTextColor,
                fontSize: isWideScreen ? 12 : 14),
          )),
    ]);
  }
}
