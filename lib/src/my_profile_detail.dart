import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/about_us.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/contact_us.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/settings.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/constant.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/time_ago.dart';

import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitProfile/widget/tim_uikit_profile_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';

import 'avatar_select_page.dart';

class MyProfileDetail extends StatefulWidget {
  final V2TimUserFullInfo? userProfile;
  final TIMUIKitProfileController? controller;

  const MyProfileDetail({Key? key, this.userProfile, this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MyProfileDetailState();
}

class MyProfileDetailState extends State<MyProfileDetail> {
  final CoreServicesImpl _coreServices = TIMUIKitCore.getInstance();
  late V2TimUserFullInfo? userProfile;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    userProfile = widget.userProfile;
    if (userProfile?.birthday != null && userProfile?.birthday != 0) {
      final date = DateTime.parse(userProfile!.birthday.toString());
      selectedDate = date;
    } else {
      selectedDate = DateTime.now();
    }
  }

  _handleLogout(BuildContext context) async {
    final res = await _coreServices.logout();
    if (res.code == 0) {
      try {
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        SharedPreferences prefs = await _prefs;
        prefs.remove(Const.DEV_LOGIN_USER_ID);
        prefs.remove(Const.DEV_LOGIN_USER_SIG);
        prefs.remove(Const.SMS_LOGIN_TOKEN);
        prefs.remove(Const.SMS_LOGIN_PHONE);
      } catch (err) {
        ToastUtils.log("someError");
        ToastUtils.log(err);
      }
      Routes().directToLoginPage();
    }
  }

  showGenderChoseSheet(BuildContext context, TUITheme? theme) {
    showAdaptiveActionSheet(
      context: context,
      title: Text(TIM_t("性别")),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(TIM_t("男"), style: TextStyle(color: theme?.primaryColor)),
          onPressed: (_) async {
            final res = await widget.controller?.updateGender(1);
            if (res?.code == 0) {
              setState(() {
                userProfile?.gender = 1;
              });
            }
            Navigator.pop(context);
          },
        ),
        BottomSheetAction(
          title: Text(TIM_t("女"), style: TextStyle(color: theme?.primaryColor)),
          onPressed: (_) async {
            final res = await widget.controller?.updateGender(2);
            if (res?.code == 0) {
              setState(() {
                userProfile?.gender = 2;
              });
            }
            Navigator.pop(context);
          },
        ),
      ],
      cancelAction: CancelAction(
        title: Text(TIM_t("取消")),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  String handleGender(int gender) {
    switch (gender) {
      case 0:
        return TIM_t("未设置");
      case 1:
        return TIM_t("男");
      case 2:
        return TIM_t("女");
      default:
        return "";
    }
  }

  Future<void> showSelectAvatarPage(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarSelectPage(
          controller: widget.controller,
          selectedAvatarUrl: userProfile!.faceUrl ?? "",
        ),
      ),
    );

    if (result != null) {
      setState(() {
        userProfile?.faceUrl = result as String;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      String birthdayString = pickedDate.year.toString() +
          TimeAgo.getMonth(pickedDate) +
          TimeAgo.getDay(pickedDate);
      final result =
          await widget.controller?.updateBirthday(int.parse(birthdayString));
      if (result?.code == 0) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return Scaffold(
      appBar: isWideScreen
          ? null
          : AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              shadowColor: theme.weakDividerColor,
              elevation: 1,
              title: Text(
                TIM_t("个人资料"),
                style:
                    const TextStyle(fontSize: IMDemoConfig.appBarTitleFontSize),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                    theme.primaryColor ?? CommonColor.primaryColor
                  ]),
                ),
              ),
            ),
      body: Container(
        color: isWideScreen ? theme.wideBackgroundColor : null,
        child: Column(
          children: [
            if (isWideScreen)
              TIMUIKitProfileUserInfoCard(
                  onClickAvatar: () => showSelectAvatarPage(context),
                  userInfo: userProfile),
            if (!isWideScreen)
              GestureDetector(
                child: TIMUIKitOperationItem(
                  isEmpty: false,
                  operationName: TIM_t("头像"),
                  operationRightWidget: SizedBox(
                    width: 48,
                    height: 48,
                    child: Avatar(
                        faceUrl: userProfile?.faceUrl ?? "",
                        showName: userProfile?.nickName ?? ""),
                  ),
                ),
                onTap: () => showSelectAvatarPage(context),
              ),
            TIMUIKitProfileWidget.operationDivider(
                color: theme.weakDividerColor,
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 20)),
            InkWell(
              onTapDown: (details) async {
                widget.controller?.showTextInputBottomSheet(
                    context: context,
                    title: TIM_t("修改昵称"),
                    tips: TIM_t("仅限汉字、英文、数字和下划线"),
                    initOffset: Offset(
                        min(details.globalPosition.dx,
                            MediaQuery.of(context).size.width - 400),
                        min(details.globalPosition.dy,
                            MediaQuery.of(context).size.height - 100)),
                    onSubmitted: (String nickName) async {
                      final res =
                          await widget.controller?.updateNickName(nickName);
                      if (res?.code == 0) {
                        setState(() {
                          userProfile?.nickName = nickName;
                        });
                      }
                    },
                    theme: theme);
              },
              child: TIMUIKitOperationItem(
                isEmpty: !TencentUtils.isTextNotEmpty(userProfile?.nickName),
                operationName: TIM_t("昵称"),
                operationRightWidget: Text(
                    TencentUtils.isTextNotEmpty(userProfile?.nickName)
                        ? userProfile!.nickName!
                        : isWideScreen
                            ? ""
                            : TIM_t("未填写"),
                    textAlign: isWideScreen ? null : TextAlign.end),
              ),
            ),
            TIMUIKitProfileWidget.userAccountBar(
              userProfile?.userID ?? "",
              false,
            ),
            TIMUIKitProfileWidget.operationDivider(
                color: theme.weakDividerColor,
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 20)),
            InkWell(
                onTapDown: (details) async {
                  widget.controller?.showTextInputBottomSheet(
                      context: context,
                      title: TIM_t("修改签名"),
                      tips: TIM_t("仅限汉字、英文、数字和下划线"),
                      initOffset: Offset(
                          min(details.globalPosition.dx,
                              MediaQuery.of(context).size.width - 400),
                          min(details.globalPosition.dy,
                              MediaQuery.of(context).size.height - 100)),
                      onSubmitted: (String selfSignature) async {
                        final res = await widget.controller
                            ?.updateSelfSignature(selfSignature);
                        if (res?.code == 0) {
                          setState(() {
                            userProfile?.selfSignature = selfSignature;
                          });
                        }
                      },
                      theme: theme);
                },
                child: TIMUIKitOperationItem(
                    isEmpty: !TencentUtils.isTextNotEmpty(
                        userProfile?.selfSignature),
                    operationName: TIM_t("个性签名"),
                    operationRightWidget: Text(
                        TencentUtils.isTextNotEmpty(userProfile?.selfSignature)
                            ? userProfile!.selfSignature!
                            : isWideScreen
                                ? ""
                                : TIM_t("未填写"),
                        textAlign: isWideScreen ? null : TextAlign.end))),
            InkWell(
                onTapDown: (details) {
                  if (isWideScreen) {
                    TUIKitWidePopup.showPopupWindow(
                        isDarkBackground: false,
                        operationKey: TUIKitWideModalOperationKey
                            .secondaryClickUserAvatar,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        context: context,
                        offset: Offset(details.globalPosition.dx,
                            details.globalPosition.dy),
                        child: (closeFunc) => TUIKitColumnMenu(
                              data: [
                                ColumnMenuItem(
                                    label: TIM_t("男"),
                                    onClick: () async {
                                      final res = await widget.controller
                                          ?.updateGender(1);
                                      if (res?.code == 0) {
                                        setState(() {
                                          userProfile?.gender = 1;
                                        });
                                      }
                                      closeFunc();
                                    }),
                                ColumnMenuItem(
                                    label: TIM_t("女"),
                                    onClick: () async {
                                      final res = await widget.controller
                                          ?.updateGender(2);
                                      if (res?.code == 0) {
                                        setState(() {
                                          userProfile?.gender = 2;
                                        });
                                      }
                                      closeFunc();
                                    }),
                              ],
                            ));
                  } else {
                    showGenderChoseSheet(context, theme);
                  }
                },
                child: TIMUIKitProfileWidget.genderBarWithArrow(
                    userProfile?.gender ?? 0, false)),
            InkWell(
                onTapDown: (details) {
                  _selectDate(context);
                },
                child: TIMUIKitProfileWidget.birthdayBar(
                    userProfile?.birthday ?? 0, false)),
            if (isWideScreen) Expanded(child: Container()),
            if (isWideScreen)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        _handleLogout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: theme.cautionColor,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              TIM_t("退出登录"),
                              style: TextStyle(
                                  color: theme.cautionColor, fontSize: 16),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            if (isWideScreen)
              const SizedBox(
                height: 40,
              ),
            if (isWideScreen)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        TUIKitWidePopup.showPopupWindow(
                            operationKey: TUIKitWideModalOperationKey.settings,
                            context: context,
                            theme: theme,
                            title: TIM_t("设置"),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: (closeFunc) =>
                                Settings(closeFunc: closeFunc));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: theme.darkTextColor,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              TIM_t("设置"),
                              style: TextStyle(color: theme.darkTextColor),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    width: 40,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        TUIKitWidePopup.showPopupWindow(
                            operationKey: TUIKitWideModalOperationKey.contactUs,
                            context: context,
                            theme: theme,
                            title: TIM_t("联系我们"),
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: (closeFunc) =>
                                ContactUs(closeFunc: closeFunc));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              color: theme.darkTextColor,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              TIM_t("联系我们"),
                              style: TextStyle(color: theme.darkTextColor),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    width: 40,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        TUIKitWidePopup.showPopupWindow(
                            operationKey: TUIKitWideModalOperationKey.aboutUs,
                            context: context,
                            theme: theme,
                            title: TIM_t("关于我们"),
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: (closeFunc) =>
                                AboutUs(closeFunc: closeFunc));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.darkTextColor,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              TIM_t("关于"),
                              style: TextStyle(color: theme.darkTextColor),
                            )
                          ],
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
