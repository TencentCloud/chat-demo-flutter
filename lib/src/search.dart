import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/src/tencent_page.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';

class Search extends StatelessWidget {
  const Search(
      {Key? key,
      this.isAutoFocus = true,
      this.conversation,
      required this.onTapConversation,
      this.initKeyword,
      this.onBack})
      : super(key: key);

  /// if assign a specific conversation, it will only search in it; otherwise search globally
  final V2TimConversation? conversation;

  final VoidCallback? onBack;

  /// the callback after clicking the conversation item to specific message in it
  final Function(V2TimConversation, V2TimMessage?) onTapConversation;

  /// initial keyword for detail search
  final String? initKeyword;

  final bool? isAutoFocus;

  @override
  Widget build(BuildContext context) {
    final isConversation = (conversation != null);
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final isWideScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return TencentPage(
        child: Scaffold(
          appBar: isWideScreen
              ? null
              : AppBar(
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
                  onBack: onBack,
                  isAutoFocus: isAutoFocus,
                  onEnterSearchInConversation:
                      (V2TimConversation conversation, String keyword) {
                    if(isWideScreen){
                      TUIKitWidePopup.showPopupWindow(
                          operationKey: TUIKitWideModalOperationKey.chatHistory,
                          context: context,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: (onClose) => TIMUIKitSearchMsgDetail(
                            currentConversation: conversation,
                            keyword: keyword,
                            onTapConversation: (V2TimConversation conversation,
                                V2TimMessage? message) {},
                          ),
                          theme: theme);
                    }else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(
                              onTapConversation: onTapConversation,
                              conversation: conversation,
                              initKeyword: keyword,
                            ),
                          ));
                    }
                  },
                  onTapConversation: onTapConversation,
                ),
        ),
        name: 'search');
  }
}
