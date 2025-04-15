import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';

class ChatV2 extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? initFindingMsg;

  const ChatV2(
      {Key? key, required this.selectedConversation, this.initFindingMsg})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatV2State();
}

class _ChatV2State extends State<ChatV2> {
  final TIMUIKitChatController _controller = TIMUIKitChatController();
  final TIMUIKitHistoryMessageListController _historyMessageListController =
      TIMUIKitHistoryMessageListController();
  final TIMUIKitInputTextFieldController _textFieldController =
      TIMUIKitInputTextFieldController();
  bool _haveMoreData = true;
  bool isInit = false;

  String? _getConvID() {
    return widget.selectedConversation.type == 1
        ? widget.selectedConversation.userID
        : widget.selectedConversation.groupID;
  }

  Future<bool> loadHistoryMessageList(
      String? lastMsgID, LoadDirection direction,
      [int? count, int? lastSeq]) async {
    if (_haveMoreData) {
      _haveMoreData = await _controller.loadHistoryMessageList(
          count: count ?? 20,
          direction: direction,
          userID: widget.selectedConversation.userID,
          groupID: widget.selectedConversation.groupID,
          lastMsgID: lastMsgID);
    }

    return _haveMoreData;
  }

  @override
  Widget build(BuildContext context) {
    final isBuild = isInit;
    isInit = true;
    return TIMUIKitChatProviderScope(
      isBuild: isBuild,
      controller: _controller,
      // `TIMUIKitChatController` needs to be provided if you use it.
      config: const TIMUIKitChatConfig(
          // You can define anything here up to your business needs.
          ),
      conversationID: _getConvID() ?? "",
      conversationType: ConvType.values[widget.selectedConversation.type ?? 1],
      builder: (context, model, w) {
        return GestureDetector(
          onTap: () {
            _textFieldController.hideAllPanel();
          },
          child: Scaffold(
            appBar: TIMUIKitAppBar(
              config: AppBar(
                title: Text(widget.selectedConversation.showName ?? ""),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: TIMUIKitHistoryMessageListSelector(
                  conversationID: _getConvID() ?? "",
                  builder: (context, messageList, w) {
                    return TIMUIKitHistoryMessageList(
                      conversation: widget.selectedConversation,
                      model: model,
                      controller: _historyMessageListController,
                      messageList: messageList,
                      onLoadMore: loadHistoryMessageList,
                      itemBuilder: (context, message) {
                        return TIMUIKitHistoryMessageListItem(
                          // messageItemBuilder: MessageItemBuilder(
                          //   textReplyMessageItemBuilder:
                          //       (message, isShowJump, clearJump) {},
                          // ),
                          // themeData: MessageThemeData(
                          //     messageBackgroundColor: Colors.black,
                          //     messageTextStyle: TextStyle(color: Colors.redAccent)),
                          topRowBuilder: (context, message) {
                            return const Row(
                              children: [Text("this is top Raw builder")],
                            );
                          },
                          showMessageReadReceipt: false,
                          onScrollToIndex:
                              _historyMessageListController.scrollToIndex,
                          onScrollToIndexBegin:
                              _historyMessageListController.scrollToIndexBegin,
                          message: message!,
                          // onTapAvatar: widget.onTapAvatar,
                          // showNickName: widget.showNickName,
                          // messageItemBuilder: widget.messageItemBuilder,
                          // onLongPressForOthersHeadPortrait:
                          //     widget.onLongPressForOthersHeadPortrait,
                          // onMsgSendFailIconTap: widget.onMsgSendFailIconTap,
                        );
                      },
                    );
                  },
                )),
                TIMUIKitInputTextField(
                  currentConversation: widget.selectedConversation,
                  model: model,
                  controller: _textFieldController,
                  conversationID: _getConvID() ?? "",
                  conversationType:
                      ConvType.values[widget.selectedConversation.type ?? 1],
                  scrollController:
                      _historyMessageListController.scrollController!,
                  hintText: "",
                  // showSendAudio: false,
                  // showSendEmoji: false,
                )
              ],
            ),
            // body: Container(),
          ),
        );
      },
    );
  }
}
