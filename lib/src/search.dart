import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:timuikit/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:timuikit/src/provider/user_guide_provider.dart';
import 'package:timuikit/utils/user_guide.dart';

class Search extends StatelessWidget {
  const Search(
      {Key? key,
      this.isAutoFocus = true,
      this.conversation,
      required this.onTapConversation,
      this.initKeyword})
      : super(key: key);

  /// if assign a specific conversation, it will only search in it; otherwise search globally
  final V2TimConversation? conversation;

  /// the callback after clicking the conversation item to specific message in it
  final Function(V2TimConversation, V2TimMessage?) onTapConversation;

  /// initial keyword for detail search
  final String? initKeyword;

  final bool? isAutoFocus;

  @override
  Widget build(BuildContext context) {
    final isConversation = (conversation != null);
    judgeGuide('search', context);
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final guideModel = Provider.of<UserGuideProvider>(context);
    return IndexedStack(index: guideModel.guideName != "" ? 0 : 1, children: [
      UserGuide(guideName: guideModel.guideName),
      Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
          backgroundColor: theme.primaryColor,
          title: Text(
            isConversation
                ? (conversation?.showName ??
                    conversation?.conversationID ??
                    TIM_t("相关聊天记录"))
                : TIM_t("全局搜索"),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
        body: isConversation
            ? TIMUIKitSearchMsgDetail(
                isAutoFocus: isAutoFocus,
                currentConversation: conversation!,
                onTapConversation: onTapConversation,
                keyword: initKeyword ?? "",
              )
            : TIMUIKitSearch(
                isAutoFocus: isAutoFocus,
                onEnterSearchInConversation:
                    (V2TimConversation conversation, String keyword) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(
                          onTapConversation: onTapConversation,
                          conversation: conversation,
                          initKeyword: keyword,
                        ),
                      ));
                },
                onTapConversation: onTapConversation,
              ),
      )
    ]);
  }
}
