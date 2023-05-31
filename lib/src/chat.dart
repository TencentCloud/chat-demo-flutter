// ignore_for_file: unused_field, unused_element, avoid_print, deprecated_member_use

import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/src/group_application_list.dart';
import 'package:tencent_cloud_chat_demo/src/tencent_page.dart';
// import 'package:tencent_cloud_chat_demo/src/vote_example/vote_create_example.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/chat_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
// import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_layout/wide.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
// import 'package:tim_ui_kit_lbs_plugin/pages/location_picker.dart';
// import 'package:tim_ui_kit_lbs_plugin/utils/location_utils.dart';
// import 'package:tim_ui_kit_lbs_plugin/utils/tim_location_model.dart';
// import 'package:tim_ui_kit_lbs_plugin/widget/location_msg_element.dart';
import 'package:tencent_cloud_chat_demo/src/group_profile.dart';
// import 'package:tencent_cloud_chat_demo/utils/baidu_implements/map_service_baidu_implement.dart';
// import 'package:tencent_cloud_chat_demo/utils/baidu_implements/map_widget_baidu_implement.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/custom_message_element.dart';
// import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tencent_cloud_chat_demo/src/provider/custom_sticker_package.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/utils/push/push_constant.dart';

class Chat extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? initFindingMsg;
  final VoidCallback? showGroupProfile;
  final ValueChanged<V2TimConversation>? directToChat;

  const Chat(
      {Key? key,
      required this.selectedConversation,
      this.initFindingMsg,
      this.showGroupProfile,
      this.directToChat})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TIMUIKitChatController _chatController = TIMUIKitChatController();
  String? backRemark;
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  String? conversationName;

  String _getTitle() {
    return backRemark ?? widget.selectedConversation.showName ?? "Chat";
  }

  String? _getConvID() {
    return widget.selectedConversation.type == 1
        ? widget.selectedConversation.userID
        : widget.selectedConversation.groupID;
  }

  ConvType _getConvType() {
    return widget.selectedConversation.type == 1
        ? ConvType.c2c
        : ConvType.group;
  }

  _onTapAvatar(String userID, TapDownDetails tapDetails, TUITheme theme) {
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    if (isWideScreen) {
      onClickUserName(
          Offset(
              min(tapDetails.globalPosition.dx,
                  MediaQuery.of(context).size.width - 350),
              min(tapDetails.globalPosition.dy,
                  MediaQuery.of(context).size.height - 490)),
          theme,
          userID);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(
              userID: userID,
              onRemarkUpdate: (String newRemark) {
                setState(() {
                  conversationName = newRemark;
                });
              },
            ),
          ));
    }
  }

  // _onTapLocation() {
  //   if (!PlatformUtils().isMobile) {
  //     ToastUtils.toast(TIM_t("百度地图插件暂不支持网页版，请使用手机APP DEMO体验位置消息能力。"));
  //     return;
  //   }
  //   _chatController.hideAllBottomPanelOnMobile();
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => LocationPicker(
  //           isUseMapSDKLocation: true,
  //           onChange: (LocationMessage location) async {
  //             final locationMessageInfo = await sdkInstance.v2TIMMessageManager
  //                 .createLocationMessage(
  //                     desc: location.desc,
  //                     longitude: location.longitude,
  //                     latitude: location.latitude);
  //             final messageInfo = locationMessageInfo.data!.messageInfo;
  //             _chatController.sendMessage(messageInfo: messageInfo);
  //           },
  //           mapBuilder: (onMapLoadDone, mapKey, onMapMoveEnd) => BaiduMap(
  //             onMapMoveEnd: onMapMoveEnd,
  //             onMapLoadDone: onMapLoadDone,
  //             key: mapKey,
  //           ),
  //           locationUtils: LocationUtils(BaiduMapService()),
  //         ),
  //       ));
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget renderCustomStickerPanel({
    sendTextMessage,
    sendFaceMessage,
    deleteText,
    addCustomEmojiText,
    addText,
    List<CustomEmojiFaceData> defaultCustomEmojiStickerList = const [],
    double? width,
    double? height,
  }) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final customStickerPackageList =
        Provider.of<CustomStickerPackageData>(context).customStickerPackageList;
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    final defaultEmojiList =
        defaultCustomEmojiStickerList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          isDefaultEmoji: true,
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map((idx) =>
                  CustomSticker(index: idx, name: customEmojiPackage.list[idx]))
              .toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList();

    return StickerPanel(
        isWideScreen: isWideScreen,
        height: height,
        width: width,
        sendTextMsg: isWideScreen ? null : sendTextMessage,
        sendFaceMsg: (index, data) =>
            sendFaceMessage(index + 1, (data.split("/")[3]).split("@")[0]),
        deleteText: deleteText,
        addText: addText,
        addCustomEmojiText: addCustomEmojiText,
        customStickerPackageList: [
          ...defaultEmojiList,
          ...customStickerPackageList
        ],
        bottomColor: isWideScreen ? theme.weakBackgroundColor : null,
        backgroundColor: isWideScreen ? theme.wideBackgroundColor : null,
        lightPrimaryColor: theme.lightPrimaryColor);
  }

  _itemClick(String id, BuildContext context, V2TimConversation conversation,
      VoidCallback closeFunc) async {
    closeFunc();
    switch (id) {
      case "sendMsg":
        if (widget.directToChat != null) {
          widget.directToChat!(conversation);
        }
        break;
    }
  }

  _createVote(String groupID) {
    // final isWideScreen =
    //     TUIKitScreenUtils.getFormFactor(context) == ScreenType.Wide;
    // if (isWideScreen) {
    //   TUIKitWidePopup.showPopupWindow(
    //     context: context,
    //     title: TIM_t("创建投票"),
    //     operationKey: TUIKitWideModalOperationKey.chooseCountry,
    //     width: MediaQuery.of(context).size.width * 0.4,
    //     height: MediaQuery.of(context).size.width * 0.5,
    //     child: (onClose) => VoteCreateExample(
    //       groupID: groupID,
    //       controller: _chatController,
    //       onClosed: onClose,
    //     ),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => VoteCreateExample(
    //         groupID: groupID,
    //         controller: _chatController,
    //         onClosed: () {
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ),
    //   );
    // }
  }

  _buildBottomOperationList(BuildContext context,
      V2TimConversation conversation, VoidCallback closeFunc, TUITheme theme) {
    List operationList = [
      {
        "label": TIM_t("发送消息"),
        "id": "sendMsg",
      }
    ];

    return operationList.map((e) {
      return TIMUIKitProfileWidget.wideButton(
        margin: const EdgeInsets.symmetric(vertical: 0),
        smallCardMode: true,
        onPressed: () =>
            _itemClick(e["id"] ?? "", context, conversation, closeFunc),
        text: e["label"] ?? "",
        color: theme.primaryColor ?? hexToColor("3e4b67"),
      );
    }).toList();
  }

  void onClickUserName(Offset offset, TUITheme theme, [String? user]) {
    final conversationType = widget.selectedConversation.type;
    if (conversationType == 1 || user != null) {
      final userID = user ?? widget.selectedConversation.userID;
      TUIKitWidePopup.showPopupWindow(
          operationKey: TUIKitWideModalOperationKey.showUserProfileFromChat,
          context: context,
          isDarkBackground: false,
          width: 350,
          offset: offset,
          height: (widget.selectedConversation.type == 2) ? 490 : 444,
          child: (closeFunc) => Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TIMUIKitProfile(
                  smallCardMode: true,
                  profileWidgetBuilder: ProfileWidgetBuilder(customBuilderOne:
                      (bool isFriend, V2TimFriendInfo friendInfo,
                          V2TimConversation conversation) {
                    // If you don't allow sending message when friendship not exist,
                    // please not comment the following lines.

                    // if(!isFriend){
                    //   return Container();
                    // }
                    return Column(
                        children: _buildBottomOperationList(
                            context, conversation, closeFunc, theme));
                  }),
                  profileWidgetsOrder: [
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
                    if (widget.selectedConversation.type == 2)
                      ProfileWidgetEnum.customBuilderOne,
                  ],
                  userID: userID ?? "",
                ),
              ));
    } else {
      if (widget.showGroupProfile != null) {
        widget.showGroupProfile!();
      }
    }
  }

  getVotePlugin(bool canvote, String groupID) {
    List<MorePanelItem> wids = [];
    if (canvote) {
      wids.add(MorePanelItem(
        onTap: (c) {
          _createVote(groupID);
        },
        icon: Container(
          height: 64,
          width: 64,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Icon(
            Icons.menu_sharp,
            color: hexToColor("5c6168"),
            size: 32,
          ),
        ),
        id: 'vote',
        title: TIM_t("投票"),
      ));
    }
    return wids;
  }

  @override
  Widget build(BuildContext context) {
    final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final groupID = widget.selectedConversation.groupID;
    final groupType = widget.selectedConversation.groupType;
    List<String> notAllowGroupType = [
      GroupType.Community,
      GroupType.AVChatRoom
    ];
    bool canAddVotePlugin = false;
    if (TencentUtils.checkString(groupID) != null &&
        TencentUtils.checkString(groupType) != null &&
        !notAllowGroupType.contains(groupType)) {
      canAddVotePlugin = true;
    }
    return TencentPage(
      name: 'chat',
      child: TIMUIKitChat(
          // New field, instead of `conversationID` / `conversationType` / `groupAtInfoList` / `conversationShowName` in previous.
          conversation: widget.selectedConversation,
          conversationShowName: conversationName ?? _getTitle(),
          controller: _chatController,
          lifeCycle:
              ChatLifeCycle(newMessageWillMount: (V2TimMessage message) async {
            // ChannelPush.displayDefaultNotificationForMessage(message);
            return message;
          }),
          onDealWithGroupApplication: (String groupId) {
            if (!isWideScreen) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupApplicationList(
                    groupID: groupId,
                  ),
                ),
              );
            } else {
              TUIKitWidePopup.showPopupWindow(
                operationKey: TUIKitWideModalOperationKey.addGroup,
                context: context,
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.width * 0.45,
                title: TIM_t("进群申请列表"),
                child: (closeFuncSendApplication) =>
                    TIMUIKitGroupApplicationList(groupID: groupID ?? ""),
              );
            }
          },
          groupAtInfoList: widget.selectedConversation.groupAtInfoList,
          customStickerPanel: renderCustomStickerPanel,
          showTotalUnReadCount: true,
          // customEmojiStickerList: customEmojiList,
          config: TIMUIKitChatConfig(
              showC2cMessageEditStatus: true,
              isUseDefaultEmoji: true,
              isAllowClickAvatar: true,
              isAllowLongPressMessage: true,
              isShowReadingStatus: localSetting.isShowReadingStatus,
              isShowGroupReadingStatus: localSetting.isShowReadingStatus,
              notificationTitle: "",
              isSupportMarkdownForTextMessage: false,
              urlPreviewType: UrlPreviewType.previewCardAndHyperlink,
              isUseMessageReaction: true,
              notificationOPPOChannelID: PushConfig.OPPOChannelID,
              groupReadReceiptPermissionList: [
                GroupReceiptAllowType.work,
                GroupReceiptAllowType.meeting,
                GroupReceiptAllowType.public
              ],
              faceURIPrefix: (String path) {
                if (path.contains("assets/custom_face_resource/")) {
                  return "";
                }
                int? dirNumber;
                if (path.contains("yz")) {
                  dirNumber = 4350;
                }
                if (path.contains("ys")) {
                  dirNumber = 4351;
                }
                if (path.contains("gcs")) {
                  dirNumber = 4352;
                }
                if (dirNumber != null) {
                  return "assets/custom_face_resource/$dirNumber/";
                } else {
                  return "";
                }
              },
              faceURISuffix: (String path) {
                return "@2x.png";
              },
              additionalDesktopControlBarItems: [
                // if (canAddVotePlugin)
                //   DesktopControlBarItem(
                //       item: "poll",
                //       showName: TIM_t("投票"),
                //       onClick: (offset) {
                //         _createVote(groupID ?? "");
                //       },
                //       svgPath: "assets/send_poll.svg"),
              ]),
          conversationID: _getConvID() ?? '',
          conversationType:
              ConvType.values[widget.selectedConversation.type ?? 1],
          onTapAvatar: (userID, tapDetails) =>
              _onTapAvatar(userID, tapDetails, theme),
          initFindingMsg: widget.initFindingMsg,
          messageItemBuilder: MessageItemBuilder(
            messageRowBuilder: (message, messageWidget, onScrollToIndex,
                isNeedShowJumpStatus, clearJumpStatus, onScrollToIndexBegin) {
              if (MessageUtils.isGroupCallingMessage(message)) {
                // If group call message, not use default layout.
                return messageWidget;
              }
              return null;
            },
            customMessageItemBuilder: (message, isShowJump, clearJump) {
              return CustomMessageElem(
                message: message,
                isShowJump: isShowJump,
                clearJump: clearJump,
              );
            },
            locationMessageItemBuilder: (message, isShowJump, clearJump) {
              // if (!PlatformUtils().isMobile) {
                String dividerForDesc = "/////";
                String address = message.locationElem?.desc ?? "";
                String addressName = address;
                String? addressLocation;
                if (RegExp(dividerForDesc).hasMatch(address)) {
                  addressName = address.split(dividerForDesc)[0];
                  addressLocation = address.split(dividerForDesc)[1] != "null"
                      ? address.split(dividerForDesc)[1]
                      : null;
                }
                final borderRadius = (message.isSelf ?? true)
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(2),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10));
                const backgroundColor = Colors.white;
                return GestureDetector(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "http://api.map.baidu.com/marker?location=${message.locationElem?.latitude},${message.locationElem?.longitude}&title=$addressName&content=$addressLocation&output=html"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: borderRadius,
                        border: Border.all(color: hexToColor("DDDDDD")),
                      ),
                      constraints: const BoxConstraints(maxWidth: 240),
                      padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: hexToColor("5c6168"),
                            size: 32,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (addressName.isNotEmpty)
                                Text(
                                  addressName,
                                  softWrap: true,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              if (addressLocation != null &&
                                  addressLocation.isNotEmpty)
                                Text(
                                  addressLocation,
                                  softWrap: true,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: CommonColor.weakTextColor),
                                ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              // }
              // return LocationMsgElement(
              //   isAllowCurrentLocation: false,
              //   messageID: message.msgID,
              //   locationElem: LocationMessage(
              //     longitude: message.locationElem!.longitude,
              //     latitude: message.locationElem!.latitude,
              //     desc: message.locationElem?.desc ?? "",
              //   ),
              //   isFromSelf: message.isSelf ?? true,
              //   isShowJump: isShowJump,
              //   clearJump: clearJump,
              //   mapBuilder: (onMapLoadDone, mapKey) => BaiduMap(
              //     onMapLoadDone: onMapLoadDone,
              //     key: mapKey,
              //   ),
              //   locationUtils: LocationUtils(BaiduMapService()),
              // );
            },
          ),
          morePanelConfig: MorePanelConfig(
            extraAction: [
              // 隐私协议中没有位置消息，暂时下掉
              // MorePanelItem(
              //     id: "location",
              //     title: TIM_t("位置"),
              //     onTap: (c) {
              //       _onTapLocation();
              //     },
              //     icon: Container(
              //       height: 64,
              //       width: 64,
              //       margin: const EdgeInsets.only(bottom: 4),
              //       decoration: const BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.all(Radius.circular(5))),
              //       child: Icon(
              //         Icons.location_on,
              //         color: hexToColor("5c6168"),
              //         size: 32,
              //       ),
              //     )),
              // ...getVotePlugin(canAddVotePlugin, groupID),
            ],
          ),
          customAppBar: isWideScreen
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 60),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: TIMUIKitAppBar(
                              onClickTitle: (details) {
                                onClickUserName(
                                    Offset(details.globalPosition.dx,
                                        details.globalPosition.dy),
                                    theme);
                              },
                              config: AppBar(
                                backgroundColor: isWideScreen
                                    ? hexToColor("fafafa")
                                    : hexToColor("f2f3f5"),
                                actions: [
                                  IconButton(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 16),
                                      onPressed: () async {
                                        onClickUserName(
                                            Offset(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    380,
                                                30),
                                            theme);
                                      },
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: hexToColor("010000"),
                                        size: 20,
                                      ))
                                ],
                                // textTheme: TextTheme(
                                //     titleMedium: TextStyle(
                                //         color: hexToColor("010000"),
                                //         fontSize: 16)),
                              ),
                              conversationShowName: _getTitle(),
                              conversationID: _getConvID() ?? "",
                              showC2cMessageEditStatus: true,
                            ),
                          ),
                          SizedBox(
                            height: 1,
                            child: Container(
                              color: theme.weakDividerColor,
                            ),
                          ),
                        ],
                      ),
                      if (PlatformUtils().isMacOS)
                        SizedBox(
                          height: 20,
                          child: MoveWindow(),
                        ),
                    ],
                  ))
              : null,
          appBarConfig: AppBar(
            actions: [
              IconButton(
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  onPressed: () async {
                    final conversationType = widget.selectedConversation.type;

                    if (conversationType == 1) {
                      final userID = widget.selectedConversation.userID;
                      // if had remark modified its will back new remark
                      String? newRemark = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              userID: userID!,
                              onRemarkUpdate: (String newRemark) {
                                setState(() {
                                  conversationName = newRemark;
                                });
                              },
                            ),
                          ));
                      setState(() {
                        backRemark = newRemark;
                      });
                    } else {
                      final groupID = widget.selectedConversation.groupID;
                      if (groupID != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupProfilePage(
                                groupID: groupID,
                              ),
                            ));
                      }
                    }
                  },
                  icon: Icon(
                    Icons.more_horiz,
                    color: hexToColor("010000"),
                    size: 20,
                  ))
            ],
          )),
    );
  }
}
