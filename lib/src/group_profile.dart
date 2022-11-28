import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/group_profile_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/group_profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_profile_widget.dart';
import 'package:timuikit/i18n/i18n_utils.dart';
import 'package:timuikit/src/chat.dart';
import 'package:timuikit/src/provider/user_guide_provider.dart';
import 'package:timuikit/src/search.dart';
import 'package:timuikit/src/user_profile.dart';
import 'package:timuikit/utils/user_guide.dart';

class GroupProfilePage extends StatelessWidget {
  final String groupID;
  final sdkInstance = TIMUIKitCore.getSDKInstance();
  final coreInstance = TIMUIKitCore.getInstance();

  GroupProfilePage({Key? key, required this.groupID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TUISelfInfoViewModel _selfInfoViewModel =
        serviceLocator<TUISelfInfoViewModel>();
    judgeGuide('groupProfile', context);
    final guideModel = Provider.of<UserGuideProvider>(context);
    return IndexedStack(index: guideModel.guideName != "" ? 0 : 1, children: [
      UserGuide(guideName: guideModel.guideName),
      Scaffold(
          appBar: AppBar(
              title: Text(
                imt("群聊"),
                style: TextStyle(color: hexToColor("1f2329"), fontSize: 17),
              ),
              shadowColor: Colors.white,
              // flexibleSpace: Container(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(colors: [
              //       theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
              //       theme.primaryColor ?? CommonColor.primaryColor
              //     ]),
              //   ),
              // ),
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
              onClickUser: (String userID) {
                if (userID != _selfInfoViewModel.loginInfo?.userID) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile(userID: userID),
                      ));
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
          ))
    ]);
  }
}
