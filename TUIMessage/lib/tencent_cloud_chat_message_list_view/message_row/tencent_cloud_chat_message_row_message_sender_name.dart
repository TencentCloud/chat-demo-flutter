import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/data/theme/text_style/text_style.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_message_calling_message.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_contact_sdk.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_data_tools.dart';

class TencentCloudChatMessageRowMessageSenderName extends StatefulWidget {
  final MessageRowMessageSenderNameBuilderData data;
  final MessageRowMessageSenderNameBuilderMethods methods;

  const TencentCloudChatMessageRowMessageSenderName({super.key, required this.data, required this.methods});

  @override
  State<TencentCloudChatMessageRowMessageSenderName> createState() =>
      _TencentCloudChatMessageRowMessageSenderNameState();
}

class _TencentCloudChatMessageRowMessageSenderNameState
    extends TencentCloudChatState<TencentCloudChatMessageRowMessageSenderName> {

  Future<String> _getCallMessageSenderName(V2TimMessage message) async {
    final callingMessage = CallingMessage.getCallMessage(message);
    if (callingMessage != null &&
        callingMessage.isCallingSignal &&
        callingMessage.participantType == CallParticipantType.c2c) {

      if (callingMessage.direction == CallMessageDirection.outcoming) {
        final currentUser = TencentCloudChat.instance.dataInstance.basic.currentUser;
        return currentUser?.nickName?.isNotEmpty == true
            ? currentUser!.nickName!
            : currentUser?.userID ?? "";
      } else {
        if (message.userID != null) {
          final userInfoList = await TencentCloudChatContactSDKGenerator.getInstance().getUsersInfo([message.userID!]);
          if (userInfoList.isNotEmpty) {
            final userInfo = userInfoList.first;
            return userInfo.nickName?.isNotEmpty == true
                ? userInfo.nickName!
                : userInfo.userID ?? message.userID!;
          }
        }
      }
    }

    // 非音视频通话消息，直接返回消息中的发送者名称
    return TencentCloudChatUtils.getMessageSenderName(message);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final isSelf = TencentCloudChatMessageDataTools.isMessageFromSelf(widget.data.message);
    return isSelf
        ? Container()
        : FutureBuilder<String>(
            future: _getCallMessageSenderName(widget.data.message),
            builder: (context, snapshot) {
              final senderName = snapshot.data ?? TencentCloudChatUtils.getMessageSenderName(widget.data.message);

              return TencentCloudChatThemeWidget(
               build:
                    (BuildContext context, TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) =>
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            senderName,
                            style: TextStyle(
                              height: 1,
                              color: colorTheme.secondaryTextColor,
                              fontSize: textStyle.fontsize_12,
                            ),
                          ),
                        ),
                  );
                },
    );
  }
}
