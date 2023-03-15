import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/profile_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_widget.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:tencent_calls_engine/tuicall_define.dart';

import 'package:timuikit/src/provider/theme.dart';
import 'package:timuikit/src/search.dart';
import 'package:timuikit/utils/platform.dart';
import 'package:timuikit/utils/push/push_constant.dart';
import 'package:timuikit/utils/toast.dart';
import 'package:timuikit/utils/commonUtils.dart';
import 'chat.dart';

class UserProfile extends StatefulWidget {
  final String userID;
  final ValueChanged<String>? onRemarkUpdate;
  const UserProfile({Key? key, required this.userID, this.onRemarkUpdate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final TIMUIKitProfileController _timuiKitProfileController =
      TIMUIKitProfileController();
  TUICallKit? _calling;
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  String? newUserMARK;

  _itemClick(
      String id, BuildContext context, V2TimConversation conversation) async {
    switch (id) {
      case "sendMsg":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                selectedConversation: conversation,
              ),
            ));
        break;
      case "deleteFriend":
        _timuiKitProfileController.deleteFriend(widget.userID).then((res) {
          if (res == null) {
            throw Error();
          }
          if (res.resultCode == 0) {
            Utils.toast(TIM_t("好友删除成功"));
            _timuiKitProfileController.loadData(widget.userID);
          } else {
            throw Error();
          }
        }).catchError((error) {
          Utils.toast(TIM_t("好友添加失败"));
        });
        break;
      case "audioCall":
        OfflinePushInfo offlinePush = OfflinePushInfo(
          title: "",
          desc: TIM_t("邀请你语音通话"),
          ext: "{\"conversationID\": \"\"}",
          disablePush: false,
          androidOPPOChannelID: PushConfig.OPPOChannelID,
          ignoreIOSBadge: false,
        );

        await Permissions.checkPermission(context, Permission.microphone.value);
        TUIOfflinePushInfo tuiOfflinePushInfo = CommonUtils.convertTUIOfflinePushInfo(offlinePush);
        _calling?.call(widget.userID, TUICallMediaType.audio, TUICallParams(offlinePushInfo: tuiOfflinePushInfo));

        break;
      case "videoCall":
        OfflinePushInfo offlinePush = OfflinePushInfo(
          title: "",
          desc: TIM_t("邀请你视频通话"),
          ext: "{\"conversationID\": \"\"}",
          androidOPPOChannelID: PushConfig.OPPOChannelID,
          disablePush: false,
          ignoreIOSBadge: false,
        );

        await Permissions.checkPermission(context, Permission.camera.value);
        await Permissions.checkPermission(context, Permission.microphone.value);
        TUIOfflinePushInfo tuiOfflinePushInfo = CommonUtils.convertTUIOfflinePushInfo(offlinePush);
        _calling?.call(widget.userID, TUICallMediaType.video, TUICallParams(offlinePushInfo: tuiOfflinePushInfo));
        break;
    }
  }

  _buildBottomOperationList(
      BuildContext context, V2TimConversation conversation, theme) {
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

    if (kIsWeb) {
      operationList = [
        {
          "label": TIM_t("发送消息"),
          "id": "sendMsg",
        }
      ];
    }

    return operationList.map((e) {
      return InkWell(
        onTap: () {
          _itemClick(e["id"] ?? "", context, conversation);
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(color: theme.weakDividerColor))),
          child: Text(
            e["label"] ?? "",
            style: TextStyle(
                color: e["id"] != "deleteFriend"
                    ? theme.primaryColor
                    : theme.cautionColor,
                fontSize: 17),
          ),
        ),
      );
    }).toList();
  }

  _initTUICalling() async {
    final isAndroidEmulator = await PlatformUtils.isAndroidEmulator();
    if (!isAndroidEmulator) {
      _calling = TUICallKit();
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _initTUICalling();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        title: Text(
          TIM_t("详细资料"),
          style: TextStyle(color: hexToColor("1f2329"), fontSize: 17),
        ),
        backgroundColor: hexToColor("f2f3f5"),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //       theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
        //       theme.primaryColor ?? CommonColor.primaryColor
        //     ]),
        //   ),
        // ),
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
      body: Container(
        color: theme.weakBackgroundColor,
        child: TIMUIKitProfile(
          lifeCycle:
              ProfileLifeCycle(didRemarkUpdated: (String newRemark) async {
            if (widget.onRemarkUpdate != null) {
              widget.onRemarkUpdate!(newRemark);
            }
            return true;
          }),
          userID: widget.userID,
          profileWidgetBuilder: ProfileWidgetBuilder(
              searchBar: (conversation) => TIMUIKitProfileWidget.searchBar(
                      context, conversation, handleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Search(
                              conversation: conversation,
                              onTapConversation:
                                  (V2TimConversation conversation,
                                      [V2TimMessage? targetMsg]) {
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
              customBuilderOne: (bool isFriend, V2TimFriendInfo friendInfo,
                  V2TimConversation conversation) {
                // If you don't allow sending message when friendship not exist,
                // please not comment the following lines.

                // if(!isFriend){
                //   return Container();
                // }
                return Column(
                    children: _buildBottomOperationList(
                        context, conversation, theme));
              }),
          controller: _timuiKitProfileController,
          profileWidgetsOrder: const [
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
      ),
    );
  }
}
