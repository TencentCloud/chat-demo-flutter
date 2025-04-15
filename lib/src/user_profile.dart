import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/search.dart';
import 'package:tencent_cloud_chat_demo/src/tencent_page.dart';
import 'package:tencent_cloud_chat_demo/utils/commonUtils.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:tencent_cloud_chat_sdk/enum/offlinePushInfo.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/profile_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_widget.dart';

class UserProfile extends StatefulWidget {
  final String userID;
  final ValueChanged<V2TimConversation>? onClickSendMessage;
  final ValueChanged<String>? onRemarkUpdate;

  const UserProfile({Key? key, required this.userID, this.onRemarkUpdate, this.onClickSendMessage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final TIMUIKitProfileController _timuiKitProfileController = TIMUIKitProfileController();
  TUICallKit? _calling;
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  String? newUserMARK;

  _itemClick(String id, BuildContext context, V2TimConversation conversation) async {
    switch (id) {
      case "sendMsg":
        if (widget.onClickSendMessage != null) {
          widget.onClickSendMessage!(conversation);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(
                  selectedConversation: conversation,
                ),
              ));
        }
        break;
      case "deleteFriend":
        _timuiKitProfileController.deleteFriend(widget.userID).then((res) {
          if (res == null) {
            throw Error();
          }
          if (res.resultCode == 0) {
            ToastUtils.toast(TIM_t("好友删除成功"));
            _timuiKitProfileController.loadData(widget.userID);
          } else {
            throw Error();
          }
        }).catchError((error) {
          ToastUtils.toast(TIM_t("好友添加失败"));
        });
        break;
      case "audioCall":
        OfflinePushInfo offlinePush = OfflinePushInfo(
          title: "",
          desc: TIM_t("邀请你语音通话"),
          ext: "{\"conversationID\": \"\"}",
          disablePush: false,
          ignoreIOSBadge: false,
        );

        await Permissions.checkPermission(context, Permission.microphone.value);
        TUIOfflinePushInfo tuiOfflinePushInfo = CommonUtils.convertTUIOfflinePushInfo(offlinePush);
        TUICallParams params = TUICallParams();
        params.offlinePushInfo = tuiOfflinePushInfo;
        await _calling?.call(widget.userID, TUICallMediaType.audio, params);
        break;
      case "videoCall":
        OfflinePushInfo offlinePush = OfflinePushInfo(
          title: "",
          desc: TIM_t("邀请你视频通话"),
          ext: "{\"conversationID\": \"\"}",
          disablePush: false,
          ignoreIOSBadge: false,
        );

        await Permissions.checkPermission(context, Permission.camera.value);
        await Permissions.checkPermission(context, Permission.microphone.value);
        TUIOfflinePushInfo tuiOfflinePushInfo = CommonUtils.convertTUIOfflinePushInfo(offlinePush);
        TUICallParams params = TUICallParams();
        params.offlinePushInfo = tuiOfflinePushInfo;
        _calling?.call(widget.userID, TUICallMediaType.video, params);
        break;
    }
  }

  _buildBottomOperationList(BuildContext context, V2TimConversation conversation, theme) {
    final isWideScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    List operationList = [
      {
        "label": TIM_t("发送消息"),
        "id": "sendMsg",
      },
      {
        "label": TIM_t("语音通话"),
        "id": "audioCall",
      },
      {
        "label": TIM_t("视频通话"),
        "id": "videoCall",
      },
    ];

    if (PlatformUtils().isWeb || PlatformUtils().isDesktop) {
      operationList = [
        {
          "label": TIM_t("发送消息"),
          "id": "sendMsg",
        }
      ];
    }

    return operationList.map((e) {
      return isWideScreen
          ? TIMUIKitProfileWidget.wideButton(smallCardMode: false, onPressed: () => _itemClick(e["id"] ?? "", context, conversation), text: e["label"] ?? "", color: e["id"] != "deleteFriend" ? theme.primaryColor : theme.cautionColor)
          : InkWell(
              onTap: () => _itemClick(e["id"] ?? "", context, conversation),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: theme.weakDividerColor))),
                child: Text(
                  e["label"] ?? "",
                  style: TextStyle(color: e["id"] != "deleteFriend" ? theme.primaryColor : theme.cautionColor, fontSize: 17),
                ),
              ),
            );
    }).toList();
  }

  _initTUICalling() async {
    _calling = TUICallKit.instance;
  }

  @override
  void initState() {
    super.initState();
    _initTUICalling();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final isWideScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return TencentPage(
        child: Scaffold(
          appBar: isWideScreen
              ? null
              : AppBar(
                  shadowColor: Colors.white,
                  title: Text(
                    TIM_t("详细资料"),
                    style: TextStyle(color: hexToColor("1f2329"), fontSize: 16),
                  ),
                  backgroundColor: hexToColor("f2f3f5"),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  leading: IconButton(
                    padding: const EdgeInsets.only(left: 16),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: hexToColor("2a2e35"),
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context, newUserMARK);
                    },
                  ),
                ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Make the top of the profile page draggable
              if (isWideScreen)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                  ),
                  child: MoveWindow(
                    child: Container(
                      color: isWideScreen ? theme.wideBackgroundColor : null,
                    ),
                  ),
                ),
              Expanded(
                  child: Container(
                color: isWideScreen ? theme.wideBackgroundColor : null,
                padding: isWideScreen ? const EdgeInsets.symmetric(horizontal: 120) : null,
                child: TIMUIKitProfile(
                  lifeCycle: ProfileLifeCycle(didRemarkUpdated: (String newRemark) async {
                    if (widget.onRemarkUpdate != null) {
                      widget.onRemarkUpdate!(newRemark);
                    }
                    return true;
                  }),
                  userID: widget.userID,
                  profileWidgetBuilder: ProfileWidgetBuilder(
                      searchBar: (conversation) => TIMUIKitProfileWidget.searchBar(context, conversation, false, handleTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Search(
                                      conversation: conversation,
                                      onTapConversation: (V2TimConversation conversation, [V2TimMessage? targetMsg]) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Chat(
                                                selectedConversation: conversation,
                                                initFindingMsg: targetMsg,
                                              ),
                                            ));
                                      }),
                                ));
                          }),
                      customBuilderOne: (bool isFriend, V2TimFriendInfo friendInfo, V2TimConversation conversation) {
                        // If you don't allow sending message when friendship not exist,
                        // please not comment the following lines.

                        // if(!isFriend){
                        //   return Container();
                        // }
                        return Container(
                          margin: isWideScreen ? const EdgeInsets.only(top: 30) : null,
                          child: Column(children: _buildBottomOperationList(context, conversation, theme)),
                        );
                      }),
                  controller: _timuiKitProfileController,
                  profileWidgetsOrder: isWideScreen
                      ? [
                          ProfileWidgetEnum.userInfoCard,
                          ProfileWidgetEnum.operationDivider,
                          ProfileWidgetEnum.remarkBar,
                          ProfileWidgetEnum.genderBar,
                          ProfileWidgetEnum.birthdayBar,
                          ProfileWidgetEnum.operationDivider,
                          ProfileWidgetEnum.addToBlockListBar,
                          ProfileWidgetEnum.pinConversationBar,
                          ProfileWidgetEnum.messageMute,
                          ProfileWidgetEnum.customBuilderOne,
                          ProfileWidgetEnum.addAndDeleteArea
                        ]
                      : [
                          ProfileWidgetEnum.userInfoCard,
                          ProfileWidgetEnum.operationDivider,
                          ProfileWidgetEnum.remarkBar,
                          ProfileWidgetEnum.genderBar,
                          ProfileWidgetEnum.birthdayBar,
                          ProfileWidgetEnum.operationDivider,
                          ProfileWidgetEnum.searchBar,
                          ProfileWidgetEnum.operationDivider,
                          ProfileWidgetEnum.addToBlockListBar,
                          ProfileWidgetEnum.pinConversationBar,
                          ProfileWidgetEnum.messageMute,
                          ProfileWidgetEnum.operationDivider,
                          ProfileWidgetEnum.customBuilderOne,
                          ProfileWidgetEnum.addAndDeleteArea
                        ],
                ),
              ))
            ],
          ),
        ),
        name: "friendProfile");
  }
}
