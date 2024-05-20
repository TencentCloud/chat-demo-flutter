// ignore_for_file: unused_import

import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_demo/src/about.dart';
import 'package:tencent_cloud_chat_demo/src/my_profile_detail.dart';
import 'package:tencent_cloud_chat_demo/src/pages/skin/skin_page.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_demo/src/pages/login.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<MyProfile> {
  final CoreServicesImpl _coreServices = TIMUIKitCore.getInstance();
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  final TIMUIKitProfileController _timuiKitProfileController =
      TIMUIKitProfileController();
  String? userID;

  String _getAllowText(int? allowType) {
    if (allowType == 0) {
      return TIM_t("允许任何人");
    }

    if (allowType == 1) {
      return TIM_t("需要验证信息");
    }

    if (allowType == 2) {
      return TIM_t("禁止加我为好友");
    }

    return TIM_t("未指定");
  }

  _handleLogout() async {
    final res = await _coreServices.logout();

    if (res.code == 0) {
      try {
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        SharedPreferences prefs = await _prefs;
        prefs.remove('smsLoginUserId');
        prefs.remove('smsLoginToken');
        prefs.remove('smsLoginPhone');
        prefs.remove('channelListMain');
        prefs.remove('discussListMain');
      } catch (err) {
        ToastUtils.log("someError");
        ToastUtils.log(err);
      }
      Routes().directToLoginPage();

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
      //   ModalRoute.withName('/'),
      // );
    }
  }

  changeFriendVerificationMethod(int allowType) async {
    _timuiKitProfileController.changeFriendVerificationMethod(allowType);
  }

  showApplicationTypeSheet(theme) async {
    const allowAny = 0;
    const neddConfirm = 1;
    const denyAny = 2;

    showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(
            TIM_t("允许任何人"),
            style: TextStyle(color: theme.primaryColor, fontSize: 18),
          ),
          onPressed: (_) {
            changeFriendVerificationMethod(allowAny);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        BottomSheetAction(
            title: Text(
              TIM_t("需要验证信息"),
              style: TextStyle(color: theme.primaryColor, fontSize: 18),
            ),
            onPressed: (_) {
              changeFriendVerificationMethod(neddConfirm);
              Navigator.of(context, rootNavigator: true).pop();
            }),
        BottomSheetAction(
          title: Text(
            TIM_t("禁止加我为好友"),
            style: TextStyle(color: theme.primaryColor, fontSize: 18),
          ),
          onPressed: (_) {
            changeFriendVerificationMethod(denyAny);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
      cancelAction: CancelAction(
        title: Text(
          TIM_t("取消"),
          style: const TextStyle(fontSize: 18),
        ),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    final themeType = Provider.of<DefaultThemeData>(context).currentThemeType;
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final loginUserInfoModel = Provider.of<LoginUserInfo>(context);
    final bool isWideScreen =
        TUIKitScreenUtils.getFormFactor() == DeviceType.Desktop;
    final V2TimUserFullInfo loginUserInfo = loginUserInfoModel.loginUserInfo;
    return TIMUIKitProfile(
      isSelf: true,
      userID: loginUserInfo.userID ?? "",
      controller: _timuiKitProfileController,
      builder: (BuildContext context, V2TimFriendInfo userInfo,
          V2TimConversation conversation, int friendType, bool isMute) {
        final userProfile = userInfo.userProfile;
        final int? allowType = userProfile?.allowType;
        final allowText = _getAllowText(allowType);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProfileDetail(
                          userProfile: userProfile,
                          controller: _timuiKitProfileController)),
                );
              },
              child: TIMUIKitProfileUserInfoCard(
                userInfo: userProfile,
                showArrowRightIcon: true,
              ),
            ),
            // 好友验证方式选
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  showApplicationTypeSheet(theme);
                },
                child: TIMUIKitOperationItem(
                  isEmpty: false,
                  operationName: TIM_t("加我为好友的方式"),
                  operationRightWidget: Text(
                    allowText,
                    textAlign: isWideScreen ? null : TextAlign.end,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SkinPage(),
                  ),
                );
              },
              child: TIMUIKitOperationItem(
                isEmpty: false,
                operationName: TIM_t("更换皮肤"),
                operationRightWidget: Text(
                    DefTheme.defaultThemeName[themeType]!,
                    textAlign: isWideScreen ? null : TextAlign.end,
                    style: TextStyle(color: theme.primaryColor)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TIMUIKitOperationItem(
              isEmpty: false,
              operationName: TIM_t("消息阅读状态"),
              operationDescription:
                  TIM_t("关闭后，您收发的消息均不带消息阅读状态，您将无法看到对方是否已读，同时对方也无法看到你是否已读。"),
              type: "switch",
              operationValue: localSetting.isShowReadingStatus,
              onSwitchChange: (bool value) {
                localSetting.isShowReadingStatus = value;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TIMUIKitOperationItem(
              isEmpty: false,
              operationName: TIM_t("显示在线状态"),
              operationDescription: TIM_t("关闭后，您将不可以在会话列表和通讯录中看到好友在线或离线的状态提示。"),
              type: "switch",
              operationValue: localSetting.isShowOnlineStatus,
              onSwitchChange: (bool value) {
                localSetting.isShowOnlineStatus = value;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const About(),
                  ),
                );
              },
              child: TIMUIKitOperationItem(
                isEmpty: false,
                operationName: TIM_t("关于腾讯云 · IM"),
                operationRightWidget: const Text(""),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: _handleLogout,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: hexToColor("E5E5E5")))),
                child: Text(
                  TIM_t("退出登录"),
                  style: TextStyle(color: hexToColor("FF584C"), fontSize: 17),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
