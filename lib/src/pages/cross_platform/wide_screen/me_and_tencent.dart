import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_demo/src/my_profile_detail.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class MeAndTencent extends StatefulWidget {
  const MeAndTencent({Key? key}) : super(key: key);

  @override
  State<MeAndTencent> createState() => _MeAndTencentState();
}

class _MeAndTencentState extends State<MeAndTencent> {
  final TIMUIKitProfileController _timuiKitProfileController =
      TIMUIKitProfileController();

  Widget? mainPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginUserInfoModel = Provider.of<LoginUserInfo>(context);
    final V2TimUserFullInfo loginUserInfo = loginUserInfoModel.loginUserInfo;
    final isWideScreen = TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final theme = Provider.of<DefaultThemeData>(context).theme;

    return Column(
      children: [
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
            child: Row(
          children: [
            Expanded(
                child: Container(
              color: isWideScreen ? theme.wideBackgroundColor : null,
              padding: isWideScreen
                  ? const EdgeInsets.symmetric(horizontal: 80)
                  : null,
              child: TIMUIKitProfile(
                userID: loginUserInfo.userID ?? "",
                controller: _timuiKitProfileController,
                builder: (BuildContext context,
                    V2TimFriendInfo userInfo,
                    V2TimConversation conversation,
                    int friendType,
                    bool isMute) {
                  return MyProfileDetail(
                    userProfile: userInfo.userProfile,
                    controller: _timuiKitProfileController,
                  );
                },
              ),
            )),
          ],
        )),
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
      ],
    );
  }
}
