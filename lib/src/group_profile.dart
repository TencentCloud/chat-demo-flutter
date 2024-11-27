import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/src/tencent_page.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/group_profile_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitAddFriend/tim_uikit_send_application.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/group_profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_profile_widget.dart';

import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/search.dart';
import 'package:tencent_cloud_chat_demo/src/user_profile.dart';

class GroupProfilePage extends StatelessWidget {
  final String groupID;
  final sdkInstance = TIMUIKitCore.getSDKInstance();
  final coreInstance = TIMUIKitCore.getInstance();

  GroupProfilePage({Key? key, required this.groupID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TUISelfInfoViewModel _selfInfoViewModel =
        serviceLocator<TUISelfInfoViewModel>();
    final TUIFriendShipViewModel _friendShipViewModel =
        serviceLocator<TUIFriendShipViewModel>();
    return TencentPage(
        child: Scaffold(
            appBar: AppBar(
                title: Text(
                  TIM_t("群聊"),
                  style: TextStyle(color: hexToColor("1f2329"), fontSize: 16),
                ),
                shadowColor: Colors.white,
                backgroundColor: hexToColor("f2f3f5"),
                leading: IconButton(
                  padding: const EdgeInsets.only(left: 16),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: hexToColor("2a2e35"),
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            body: SafeArea(
              child: TIMUIKitGroupProfile(
                lifeCycle: GroupProfileLifeCycle(didLeaveGroup: () async {
                  // Shows navigating back to the home page.
                  // You can customize the reaction here.
                  if (PlatformUtils().isWeb) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName("/homePage"));
                  }
                }),
                groupID: groupID,
                onClickUser: (V2TimGroupMemberFullInfo memberInfo, _) {
                  if (memberInfo.userID !=
                      _selfInfoViewModel.loginInfo?.userID) {
                    _friendShipViewModel
                        .isFriend(memberInfo.userID)
                        .then((isFriend) {
                      if (!isFriend) {
                        V2TimUserFullInfo friendInfo = V2TimUserFullInfo(
                            userID: memberInfo.userID,
                            nickName: memberInfo.nickName,
                            faceUrl: memberInfo.faceUrl);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendApplication(
                                    friendInfo: friendInfo,
                                    model: _selfInfoViewModel)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserProfile(userID: memberInfo.userID),
                            ));
                      }
                    });
                  }
                },
                profileWidgetBuilder:
                    GroupProfileWidgetBuilder(searchMessage: () {
                  return TIMUIKitGroupProfileWidget.searchMessage(
                      (V2TimConversation? conversation) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Search(
                                  onTapConversation:
                                      (V2TimConversation conversation,
                                          V2TimMessage? targetMsg) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Chat(
                                            selectedConversation: conversation,
                                            initFindingMsg: targetMsg,
                                          ),
                                        ));
                                  },
                                  conversation: conversation,
                                )));
                  });
                }),
              ),
            )),
        name: 'groupProfile');
  }
}
