// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/utils/constant.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_demo/src/pages/login.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/request.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import '../config.dart';
import 'package:dio/dio.dart';

class CancelAccount extends StatelessWidget {
  final TUISelfInfoViewModel _selfInfoViewModel =
      serviceLocator<TUISelfInfoViewModel>();
  final CoreServicesImpl _coreServices = TIMUIKitCore.getInstance();

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

  CupertinoActionSheet mapAppSheet(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(TIM_t("确认注销账户")),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
            SharedPreferences prefs = await _prefs;
            String token = prefs.getString("smsLoginToken") ?? "";
            String userID = prefs.getString("smsLoginUserID") ?? "";
            String appID = prefs.getString("sdkAppId") ?? "";

            Response<Map<String, dynamic>> data = await appRequest(
                path:
                    "/base/v1/auth_users/user_delete?apaasUserId=$userID&userId=$userID&token=$token&apaasAppId=$appID",
                method: "get",
                data: <String, dynamic>{
                  "apaasUserId": userID,
                  "userId": userID,
                  "token": token,
                  "apaasAppId": appID
                });

            Map<String, dynamic> res = data.data!;
            int errorCode = res['errorCode'];
            String? codeStr = res['codeStr'];

            if (errorCode == 0) {
              ToastUtils.toast((TIM_t("账户注销成功！")));
              _handleLogout(context);
            } else {
              ToastUtils.log(codeStr);
              ToastUtils.toast(codeStr ?? "");
            }
          },
          child: Text(
            TIM_t("注销"),
            style: TextStyle(
              fontSize: 17.0,
              color: hexToColor("FF584C"),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final option1 = _selfInfoViewModel.loginInfo?.userID;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shadowColor: theme.weakDividerColor,
        elevation: 1,
        title: Text(
          TIM_t("注销账户"),
          style: const TextStyle(fontSize: IMDemoConfig.appBarTitleFontSize),
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
        decoration: BoxDecoration(
          color: theme.weakBackgroundColor,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    height: 80,
                    width: 80,
                    child: Avatar(
                        borderRadius: BorderRadius.circular(40),
                        showName: _selfInfoViewModel.loginInfo?.userID ?? "",
                        faceUrl: _selfInfoViewModel.loginInfo?.faceUrl ?? ""),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      Icons.do_not_disturb_on,
                      color: hexToColor('FA5151'),
                      size: 34,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 40, bottom: 80),
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: Text(
                  TIM_t_para("注销后，您将无法使用当前账号，相关数据也将删除且无法找回。当前账号ID: {{option1}}",
                          "注销后，您将无法使用当前账号，相关数据也将删除且无法找回。当前账号ID: $option1")(
                      option1: option1),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: theme.darkTextColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: MaterialButton(
                  elevation: 0,
                  highlightElevation: 0,
                  minWidth: double.infinity,
                  color: Colors.white,
                  textColor: hexToColor("FA5151"),
                  height: 46,
                  child: Text(
                    TIM_t("注销账号"),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) =>
                            mapAppSheet(context)).then((value) => null);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
