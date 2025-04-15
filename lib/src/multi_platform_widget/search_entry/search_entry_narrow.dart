import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/search.dart';

class SearchEntryNarrow extends StatefulWidget{
  final TIMUIKitConversationController conversationController;
  const SearchEntryNarrow({Key? key, required this.conversationController}) : super(key: key);

  @override
  State<SearchEntryNarrow> createState() => _SearchEntryNarrowState();
}

class _SearchEntryNarrowState extends State<SearchEntryNarrow> {
  late TIMUIKitConversationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.conversationController;
  }

  void _handleOnConvItemTapedWithPlace(V2TimConversation? selectedConv,
      [V2TimMessage? toMessage]) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            selectedConversation: selectedConv!,
            initFindingMsg: toMessage,
          ),
        ));
    _controller.reloadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    return GestureDetector(
      onTap: () async {
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        SharedPreferences prefs = await _prefs;
        List<String> guideList = prefs.getStringList('guidedPage') ?? [];
        bool isFoucs = guideList.contains('search');
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Search(
                onTapConversation: _handleOnConvItemTapedWithPlace,
                isAutoFocus: isFoucs,
              ),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
              theme.primaryColor ?? CommonColor.primaryColor
            ]),
            boxShadow: [
              BoxShadow(
                color: theme.weakDividerColor ?? hexToColor("E6E9EB"),
                offset: const Offset(0.0, 2.0),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: hexToColor("979797"),
                  size: 18,
                ),
                Text(TIM_t("搜索"),
                    style: TextStyle(
                      color: hexToColor("979797"),
                      fontSize: 14,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}