// ignore_for_file: unused_field, unused_element, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluwx/fluwx.dart';
import 'package:tim_ui_kit/business_logic/life_cycle/chat_life_cycle.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:tim_ui_kit/ui/utils/permission.dart';
import 'package:tim_ui_kit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_call_invite_list.dart';
import 'package:tim_ui_kit/ui/widgets/toast.dart';
import 'package:tim_ui_kit_calling_plugin/enum/tim_uikit_trtc_calling_scence.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';
import 'package:tim_ui_kit_lbs_plugin/pages/location_picker.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/location_utils.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/tim_location_model.dart';
import 'package:tim_ui_kit_lbs_plugin/widget/location_msg_element.dart';
import 'package:tim_ui_kit_sticker_plugin/tim_ui_kit_sticker_plugin.dart';
import 'package:timuikit/src/config.dart';
import 'package:timuikit/src/discuss/create_topic.dart';
import 'package:timuikit/src/group_profile.dart';
import 'package:timuikit/utils/baidu_implements/map_service_baidu_implement.dart';
import 'package:timuikit/utils/baidu_implements/map_widget_baidu_implement.dart';
import 'package:timuikit/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timuikit/src/provider/custom_sticker_package.dart';
import 'package:timuikit/src/provider/local_setting.dart';
import 'package:timuikit/src/provider/theme.dart';
import 'package:timuikit/src/share.dart';
import 'package:timuikit/src/user_profile.dart';
import 'package:timuikit/utils/discuss.dart';
import 'package:provider/provider.dart';
import 'package:timuikit/utils/platform.dart';
import 'package:timuikit/utils/push/push_constant.dart';
import 'discuss/topic.dart';
import 'package:timuikit/i18n/i18n_utils.dart';

import 'group_application_list.dart';

class Chat extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? initFindingMsg;

  const Chat(
      {Key? key, required this.selectedConversation, this.initFindingMsg})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TIMUIKitChatController _chatController = TIMUIKitChatController();
  TUICalling? _calling;
  bool isDisscuss = false;
  bool isTopic = false;
  bool _installedWechat = false;
  String? backRemark;
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  GlobalKey<dynamic> tuiChatField = GlobalKey();
  String? conversationName;

  String _getTitle() {
    return backRemark ?? widget.selectedConversation.showName ?? "Chat";
  }

  String? _getDraftText() {
    return widget.selectedConversation.draftText;
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

  isValidateDisscuss(String _groupID) async {
    if (!_groupID.contains("im_discuss_")) {
      return;
    }
    Map<String, dynamic> data = await DisscussApi.isValidateDisscuss(
      imGroupId: _groupID,
    );
    setState(() {
      isDisscuss = data['data']['isDisscuss'];
      isTopic = data['data']['isTopic'];
    });
  }

  _initListener() async {
    // 这个注册监听的逻辑，我们在TIMUIKitChat内已处理，您如果没有单独需要，可不手动注册
    // await _chatController.removeMessageListener();
    // await _chatController.setMessageListener();
  }

  _onTapAvatar(String userID) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfile(
              userID: userID,
            onRemarkUpdate: (String newRemark){
              setState(() {
                conversationName = newRemark;
              });
            },
          ),
        ));
  }

  _onTapLocation() {
    if(kIsWeb){
      Utils.toast(imt("百度地图插件暂不支持网页版，请使用手机APP DEMO体验位置消息能力。"));
      return;
    }
    tuiChatField.currentState.textFieldController.hideAllPanel();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPicker(
            isUseMapSDKLocation: true,
            onChange: (LocationMessage location) async {
              final locationMessageInfo = await sdkInstance.v2TIMMessageManager
                  .createLocationMessage(
                      desc: location.desc,
                      longitude: location.longitude,
                      latitude: location.latitude);
              final messageInfo = locationMessageInfo.data!.messageInfo;
              _chatController.sendMessage(
                  messageInfo: messageInfo);
            },
            mapBuilder: (onMapLoadDone, mapKey, onMapMoveEnd) => BaiduMap(
              onMapMoveEnd: onMapMoveEnd,
              onMapLoadDone: onMapLoadDone,
              key: mapKey,
            ),
            locationUtils: LocationUtils(BaiduMapService()),
          ),
        ));
  }

  _openTopicPage(String groupID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Topic(groupID),
      ),
    );
  }

  List<Map<String, dynamic>> handleTopicActionList = [
    {"name": imt("结束话题"), "type": "0"},
    {"name": imt("置顶话题"), "type": "1000"}
  ];

  handleTopic(BuildContext context, String type, String groupID) async {
    Map<String, dynamic> res = await DisscussApi.updateTopicStatus(
      imGroupId: groupID,
      status: type,
    );
    if (res['code'] == 0) {
      Toast.showToast(
          ToastType.success, type == '0' ? imt("结束成功") : imt("置顶成功"), context);
      Navigator.pop(context);
    } else {
      String option1 = res['message'];
      Toast.showToast(
          ToastType.fail,
          imt_para("发生错误 {{option1}}", "发生错误 $option1")(errorMessage: option1),
          context);
    }
  }

  messagePopUpMenu(BuildContext context, String groupID) {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: null,
          actions: handleTopicActionList
              .map(
                (e) => CupertinoActionSheetAction(
                  onPressed: () {
                    handleTopic(context, e['type'], groupID);
                  },
                  child: Text(e['name']),
                  isDefaultAction: false,
                ),
              )
              .toList(),
        );
      },
    );
  }

  _goToVideoUI() async {
    if (!kIsWeb) {
      final hasCameraPermission =
          await Permissions.checkPermission(context, Permission.camera.value);
      final hasMicphonePermission = await Permissions.checkPermission(
          context, Permission.microphone.value);
      if (!hasCameraPermission || !hasMicphonePermission) {
        return;
      }
    }
    final isGroup = widget.selectedConversation.type == 2;
    tuiChatField.currentState.textFieldController.hideAllPanel();
    if (isGroup) {
      List<V2TimGroupMemberFullInfo>? selectedMember = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCallInviter(
            groupID: widget.selectedConversation.groupID,
          ),
        ),
      );
      if (selectedMember != null) {
        final inviteMember = selectedMember.map((e) => e.userID).toList();
        _calling?.groupCall(inviteMember, CallingScenes.Video,
            widget.selectedConversation.groupID);
      }
    } else {
      final user = await sdkInstance.getLoginUser();
      final myId = user.data;
      OfflinePushInfo offlinePush = OfflinePushInfo(
        title: "",
        desc: imt("邀请你视频通话"),
        ext: "{\"conversationID\": \"\"}",
        disablePush: false,
        androidOPPOChannelID: PushConfig.OPPOChannelID,
        ignoreIOSBadge: false,
      );

      _calling?.call(widget.selectedConversation.userID!, CallingScenes.Video,
          offlinePush);
    }
  }

  _goToVoiceUI() async {
    if (!kIsWeb) {
      final hasMicphonePermission = await Permissions.checkPermission(
          context, Permission.microphone.value);
      if (!hasMicphonePermission) {
        return;
      }
    }
    final isGroup = widget.selectedConversation.type == 2;
    tuiChatField.currentState.textFieldController.hideAllPanel();
    if (isGroup) {
      List<V2TimGroupMemberFullInfo>? selectedMember = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCallInviter(
            groupID: widget.selectedConversation.groupID,
          ),
        ),
      );
      if (selectedMember != null) {
        final inviteMember = selectedMember.map((e) => e.userID).toList();
        _calling?.groupCall(inviteMember, CallingScenes.Audio,
            widget.selectedConversation.groupID);
      }
    } else {
      final user = await sdkInstance.getLoginUser();
      final myId = user.data;
      OfflinePushInfo offlinePush = OfflinePushInfo(
        title: "",
        desc: imt("邀请你语音通话"),
        ext: "{\"conversationID\": \"\"}",
        disablePush: false,
        ignoreIOSBadge: false,
        androidOPPOChannelID: PushConfig.OPPOChannelID,
      );

      _calling?.call(widget.selectedConversation.userID!, CallingScenes.Audio,
          offlinePush);
    }
  }

  static WeChatShareWebPageModel _getShareModel(
      ShareType shareType, ShareInfo shareInfo) {
    var scene = WeChatScene.SESSION;
    switch (shareType) {
      case ShareType.SESSION:
        scene = WeChatScene.SESSION;
        break;
      case ShareType.TIMELINE:
        scene = WeChatScene.TIMELINE;
        break;
      case ShareType.COPY_LINK:
        break;
      case ShareType.DOWNLOAD:
        break;
    }

    if (shareInfo.img != null) {
      return WeChatShareWebPageModel(
        shareInfo.url,
        title: shareInfo.title,
        thumbnail: shareInfo.img,
        description: shareInfo.describe,
        scene: scene,
      );
    } else {
      return WeChatShareWebPageModel(
        shareInfo.url,
        title: shareInfo.title,
        description: shareInfo.describe,
        scene: scene,
      );
    }
  }

  _initFluwx() async {
    if (kIsWeb) {
      return;
    }
    final res = await registerWxApi(
        appId: "wxf0f963bc2e99b586",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://comm.qq.com/im_demo_download/");
    print("is sucess $res");
    var result = await isWeChatInstalled;
    _installedWechat = result;
  }

  _initTUICalling() async {
    final isAndroidEmulator = await PlatformUtils.isAndroidEmulator();
    if (!isAndroidEmulator) {
      _calling = TUICalling();
    }
  }

  _openTSWebview() async {
    await launchUrl(
      Uri(
          scheme: "https",
          host: "cloud.tencent.com",
          path: "/apply/p/xc3oaubi98g"),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  void initState() {
    super.initState();
    _initFluwx();
    _initListener();
    _initTUICalling();
    if (widget.selectedConversation.type != ConversationType.V2TIM_C2C) {
      isValidateDisscuss(widget.selectedConversation.groupID!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget renderCustomStickerPanel(
      {sendTextMessage, sendFaceMessage, deleteText, addText}) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final customStickerPackageList =
        Provider.of<CustomStickerPackageData>(context).customStickerPackageList;
    return StickerPanel(
        sendTextMsg: sendTextMessage,
        sendFaceMsg: (index, data) =>
            sendFaceMessage(index + 1, (data.split("/")[3]).split("@")[0]),
        deleteText: deleteText,
        addText: addText,
        customStickerPackageList: customStickerPackageList,
        backgroundColor: theme.weakBackgroundColor,
        lightPrimaryColor: theme.lightPrimaryColor);
  }

  @override
  Widget build(BuildContext context) {
    final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    return TIMUIKitChat(
        conversationShowName: conversationName ?? _getTitle(),
        controller: _chatController,
        topFixWidget: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color.fromRGBO(255, 149, 1, 0.1),
                    child: Text(
                      imt("【安全提示】本 APP 仅用于体验腾讯云即时通信 IM 产品功能，不可用于业务洽谈与拓展。请勿轻信汇款、中奖等涉及钱款的信息，勿轻易拨打陌生电话，谨防上当受骗。"),
                      style: TextStyle(
                        color: hexToColor("FF8C39"),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _openTSWebview,
                      child: Text(
                        imt("点此投诉"),
                        style: TextStyle(
                          color: hexToColor("006EFF"),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        lifeCycle:
            ChatLifeCycle(newMessageWillMount: (V2TimMessage message) async {
          // ChannelPush.displayDefaultNotificationForMessage(message);
          return message;
        }),
        onDealWithGroupApplication: (String groupId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupApplicationList(
                groupID: groupId,
              ),
            ),
          );
        },
        groupAtInfoList: widget.selectedConversation.groupAtInfoList,
        key: tuiChatField,
        customStickerPanel: renderCustomStickerPanel,
        config: TIMUIKitChatConfig(
          // 仅供演示，非全部配置项，实际使用中，可只传和默认项不同的参数，无需传入所有开关
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
        ),
        conversationID: _getConvID() ?? '',
        conversationType:
            ConvType.values[widget.selectedConversation.type ?? 1],
        onTapAvatar: _onTapAvatar,
        initFindingMsg: widget.initFindingMsg,
        draftText: _getDraftText(),
        messageItemBuilder: MessageItemBuilder(
          locationMessageItemBuilder: (message, isShowJump, clearJump) {
            if (kIsWeb) {
              String dividerForDesc = "/////";
              String address = message.locationElem?.desc ?? "";
              String addressName = address;
              String? addressLocation;
              if(RegExp(dividerForDesc).hasMatch(address)){
                addressName = address.split(dividerForDesc)[0];
                addressLocation = address.split(dividerForDesc)[1] != "null" ? address.split(dividerForDesc)[1] : null;
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
                    Uri.parse("http://api.map.baidu.com/marker?location=${message.locationElem?.latitude},${message.locationElem?.longitude}&title=$addressName&content=$addressLocation&output=html"),
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
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(addressName.isNotEmpty)Text(
                              addressName,
                              softWrap: true,
                              style: const TextStyle(fontSize: 16),
                            ),

                            if(addressLocation != null &&
                                addressLocation.isNotEmpty) Text(
                              addressLocation,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: CommonColor.weakTextColor
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              );
            }
            return LocationMsgElement(
              isAllowCurrentLocation: false,
              messageID: message.msgID,
              locationElem: LocationMessage(
                longitude: message.locationElem!.longitude,
                latitude: message.locationElem!.latitude,
                desc: message.locationElem?.desc ?? "",
              ),
              isFromSelf: message.isSelf ?? false,
              isShowJump: isShowJump,
              clearJump: clearJump,
              mapBuilder: (onMapLoadDone, mapKey) => BaiduMap(
                onMapLoadDone: onMapLoadDone,
                key: mapKey,
              ),
              locationUtils: LocationUtils(BaiduMapService()),
            );
          },
          // customMessageItemBuilder: (message, isShowJump, clearJump) {
          //   final CustomMessage customMessage = getCustomMessageData(message.customElem);
          //   if (linkMessage != null) {
          //     final String option1 = linkMessage.link ?? "";
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(linkMessage.text ?? ""),
          //         MarkdownBody(
          //           data: TIM_t_para(
          //               "[查看详情 >>]({{option1}})", "[查看详情 >>]($option1)")(
          //               option1: option1),
          //           styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
          //               textTheme: const TextTheme(
          //                   bodyText2: TextStyle(fontSize: 16.0))))
          //               .copyWith(
          //             a: TextStyle(color: LinkUtils.hexToColor("015fff")),
          //           ),
          //         )
          //       ],
          //     );
          //   }
          // }
          // textMessageItemBuilder: (message, isShowJump, clearJump) {
          //   return TextElemWithLinkPreview(
          //     message: message,
          //     isFromSelf: message.isSelf ?? true,
          //     isShowJump: isShowJump,
          //     clearJump: clearJump,
          //   );
          // }
        ),
        morePanelConfig: MorePanelConfig(
          extraAction: [
            // 隐私协议中没有位置消息，暂时下掉
            MorePanelItem(
                id: "location",
                title: imt("位置"),
                onTap: (c) {
                  _onTapLocation();
                },
                icon: Container(
                  height: 64,
                  width: 64,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Icon(
                    Icons.location_on,
                    color: hexToColor("5c6168"),
                    size: 32,
                  ),
                )),
            if(!kIsWeb) MorePanelItem(
                id: "voiceCall",
                title: imt("语音通话"),
                onTap: (c) {
                  // _onFeatureTap("voiceCall", c);
                  _goToVoiceUI();
                },
                icon: Container(
                  height: 64,
                  width: 64,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: SvgPicture.asset(
                    "images/voice-call.svg",
                    package: 'tim_ui_kit',
                    height: 64,
                    width: 64,
                  ),
                )),
            if(!kIsWeb) MorePanelItem(
                id: "videoCall",
                title: imt("视频通话"),
                onTap: (c) {
                  // _onFeatureTap("videoCall", c);
                  _goToVideoUI();
                },
                icon: Container(
                  height: 64,
                  width: 64,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: SvgPicture.asset(
                    "images/video-call.svg",
                    package: 'tim_ui_kit',
                    height: 64,
                    width: 64,
                  ),
                ))
          ],
        ),
        extraTipsActionItemBuilder: (message, closeTooltip, [Key? key, BuildContext? originalContext]) {
          if (isDisscuss) {
            return Container(
              key: key,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              width: 50,
              child: InkWell(
                onTap: () {
                  closeTooltip();
                  String disscussId;
                  if (message.groupID == null) {
                    disscussId = '';
                  } else {
                    disscussId = message.groupID!;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTopic(
                          disscussId: disscussId,
                          message: message.textElem?.text ?? '',
                          messageIdList: [message.msgID!]),
                    ),
                  );
                },
                child:
                    TipsActionItem(label: imt("话题"), icon: 'assets/topic.png'),
              ),
            );
          } else {
            return null;
          }
        },
        appBarConfig: AppBar(
          backgroundColor: hexToColor("f2f3f5"),
            textTheme: TextTheme(
                titleMedium: TextStyle(
                  color: hexToColor("010000"),
                  fontSize: 16
                )
            ),
          actions: [
            // if (isDisscuss)
            //   SizedBox(
            //     width: 34,
            //     child: TextButton(
            //       onPressed: () {
            //         _openTopicPage(widget.selectedConversation.groupID!);
            //       },
            //       child: const Image(
            //           width: 34,
            //           height: 34,
            //           image: AssetImage('assets/topic.png'),
            //           color: Colors.white),
            //     ),
            //   ),
            // if (isTopic)
            //   IconButton(
            //     onPressed: () {
            //       messagePopUpMenu(
            //           context, widget.selectedConversation.groupID!);
            //     },
            //     icon: const Icon(
            //       Icons.settings,
            //     ),
            //   ),
            if (IMDemoConfig.openShareFeature && isDisscuss)
              IconButton(
                  onPressed: () async {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return ShareWidget(
                            ShareInfo('腾讯云IM',
                                'https://comm.qq.com/im_demo_download/#/discuss-share',
                                img: WeChatImage.network(
                                    "https://imgcache.qq.com/operation/dianshi/other/logo.ac7337705ff26825bf66a8e074460759465c48d7.png"),
                                describe:
                                    "即时通信 IM (Instant Messaging)基于 QQ 底层 IM 能力开发，仅需植入 SDK 即可轻松集成聊天、会话、群组、资料管理和直播弹幕能力，也支持通过信令消息与白板等其他产品打通，全面覆盖您的业务场景，支持各大平台小程序接入使用，全面满足通信需要"),
                            list: [
                              ShareOpt(
                                  title: '微信好友',
                                  img: Image.asset(
                                    'assets/icon_wechat.png',
                                    width: 25.0,
                                    height: 25.0,
                                    fit: BoxFit.fill,
                                  ),
                                  shareType: ShareType.SESSION,
                                  doAction: (shareType, shareInfo) async {
                                    if (!_installedWechat) {
                                      Toast.showToast(
                                          ToastType.fail, "未检测到微信安装", context);
                                      return;
                                    }
                                    var model =
                                        _getShareModel(shareType, shareInfo);
                                    shareToWeChat(model);
                                  }),
                              ShareOpt(
                                  title: '朋友圈',
                                  img: Image.asset(
                                    'assets/icon_wechat_moments.jpg',
                                    width: 25.0,
                                    height: 25.0,
                                    fit: BoxFit.fill,
                                  ),
                                  shareType: ShareType.TIMELINE,
                                  doAction: (shareType, shareInfo) {
                                    if (!_installedWechat) {
                                      Toast.showToast(
                                          ToastType.fail, "未检测到微信安装", context);
                                      return;
                                    }
                                    var model =
                                        _getShareModel(shareType, shareInfo);
                                    shareToWeChat(model);
                                  }),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.share)),
            IconButton(
                padding: const EdgeInsets.only(left: 8, right: 16),
                onPressed: () async {
                  final conversationType = widget.selectedConversation.type;

                  if (conversationType == 1) {
                    final userID = widget.selectedConversation.userID;
                    // if had remark modifed its will back new remark
                    String? newRemark = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                              userID: userID!,
                            onRemarkUpdate: (String newRemark){
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
        ));
  }
}
