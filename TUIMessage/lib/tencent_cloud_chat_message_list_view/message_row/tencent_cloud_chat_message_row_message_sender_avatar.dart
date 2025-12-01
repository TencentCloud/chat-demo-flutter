import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_user_profile_options.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_platform_adapter.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/widgets/avatar/tencent_cloud_chat_avatar.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_message_calling_message.dart';
import 'package:tencent_cloud_chat_common/chat_sdk/components/tencent_cloud_chat_contact_sdk.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_data_tools.dart';

class TencentCloudChatMessageRowMessageSenderAvatar extends StatefulWidget {
  final MessageRowMessageSenderAvatarBuilderData data;
  final MessageRowMessageSenderAvatarBuilderMethods methods;
  bool showOthersAvatar = false;
  bool showSelfAvatar = false;

  TencentCloudChatMessageRowMessageSenderAvatar({super.key, required this.data, required this.methods, required this.showOthersAvatar, required this.showSelfAvatar});

  @override
  State<TencentCloudChatMessageRowMessageSenderAvatar> createState() =>
      _TencentCloudChatMessageRowMessageSenderAvatarState();
}

class _TencentCloudChatMessageRowMessageSenderAvatarState
    extends TencentCloudChatState<TencentCloudChatMessageRowMessageSenderAvatar> {
  TapDownDetails? _tapDownDetails;

  Future<String?> _getCallMessageFaceUrl(V2TimMessage message) async {
    final callingMessage = CallingMessage.getCallMessage(message);
    if (callingMessage != null &&
        callingMessage.isCallingSignal &&
        callingMessage.participantType == CallParticipantType.c2c) {

      if (callingMessage.direction == CallMessageDirection.outcoming) {
        return TencentCloudChat.instance.dataInstance.basic.currentUser?.faceUrl;
      } else {
        if (message.userID != null) {
          final userInfoList = await TencentCloudChatContactSDKGenerator.getInstance().getUsersInfo([message.userID!]);
          if (userInfoList.isNotEmpty) {
            return userInfoList.first.faceUrl;
          }
        }
      }
    }

    return message.faceUrl;
  }

  void _onTapAvatar() {
    if (TencentCloudChatUtils.checkString(widget.data.message.sender) != null) {
      if ( (!TencentCloudChatMessageDataTools.isMessageFromSelf(widget.data.message) && widget.showOthersAvatar) ) {
        navigateToUserProfile(context: context, options: TencentCloudChatUserProfileOptions(userID: widget.data.message.userID!));
      }
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final bool touchScreen = TencentCloudChatPlatformAdapter().isMobile ||
        (TencentCloudChatPlatformAdapter().isWeb &&
            TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.mobile);

    return FutureBuilder<String?>(
        future: _getCallMessageFaceUrl(widget.data.message),
    builder: (context, snapshot) {
      final faceUrl = snapshot.data ?? widget.data.message.faceUrl ?? "";

      return GestureDetector(
    onTapDown: (details) {
        _tapDownDetails = details;
      },
      onSecondaryTapDown: ((details) {
        _tapDownDetails = details;
      }),
      onTap: () {
        if (_tapDownDetails != null) {
          if (widget.methods.onCustomUIEventTapAvatar != null) {
            widget.methods.onCustomUIEventTapAvatar?.call(
              message: widget.data.message,
              tapDownDetails: _tapDownDetails!,
              userID: widget.data.userID,
              groupID: widget.data.groupID,
            );
          } else {
            _onTapAvatar();
          }
        }
      },

      onLongPress: () {
        if (touchScreen && _tapDownDetails != null) {
          widget.methods.onCustomUIEventLongPressAvatar?.call(
            message: widget.data.message,
            tapDownDetails: _tapDownDetails!,
            userID: widget.data.userID,
            groupID: widget.data.groupID,
          );
        }
      },

      child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
        scene: TencentCloudChatMessageDataTools.isMessageFromSelf(widget.data.message)
            ? TencentCloudChatAvatarScene.messageListForSelf
            : TencentCloudChatAvatarScene.messageListForOthers,
        imageList: [faceUrl],
        width: getSquareSize(36),
        height: getSquareSize(36),
        borderRadius: getSquareSize(18),
      ),
        );
      },
    );
  }
}
