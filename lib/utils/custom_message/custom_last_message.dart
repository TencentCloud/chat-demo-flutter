import 'package:flutter/cupertino.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/calling_message_data_provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';

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

  @override
  void didUpdateWidget(covariant RenderCustomMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.message != widget.message){
      _handleCustomMessage(widget.message);
    }
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
      } else if (MessageUtils.getCustomGroupCreatedOrDismissedString(message).isNotEmpty) {
        display = MessageUtils.getCustomGroupCreatedOrDismissedString(message);
      } else if (CallingMessageDataProvider(message).isCallingSignal) {
        display = CallingMessageDataProvider(message).content;
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
