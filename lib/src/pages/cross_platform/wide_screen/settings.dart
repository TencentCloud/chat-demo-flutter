
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/about_us.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/contact_us.dart';
import 'package:tencent_cloud_chat_demo/src/pages/skin/skin_page.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/request.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import '../../../../utils/toast.dart';

class Settings extends StatefulWidget {
  final VoidCallback closeFunc;

  const Settings({Key? key, required this.closeFunc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final loginUserInfoModel = Provider.of<LoginUserInfo>(context);
    final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    final V2TimUserFullInfo loginUserInfo = loginUserInfoModel.loginUserInfo;
    final readStatus = localSetting.isShowReadingStatus;
    final onlineStatus = localSetting.isShowOnlineStatus;
    final language = localSetting.language;
    final CoreServicesImpl _coreServices = TIMUIKitCore.getInstance();
    final option1 = loginUserInfo.userID;

    Widget title(String item, bool isNeedDivider) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNeedDivider)
            const SizedBox(
              height: 30,
            ),
          if (isNeedDivider)
            SizedBox(
              height: 1,
              child: Container(
                color: theme.weakDividerColor,
              ),
            ),
          const SizedBox(
            height: 30,
          ),
          Text(
            item,
            style: TextStyle(fontSize: 18, color: theme.darkTextColor),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      );
    }

    Widget secondTitle(String item, bool isTheFirst) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isTheFirst)
            const SizedBox(
              height: 20,
            ),
          Text(
            item,
            style: TextStyle(fontSize: 16, color: theme.darkTextColor),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    }

    Widget languageRadio(String item) {
      return Radio(
          value: item,
          groupValue: language,
          onChanged: (_) {
            I18nUtils(null, item);
            localSetting.language = item;
          });
    }

    _handleLogout(BuildContext context) async {
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
      }
      widget.closeFunc();
    }

    _handleDeregister() async {
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
    }

    _confirmIfDeregister(){
      widget.closeFunc();
      TUIKitWidePopup.showSecondaryConfirmDialog(
          operationKey: TUIKitWideModalOperationKey.confirmGeneral,
          context: context,
          text: TIM_t("确认注销账户"),
          theme: theme,
          onCancel: () {},
          onConfirm: () {
            _handleDeregister();
          });
    }

    Widget switchCheckBox(bool value, String name, String description,
        ValueChanged<bool> onChange) {
      return Row(
        children: [
          Checkbox(
            fillColor: MaterialStateProperty.all(theme.primaryColor),
              value: value,
              onChanged: (bool? newItem) {
                onChange(newItem ?? false);
              }),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(color: theme.darkTextColor)),
              const SizedBox(height: 4,),
              Text(
                description,
                style: TextStyle(color: theme.weakTextColor, fontSize: 12),
              )
            ],
          ))
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Scrollbar(
        child: ListView(
          children: [
            title(TIM_t("我的账户"), false),
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Avatar(
                      faceUrl: loginUserInfo.faceUrl ?? "", showName: ""),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (loginUserInfo.nickName != null)
                      SelectableText(
                        loginUserInfo.nickName!,
                        style:
                            TextStyle(color: theme.darkTextColor, fontSize: 16),
                      ),
                    const SizedBox(
                      height: 4,
                    ),
                    SelectableText("ID: ${loginUserInfo.userID ?? " "}",
                        style: TextStyle(
                            color: theme.weakTextColor, fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [OutlinedButton(
                  onPressed: () {
                    _handleLogout(context);
                  },
                  child: Text(
                    TIM_t("退出登录"),
                    style: TextStyle(color: theme.cautionColor),
                  )),],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () {
                      _confirmIfDeregister();
                    },
                    child: Text(TIM_t("注销账户"),
                        style: TextStyle(color: theme.darkTextColor))),
              ],
            ),
            Text(TIM_t_para("注销后，您将无法使用当前账号，相关数据也将删除且无法找回。当前账号ID: {{option1}}",
                "注销后，您将无法使用当前账号，相关数据也将删除且无法找回。当前账号ID: $option1")(
                option1: option1), style: TextStyle(
              color: theme.weakTextColor, fontSize: 12
            ),),
            title(TIM_t("界面"), true),
            secondTitle(TIM_t("外观"), true),
            Row(
              children: [
                Radio(value: 1, groupValue: 1, onChanged: (_) {}),
                Text(TIM_t("浅色模式")),
                const SizedBox(
                  width: 30,
                ),
                Radio(value: 2, groupValue: 1, onChanged: (_) {}),
                Text(
                  TIM_t("深色模式 (开发中)"),
                  style: TextStyle(color: theme.weakTextColor),
                )
              ],
            ),
            secondTitle(TIM_t("主题"), false),
            SkinPage(key: widget.key),
            secondTitle(TIM_t("语言"), false),
            Row(
              children: [
                languageRadio("en"),
                Text(TIM_t("英语")),
                const SizedBox(
                  width: 30,
                ),
                languageRadio("zh-Hant"),
                Text(TIM_t("繁体中文")),
                const SizedBox(
                  width: 30,
                ),
                languageRadio("zh-Hans"),
                Text(TIM_t("简体中文")),
                const SizedBox(
                  width: 30,
                ),
                languageRadio("ja"),
                Text(TIM_t("日语")),
                const SizedBox(
                  width: 30,
                ),
                languageRadio("ko"),
                Text(TIM_t("韩语"))
              ],
            ),
            title(TIM_t("通用"), true),
            secondTitle(TIM_t("消息"), true),
            switchCheckBox(
                readStatus,
                TIM_t("消息阅读状态"),
                TIM_t("关闭后，您收发的消息均不带消息阅读状态，您将无法看到对方是否已读，同时对方也无法看到你是否已读。"),
                (value) {
                  localSetting.isShowReadingStatus = value;
                }),
            secondTitle(TIM_t("联系人"), false),
            switchCheckBox(onlineStatus, TIM_t("显示在线状态"),
                TIM_t("关闭后，您将不可以在会话列表和通讯录中看到好友在线或离线的状态提示。"), (value) {
              localSetting.isShowOnlineStatus = value;
                }),
            title(TIM_t("关于"), true),
            secondTitle(TIM_t("关于腾讯云 · IM"), true),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    widget.closeFunc();
                    TUIKitWidePopup.showPopupWindow(
                        operationKey: TUIKitWideModalOperationKey.aboutUs,
                        context: context,
                        theme: theme,
                        title: TIM_t("关于我们"),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: (closeFunc) => AboutUs(closeFunc: closeFunc)
                    );
                  },
                  child: Text(TIM_t("查看详情"),
                      style: TextStyle(color: theme.darkTextColor))),
                const SizedBox(width: 20,),
                OutlinedButton(
                    onPressed: () {
                      widget.closeFunc();
                      TUIKitWidePopup.showPopupWindow(
                          operationKey: TUIKitWideModalOperationKey.contactUs,
                          context: context,
                          theme: theme,
                          title: TIM_t("联系我们"),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: (closeFunc) => ContactUs(closeFunc: closeFunc)
                      );
                    },
                    child: Text(TIM_t("联系我们"),
                        style: TextStyle(color: theme.darkTextColor))),
              ],
            ),
            secondTitle(TIM_t("相关网站"), false),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse("https://www.tencentcloud.com/products/im?from=pub"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(TIM_t("官方网站"),
                      style: TextStyle(color: theme.darkTextColor))),
                const SizedBox(width: 20,),
                OutlinedButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse("https://pub.dev/publishers/comm.qq.com/packages"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(TIM_t("所有 SDK"),
                        style: TextStyle(color: theme.darkTextColor))),
                const SizedBox(width: 20,),
                OutlinedButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse("https://github.com/TencentCloud/chat-demo-flutter"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(TIM_t("源代码"),
                        style: TextStyle(color: theme.darkTextColor))),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
