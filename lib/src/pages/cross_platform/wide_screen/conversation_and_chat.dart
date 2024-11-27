import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/conversation.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/empty_widget.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/search.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/group_profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class ConversationAndChat extends StatefulWidget {
  final V2TimConversation? conversation;

  const ConversationAndChat({Key? key, this.conversation}) : super(key: key);

  @override
  State<ConversationAndChat> createState() => _ConversationAndChatState();
}

class _ConversationAndChatState extends State<ConversationAndChat> {
  final TIMUIKitConversationController _conversationController =
      TIMUIKitConversationController();

  V2TimConversation? currentConversation;
  bool isShowSearch = false;
  bool isShowGroupProfile = false;

  @override
  void initState() {
    super.initState();
    currentConversation = widget.conversation;
  }

  @override
  void didUpdateWidget(ConversationAndChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      isShowGroupProfile = false;
      currentConversation = widget.conversation;
    });
  }

  void onClickUserName(Offset? offset, String user) {
    TUIKitWidePopup.showPopupWindow(
        operationKey: TUIKitWideModalOperationKey.showUserProfileFromChat,
        context: context,
        isDarkBackground: false,
        width: 350,
        offset: offset,
        height: 460,
        child: (closeFunc) => Container(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TIMUIKitProfile(
                smallCardMode: true,
                profileWidgetsOrder: const [
                  ProfileWidgetEnum.userInfoCard,
                  ProfileWidgetEnum.operationDivider,
                  ProfileWidgetEnum.remarkBar,
                  ProfileWidgetEnum.genderBar,
                  ProfileWidgetEnum.birthdayBar,
                  ProfileWidgetEnum.operationDivider,
                  ProfileWidgetEnum.addToBlockListBar,
                  ProfileWidgetEnum.pinConversationBar,
                  ProfileWidgetEnum.messageMute,
                  ProfileWidgetEnum.addAndDeleteArea,
                ],
                userID: user,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: isShowSearch
              ? Search(
                  onTapConversation: (conversation, message) {
                    setState(() {
                      isShowGroupProfile = false;
                      currentConversation = conversation;
                      isShowSearch = false;
                    });
                  },
                  isAutoFocus: true,
                  onBack: () {
                    setState(() {
                      isShowSearch = false;
                    });
                  },
                )
              : Conversation(
                  selectedConversation: currentConversation,
                  onConversationChanged: (conversation) {
                    if (conversation != null) {
                      setState(() {
                        isShowGroupProfile = false;
                        currentConversation = conversation;
                      });
                    }
                  },
                  onClickSearch: () {
                    if (PlatformUtils().isWeb) {
                      TUIKitWidePopup.showPopupWindow(
                          operationKey: TUIKitWideModalOperationKey.contactUs,
                          context: context,
                          theme: theme,
                          title: TIM_t("暂不支持"),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: (closeFunc) => Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(TIM_t(
                                          "Web 端暂不支持本地搜索，请使用 Mobile App 或 Desktop 端体验")),
                                      ElevatedButton(
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                  "https://cloud.tencent.com/document/product/269/36852"),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child: Text(TIM_t("立即下载")))
                                    ],
                                  ),
                                ),
                              ));
                    } else {
                      setState(() {
                        isShowSearch = true;
                      });
                    }
                  },
                  conversationController: _conversationController,
                ),
        ),
        SizedBox(
          width: 1,
          child: Container(
            color: theme.weakDividerColor,
          ),
        ),
        if (currentConversation != null)
          Expanded(
              child: Stack(
            children: [
              Chat(
                directToChat: (conversation) {
                  setState(() {
                    isShowGroupProfile = false;
                    currentConversation = conversation;
                  });
                },
                selectedConversation: currentConversation!,
                showGroupProfile: () {
                  setState(() {
                    isShowGroupProfile = true;
                  });
                },
              ),
              if (TencentUtils.checkString(currentConversation?.groupID) !=
                  null)
                AnimatedPositioned(
                    right: isShowGroupProfile ? 0 : -360,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 350,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: theme.wideBackgroundColor ??
                            const Color(0xFFffffff),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFbebebe),
                            offset: Offset(-2, -2),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: hexToColor("f5f6f7"),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  TIM_t("设置"),
                                  style: TextStyle(
                                      fontSize: 18, color: theme.darkTextColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isShowGroupProfile = false;
                                    });
                                  },
                                  child: const Icon(Icons.close),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1,
                            child: Container(
                              color: theme.weakDividerColor,
                            ),
                          ),
                          Expanded(
                              child: TIMUIKitGroupProfile(
                            onClickUser: (memberInfo, tapDetails) {
                              onClickUserName(
                                  tapDetails != null
                                      ? Offset(
                                          min(
                                              tapDetails.globalPosition.dx,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  350),
                                          min(
                                              tapDetails.globalPosition.dy,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  470))
                                      : null,
                                  memberInfo.userID);
                            },
                            profileWidgetsOrder: const [
                              GroupProfileWidgetEnum.detailCard,
                              GroupProfileWidgetEnum.operationDivider,
                              GroupProfileWidgetEnum.memberListTile,
                              GroupProfileWidgetEnum.operationDivider,
                              GroupProfileWidgetEnum.groupTypeBar,
                              GroupProfileWidgetEnum.groupNotice,
                              GroupProfileWidgetEnum.groupManage,
                              GroupProfileWidgetEnum.groupJoiningModeBar,
                              GroupProfileWidgetEnum.operationDivider,
                              GroupProfileWidgetEnum.pinedConversationBar,
                              GroupProfileWidgetEnum.muteGroupMessageBar,
                              GroupProfileWidgetEnum.nameCardBar,
                              GroupProfileWidgetEnum.buttonArea
                            ],
                            groupID: currentConversation!.groupID!,
                          ))
                        ],
                      ),
                    ))
            ],
          )),
        if (currentConversation == null)
          Expanded(
              child: EmptyWidget(
            title: TIM_t("腾讯云 · IM"),
            description: TIM_t("服务亿级 QQ 用户的即时通讯技术"),
          ))
      ],
    );
  }
}
