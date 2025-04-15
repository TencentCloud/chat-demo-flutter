// ignore_for_file: unused_element, empty_catches

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/multi_platform_widget/search_entry/search_entry.dart';
import 'package:tencent_cloud_chat_demo/src/multi_platform_widget/search_entry/search_entry_wide.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/custom_last_message.dart';
import 'package:tencent_cloud_chat_demo/utils/user_guide.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

GlobalKey<_ConversationState> conversationKey = GlobalKey();

class Conversation extends StatefulWidget {
  final TIMUIKitConversationController conversationController;
  final ValueChanged<V2TimConversation?>? onConversationChanged;
  final VoidCallback? onClickSearch;
  final ValueChanged<Offset?>? onClickPlus;

  /// Used for specify the current conversation, usually used for showing the conversation indicator background color on wide screen.
  final V2TimConversation? selectedConversation;

  const Conversation(
      {Key? key,
      required this.conversationController,
      this.onConversationChanged,
      this.onClickSearch,
      this.onClickPlus,
      this.selectedConversation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  late TIMUIKitConversationController _controller;
  List<String> jumpedConversations = [];
  V2TimConversation? selectedConversation;

  @override
  void initState() {
    super.initState();
    _controller = widget.conversationController;
  }

  @override
  void didUpdateWidget(Conversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedConversation != oldWidget.selectedConversation) {
      Future.delayed(const Duration(milliseconds: 1), () {
        _controller.selectedConversation = widget.selectedConversation;
      });
    }
  }

  scrollToNextUnreadConversation() {
    final conversationList = _controller.conversationList;
    for (var element in conversationList) {
      if ((element?.unreadCount ?? 0) > 0 &&
          !jumpedConversations.contains(element!.conversationID)) {
        _controller.scrollToConversation(element.conversationID);
        jumpedConversations.add(element.conversationID);
        return;
      }
    }
    jumpedConversations.clear();
    try {
      _controller.scrollToConversation(conversationList[0]!.conversationID);
    } catch (e) {}
  }

  void _handleOnConvItemTaped(V2TimConversation? selectedConv) async {
    if (widget.onConversationChanged != null) {
      widget.onConversationChanged!(selectedConv);
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              selectedConversation: selectedConv!,
            ),
          ));
    }
  }

  _clearHistory(V2TimConversation conversationItem) {
    _controller.clearHistoryMessage(conversation: conversationItem);
  }

  _pinConversation(V2TimConversation conversation) {
    _controller.pinConversation(
        conversationID: conversation.conversationID,
        isPinned: !conversation.isPinned!);
  }

  _deleteConversation(V2TimConversation conversation) {
    _controller.deleteConversation(conversationID: conversation.conversationID);
  }

  List<ConversationItemSlidePanel> _itemSlidableBuilder(
      V2TimConversation conversationItem) {
    return [
      if (!PlatformUtils().isWeb)
        ConversationItemSlidePanel(
          onPressed: (context) {
            _clearHistory(conversationItem);
          },
          backgroundColor: hexToColor("006EFF"),
          foregroundColor: Colors.white,
          label: TIM_t("清除"),
          autoClose: true,
        ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _pinConversation(conversationItem);
        },
        backgroundColor: hexToColor("FF9C19"),
        foregroundColor: Colors.white,
        label: conversationItem.isPinned! ? TIM_t("取消置顶") : TIM_t("置顶"),
      ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _deleteConversation(conversationItem);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: TIM_t("删除"),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    judgeGuide('conversation', context);
    return Column(
      children: [
        SearchEntry(
          conversationController: widget.conversationController,
          plusType: PlusType.create,
          onClickSearch: widget.onClickSearch,
          directToChat: (conversation) {
            Future.delayed(const Duration(milliseconds: 1), () {
              _handleOnConvItemTaped(conversation);
              _controller.selectedConversation = widget.selectedConversation;
            });
          },
        ),
        Expanded(
          child: TIMUIKitConversation(
            conversationCollector: (element) => element?.userID != "10000",
            onTapItem: _handleOnConvItemTaped,
            isShowOnlineStatus: localSetting.isShowOnlineStatus,
            lastMessageBuilder: (lastMsg, groupAtInfoList) {
              if (lastMsg != null && lastMsg.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
                return RenderCustomMessage(message: lastMsg, context: context);
              }
              return null;
            },
            controller: _controller,
            emptyBuilder: () {
              return Container(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(TIM_t("暂无会话")),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
