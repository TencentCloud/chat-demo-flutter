import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/contact_and_profile.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/me_and_tencent.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/left_bar.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'conversation_and_chat.dart';
import 'package:provider/provider.dart';

class HomePageWideScreen extends StatefulWidget {
  const HomePageWideScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageWideScreenState();
}

class HomePageWideScreenState extends State<HomePageWideScreen> {
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();

  int homePageIndex = 0;
  V2TimConversation? currentConversation;

  @override
  initState() {
    super.initState();
    getLoginUserInfo();
  }

  _navigateToChat(V2TimConversation conversation) {
    setState(() {
      homePageIndex = 0;
      currentConversation = conversation;
    });
  }

  getLoginUserInfo() async {
    if (PlatformUtils().isWeb) {
      return;
    }
    final res = await _sdkInstance.getLoginUser();
    if (res.code == 0) {
      final result = await _sdkInstance.getUsersInfo(userIDList: [res.data!]);

      if (result.code == 0) {
        Provider.of<LoginUserInfo>(context, listen: false)
            .setLoginUserInfo(result.data![0]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [hexToColor("3f4c68"), hexToColor("3e4b67")])),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: LeftBar(
                  index: homePageIndex,
                  onChange: (index) {
                    setState(() {
                      homePageIndex = index;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Column(
              children: [
                if(PlatformUtils().isWindows) Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: hexToColor("3f4c68")),
                child: Row(
                  children: [
                    Expanded(child: MoveWindow()),
                    MinimizeWindowButton(colors: WindowButtonColors(
                      iconNormal: Colors.white
                    ),),
                    MaximizeWindowButton(colors: WindowButtonColors(
                        iconNormal: Colors.white
                    ),),
                    CloseWindowButton(colors: WindowButtonColors(
                        iconNormal: Colors.white
                    ),)
                  ],
                ),),
                Expanded(child: IndexedStack(
                  index: homePageIndex,
                  children: [
                    ConversationAndChat(conversation: currentConversation,),
                    ContactsAndProfile(onNavigateToChat: _navigateToChat),
                    const MeAndTencent(),
                  ],
                ))
              ],
            )
        )
      ],
    );
  }
}
