
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_demo/src/multi_platform_widget/search_entry/search_entry_narrow.dart';
import 'package:tencent_cloud_chat_demo/src/multi_platform_widget/search_entry/search_entry_wide.dart';

class SearchEntry extends StatefulWidget{
  final TIMUIKitConversationController conversationController;
  final PlusType? plusType;
  final VoidCallback? onClickSearch;
  final ValueChanged<V2TimConversation>? directToChat;
  const SearchEntry({Key? key, required this.conversationController, this.plusType, this.onClickSearch, this.directToChat}) : super(key: key);

  @override
  State<SearchEntry> createState() => _SearchEntryState();
}

class _SearchEntryState extends State<SearchEntry> {

  @override
  Widget build(BuildContext context) {
    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        defaultWidget: SearchEntryNarrow(
            conversationController: widget.conversationController),
        desktopWidget: SearchEntryWide(
          onClickSearch: widget.onClickSearch,
            directToChat: widget.directToChat,
            conversationController: widget.conversationController, plusType: widget.plusType),
        mobileWidget: SearchEntryNarrow(
            conversationController: widget.conversationController));
  }
}