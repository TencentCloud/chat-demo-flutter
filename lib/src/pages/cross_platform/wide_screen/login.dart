// ignore_for_file: unused_import, avoid_print

import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_webview_window_for_is/desktop_webview_window_for_is.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/login_captcha.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/%20tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_demo/country_list_pick-1.0.1+5/lib/country_list_pick.dart';
import 'package:tencent_cloud_chat_demo/country_list_pick-1.0.1+5/lib/country_selection_theme.dart';
import 'package:tencent_cloud_chat_demo/country_list_pick-1.0.1+5/lib/support/code_country.dart';
import 'package:tencent_cloud_chat_demo/src/config.dart';
import 'package:tencent_cloud_chat_demo/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/privacy/privacy_webview.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/src/widgets/login_captcha.dart';
import 'package:tencent_cloud_chat_demo/utils/GenerateUserSig.dart';
import 'package:tencent_cloud_chat_demo/utils/commonUtils.dart';
import 'package:tencent_cloud_chat_demo/utils/smsLogin.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLoginPage extends StatelessWidget {
  final Function? initIMSDK;

  const WebLoginPage({Key? key, this.initIMSDK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == ScreenType.Wide;
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: !isWideScreen
              ? AppLayout(initIMSDK: initIMSDK)
              : AppLayoutWide(initIMSDK: initIMSDK),
          resizeToAvoidBottomInset: false,
        ));
  }
}

class AppLayout extends StatelessWidget {
  final Function? initIMSDK;

  const AppLayout({Key? key, this.initIMSDK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Stack(
        children: [
          const AppLogo(),
          LoginForm(
            initIMSDK: initIMSDK,
          ),
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                    theme.primaryColor ?? CommonColor.primaryColor
                  ]),
            ),
            child: Image.asset("assets/hero_image.png",
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: 500)),
        Positioned(
          child: Container(
            padding: EdgeInsets.only(top: height / 30, left: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: CommonUtils.adaptWidth(380),
                  width: CommonUtils.adaptWidth(140),
                  child: const Image(
                    image: AssetImage("assets/logo_transparent.png"),
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: CommonUtils.adaptHeight(180),
                  padding: const EdgeInsets.only(top: 10, left: 12, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        TIM_t("腾讯云即时通信IM"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: CommonUtils.adaptFontSize(58),
                        ),
                      ),
                      Text(
                        TIM_t("欢迎使用本 APP 体验腾讯云 IM 产品服务"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: CommonUtils.adaptFontSize(26),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                )),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  final Function? initIMSDK;

  const LoginForm({Key? key, required this.initIMSDK}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();
  final lock = Lock();
  bool isSent = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), checkFirstEnter);
  }

  @override
  void dispose() {
    userSigEtController.dispose();
    telEtController.dispose();
    super.dispose();
  }

  bool isGeted = false;
  String tel = '';
  int timer = 60;
  String sessionId = '';
  String code = '';
  bool isValid = false;
  TextEditingController userSigEtController = TextEditingController();
  TextEditingController telEtController = TextEditingController();
  String dialCode = "+86";
  String countryName = TIM_t("中国大陆");

  initService() {
    if (widget.initIMSDK != null) {
      widget.initIMSDK!();
    }
    userSigEtController.addListener(checkIsValidForm);
    telEtController.addListener(checkIsValidForm);
    SmsLogin.initLoginService();
    setTel();
  }

  checkIsValidForm() {
    if (userSigEtController.text.isNotEmpty &&
        telEtController.text.isNotEmpty) {
      setState(() {
        isValid = true;
      });
    } else if (isValid) {
      setState(() {
        isValid = false;
      });
    }
  }

  setTel() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    String? phone = prefs.getString("smsLoginPhone");
    if (phone != null) {
      telEtController.value = TextEditingValue(
        text: phone,
      );
      setState(() {
        tel = phone;
      });
    }
  }

  timeDown() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (timer == 0) {
          setState(() {
            timer = 60;
            isGeted = false;
          });
          return;
        }
        setState(() {
          timer = timer - 1;
        });
        timeDown();
      }
    });
  }

  TextSpan webViewLink(String title, String url) {
    return TextSpan(
      text: TIM_t(title),
      style: const TextStyle(
        color: Color.fromRGBO(0, 110, 253, 1),
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        },
    );
  }

  void checkFirstEnter() async {
    // 不再检查是否首次登录，每次切换账号均提示
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          content: Text.rich(
            TextSpan(
                style: const TextStyle(
                    fontSize: 14, color: Colors.black, height: 2.0),
                children: [
                  TextSpan(
                    text: TIM_t(
                        "欢迎使用腾讯云即时通信 IM，为保护您的个人信息安全，我们更新了《隐私政策》，主要完善了收集用户信息的具体内容和目的、增加了第三方SDK使用等方面的内容。"),
                  ),
                  const TextSpan(
                    text: "\n",
                  ),
                  TextSpan(
                    text: TIM_t("请您点击"),
                  ),
                  webViewLink("《用户协议》",
                      'https://web.sdk.qcloud.com/document/Tencent-IM-User-Agreement.html'),
                  TextSpan(
                    text: TIM_t(", "),
                  ),
                  webViewLink("《隐私政策摘要》",
                      'https://privacy.qq.com/document/preview/c63a48325d0e4a35b93f675205a65a77'),
                  TextSpan(
                    text: TIM_t(", "),
                  ),
                  webViewLink("《隐私政策》",
                      'https://privacy.qq.com/document/preview/1cfe904fb7004b8ab1193a55857f7272'),
                  TextSpan(
                    text: TIM_t(", "),
                  ),
                  webViewLink("《信息收集清单》",
                      'https://privacy.qq.com/document/preview/45ba982a1ce6493597a00f8c86b52a1e'),
                  TextSpan(
                    text: TIM_t("和"),
                  ),
                  webViewLink("《信息共享清单》",
                      'https://privacy.qq.com/document/preview/dea84ac4bb88454794928b77126e9246'),
                  TextSpan(
                      text: TIM_t("并仔细阅读，如您同意以上内容，请点击“同意并继续”，开始使用我们的产品与服务！")),
                ]),
            overflow: TextOverflow.clip,
          ),
          actions: [
            CupertinoDialogAction(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 110, 253, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  child: Text(TIM_t("同意并继续"),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16))),
              onPressed: () {
                initService();
                Navigator.of(context).pop(true);
              },
            ),
            CupertinoDialogAction(
              child: Text(TIM_t("不同意并退出"),
                  style: const TextStyle(color: Colors.grey, fontSize: 16)),
              isDestructiveAction: true,
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  // 获取验证码
  getLoginCode(context) async {
    if (tel.isEmpty) {
      ToastUtils.toast(TIM_t("请输入手机号"));
      return;
    } else if (!RegExp(r"1[0-9]\d{9}$").hasMatch(tel)) {
      ToastUtils.toast(TIM_t("手机号格式错误"));
      return;
    } else {
      await _showMyDialog();
    }
  }

  // 验证验证码后台下发短信
  verifyPicture(messageObj) async {
    // String captchaWebAppid =
    //     Provider.of<AppConfig>(context, listen: false).appid;
    await lock.synchronized(() async {
      if (isSent) {
        return;
      }
      String phoneNum = "$dialCode$tel";
      final sdkAppid = IMDemoConfig.sdkappid.toString();
      print("sdkAppID$sdkAppid");
      Map<String, dynamic> response = await SmsLogin.vervifyPicture(
        phone: phoneNum,
        ticket: messageObj['ticket'],
        randstr: messageObj['randstr'],
        appId: sdkAppid,
      );
      int errorCode = response['errorCode'];
      if (errorCode == 0) {
        Map<String, dynamic> res = response['data'];
        String sid = res['sessionId'];
        setState(() {
          isGeted = true;
          sessionId = sid;
        });
        timeDown();
        ToastUtils.toast(TIM_t("验证码发送成功"));
        isSent = true;
      } else {
        // Utils.toast(errorMessage);
      }
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          content: SingleChildScrollView(
              child: WebLoginCaptcha(
                  onSuccess: verifyPicture,
                  onClose: () {
                    Navigator.of(dialogContext).pop(1);
                  })),
        );
      },
    );
  }

  directToHomePage() {
    Routes().directToHomePage();
  }

  smsFristLogin() async {
    if (tel == '' && IMDemoConfig.productEnv) {
      ToastUtils.toast(TIM_t("请输入手机号"));
    }
    if (sessionId == '' || code == '') {
      ToastUtils.toast(TIM_t("验证码异常"));
      return;
    }
    String phoneNum = "$dialCode$tel";
    Map<String, dynamic> response = await SmsLogin.smsFirstLogin(
      sessionId: sessionId,
      phone: phoneNum,
      code: code,
    );
    int errorCode = response['errorCode'];
    String errorMessage = response['errorMessage'];

    if (errorCode == 0) {
      Map<String, dynamic> datas = response['data'];
      // userId, sdkAppId, sdkUserSig, token, phone:tel
      String userId = datas['userId'];
      String userSig = datas['sdkUserSig'];
      String token = datas['token'];
      String phone = datas['phone'];
      String avatar = datas['avatar'];
      int sdkAppId = datas['sdkAppId'];

      var data = await coreInstance.login(
        userID: userId,
        userSig: userSig,
      );
      if (data.code != 0) {
        final option1 = data.desc;
        ToastUtils.toast(
            TIM_t_para("登录失败{{option1}}", "登录失败$option1")(option1: option1));
        return;
      }

      final userInfos = coreInstance.loginUserInfo;
      if (userInfos != null) {
        await coreInstance.setSelfInfo(
          userFullInfo: V2TimUserFullInfo.fromJson(
            {
              "nickName": userId,
              "faceUrl": avatar,
            },
          ),
        );
      }

      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      prefs.setString("smsLoginToken", token);
      prefs.setString("smsLoginPhone", phone.replaceFirst(dialCode, ""));
      prefs.setString("smsLoginUserID", userId);
      prefs.setString("sdkAppId", sdkAppId.toString());
      setState(() {
        tel = '';
        code = '';
        timer = 60;
        isGeted = false;
      });
      userSigEtController.clear();
      telEtController.clear();
      // await getIMData();
      // TIMUIKitConversationController().loadData();
      // Navigator.pop(context);
      directToHomePage();
    } else {
      ToastUtils.toast(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(750, 1624),
      minTextAdapt: true,
    );

    final theme = Provider.of<DefaultThemeData>(context).theme;
    return Stack(
      children: [
        Positioned(
            bottom: CommonUtils.adaptHeight(200),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              decoration: const BoxDecoration(
                //背景
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                //设置四周边框
              ),
              // color: Colors.white,
              height: MediaQuery.of(context).size.height -
                  CommonUtils.adaptHeight(600),

              width: MediaQuery.of(context).size.width,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TIM_t("国家/地区"),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: CommonUtils.adaptFontSize(34)),
                    ),
                    CountryListPick(
                      appBar: AppBar(
                        // backgroundColor: Colors.blue,
                        title: Text(TIM_t("选择你的国家区号"),
                            style: const TextStyle(fontSize: 17)),
                        flexibleSpace: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              theme.lightPrimaryColor ??
                                  CommonColor.lightPrimaryColor,
                              theme.primaryColor ?? CommonColor.primaryColor
                            ]),
                          ),
                        ),
                      ),

                      // if you need custome picker use this
                      pickerBuilder: (context, CountryCode? countryCode) {
                        return Row(
                          children: [
                            // 屏蔽伊朗 98
                            // 朝鲜 82 850
                            // 叙利亚 963
                            // 古巴 53
                            Text(
                                "${countryName == "China" ? "中国大陆" : countryName}(${countryCode?.dialCode})",
                                style: TextStyle(
                                    color: const Color.fromRGBO(17, 17, 17, 1),
                                    fontSize: CommonUtils.adaptFontSize(32))),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(17, 17, 17, 0.8),
                            ),
                          ],
                        );
                      },

                      // To disable option set to false
                      theme: CountryTheme(
                          isShowFlag: false,
                          isShowTitle: true,
                          isShowCode: true,
                          isDownIcon: true,
                          showEnglishName: true,
                          searchHintText: TIM_t("请使用英文搜索"),
                          searchText: TIM_t("搜索")),
                      // Set default value
                      initialSelection: '+86',
                      onChanged: (code) {
                        setState(() {
                          dialCode = code?.dialCode ?? "+86";
                          countryName = code?.name ?? TIM_t("中国大陆");
                        });
                      },
                      useUiOverlay: false,
                      // Whether the country list should be wrapped in a SafeArea
                      useSafeArea: false,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: CommonUtils.adaptFontSize(34)),
                      child: Text(
                        TIM_t("手机号"),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: CommonUtils.adaptFontSize(34),
                        ),
                      ),
                    ),
                    TextField(
                      controller: telEtController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: CommonUtils.adaptWidth(14)),
                        hintText: TIM_t("请输入手机号"),
                        hintStyle:
                            TextStyle(fontSize: CommonUtils.adaptFontSize(32)),
                        //
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) {
                        setState(() {
                          tel = v;
                        });
                      },
                    ),
                    Padding(
                        child: Text(
                          TIM_t("验证码"),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: CommonUtils.adaptFontSize(34)),
                        ),
                        padding: EdgeInsets.only(
                          top: CommonUtils.adaptHeight(35),
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: userSigEtController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 5),
                              hintText: TIM_t("请输入验证码"),
                              hintStyle: TextStyle(
                                  fontSize: CommonUtils.adaptFontSize(32)),
                            ),
                            keyboardType: TextInputType.number,
                            //校验密码
                            onChanged: (value) {
                              if ('$code$code' == value && value.length > 5) {
                                //键入重复的情况
                                setState(() {
                                  userSigEtController.value = TextEditingValue(
                                    text: code, //不赋值新的 用旧的;
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: code.length),
                                    ), //  此处是将光标移动到最后,
                                  );
                                });
                              } else {
                                //第一次输入验证码
                                setState(() {
                                  userSigEtController.value = TextEditingValue(
                                    text: value,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: value.length),
                                    ), //  此处是将光标移动到最后,
                                  );
                                  code = value;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: CommonUtils.adaptWidth(200),
                          child: ElevatedButton(
                            child: isGeted
                                ? Text(timer.toString())
                                : Text(
                                    TIM_t("获取验证码"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: CommonUtils.adaptFontSize(24),
                                    ),
                                  ),
                            onPressed: isGeted
                                ? null
                                : () {
                                    //获取验证码
                                    FocusScope.of(context).unfocus();
                                    getLoginCode(context);
                                  },
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: CommonUtils.adaptHeight(46),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text(TIM_t("登录")),
                              onPressed: isValid ? smsFristLogin : null,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }
}

class AppLayoutWide extends StatelessWidget {
  final Function? initIMSDK;

  const AppLayoutWide({Key? key, this.initIMSDK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: <Color>[
              hexToColor("f2f3f6"),
              hexToColor("f6f2f3"),
              hexToColor("f2f3f6")
            ],
          ),
        ),
        child: Stack(
          children: [
            MoveWindow(),
            const Positioned(left: 20, bottom: 20, child: WebsiteWIde()),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogoWide(),
                  const SizedBox(width: 100),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        maxWidth: MediaQuery.of(context).size.width * 0.35),
                    child: LoginFormWide(
                      initIMSDK: initIMSDK,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebsiteWIde extends StatelessWidget {
  const WebsiteWIde({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse("https://www.tencentcloud.com/products/im?from=pub"),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Row(
            children: [
              Image.asset("assets/tcloud.png", height: 12),
              const SizedBox(
                width: 4,
              ),
              Text(
                TIM_t("官方网站"),
                style: TextStyle(fontSize: 14, color: hexToColor("646a73")),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse("https://pub.dev/publishers/comm.qq.com/packages"),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Row(
            children: [
              Image.asset("assets/pub.png", height: 14),
              const SizedBox(
                width: 4,
              ),
              Text(
                TIM_t("所有 SDK"),
                style: TextStyle(fontSize: 14, color: hexToColor("646a73")),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse("https://github.com/TencentCloud/chat-demo-flutter"),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Row(
            children: [
              Image.asset("assets/github.png", height: 14),
              const SizedBox(
                width: 4,
              ),
              Text(
                TIM_t("源代码"),
                style: TextStyle(fontSize: 14, color: hexToColor("646a73")),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppLogoWide extends StatelessWidget {
  const AppLogoWide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () async {
            final webview = await WebviewWindow.create(
              configuration: CreateConfiguration(
                titleBarTopPadding: Platform.isMacOS ? 20 : 0,
              ),
            );
            webview.launch("https://www.qq.com");
          },
          child: Image.asset("assets/logo.png", height: 120),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          TIM_t("腾讯云即时通信IM"),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.darkTextColor,
            fontSize: CommonUtils.adaptFontSize(48),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        Text(
          TIM_t("欢迎使用本 APP 体验腾讯云 IM 产品服务"),
          style: TextStyle(
            color: theme.weakTextColor,
            fontSize: CommonUtils.adaptFontSize(28),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          TIM_t("一次开发，打包部署至所有平台，宽屏窄屏均可自适应"),
          style: TextStyle(
            color: theme.weakTextColor,
            fontSize: CommonUtils.adaptFontSize(28),
          ),
        ),
      ],
    );
  }
}

class LoginFormWide extends StatefulWidget {
  final Function? initIMSDK;

  const LoginFormWide({Key? key, required this.initIMSDK}) : super(key: key);

  @override
  _LoginFormWideState createState() => _LoginFormWideState();
}

class _LoginFormWideState extends State<LoginFormWide> {
  final CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();
  final lock = Lock();
  bool isSent = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userSigEtController.dispose();
    telEtController.dispose();
    super.dispose();
  }

  bool isGeted = false;
  String tel = '';
  int timer = 60;
  String sessionId = '';
  String code = '';
  bool isValid = false;
  TextEditingController userSigEtController = TextEditingController();
  TextEditingController telEtController = TextEditingController();
  String dialCode = "+86";
  String countryName = TIM_t("中国大陆");
  bool isSelectPolicy = false;
  bool isInitService = false;

  initService() {
    if (widget.initIMSDK != null) {
      widget.initIMSDK!();
    }
    userSigEtController.addListener(checkIsValidForm);
    telEtController.addListener(checkIsValidForm);
    SmsLogin.initLoginService();
    setTel();
  }

  checkIsValidForm() {
    if (userSigEtController.text.isNotEmpty &&
        telEtController.text.isNotEmpty) {
      setState(() {
        isValid = true;
      });
    } else if (isValid) {
      setState(() {
        isValid = false;
      });
    }
  }

  setTel() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    String? phone = prefs.getString("smsLoginPhone");
    if (phone != null) {
      telEtController.value = TextEditingValue(
        text: phone,
      );
      setState(() {
        tel = phone;
      });
    }
  }

  timeDown() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (timer == 0) {
          setState(() {
            timer = 60;
            isGeted = false;
          });
          return;
        }
        setState(() {
          timer = timer - 1;
        });
        timeDown();
      }
    });
  }

  TextSpan webViewLink(String title, String url) {
    return TextSpan(
      text: TIM_t(title),
      style: const TextStyle(
        color: Color.fromRGBO(0, 110, 253, 1),
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        },
    );
  }

  void checkFirstEnter() async {
    // 不再检查是否首次登录，每次切换账号均提示
    TUIKitWidePopup.showPopupWindow(
        operationKey: TUIKitWideModalOperationKey.showConditionsAndTerms,
        context: context,
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.4,
        child: (closeFunc) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black, height: 2.0),
                        children: [
                          TextSpan(
                            text: TIM_t(
                                "欢迎使用腾讯云即时通信 IM，为保护您的个人信息安全，我们更新了《隐私政策》，主要完善了收集用户信息的具体内容和目的、增加了第三方SDK使用等方面的内容。"),
                          ),
                          const TextSpan(
                            text: "\n",
                          ),
                          TextSpan(
                            text: TIM_t("请您点击"),
                          ),
                          webViewLink("《用户协议》",
                              'https://web.sdk.qcloud.com/document/Tencent-IM-User-Agreement.html'),
                          TextSpan(
                            text: TIM_t(", "),
                          ),
                          webViewLink("《隐私政策摘要》",
                              'https://privacy.qq.com/document/preview/c63a48325d0e4a35b93f675205a65a77'),
                          TextSpan(
                            text: TIM_t(", "),
                          ),
                          webViewLink("《隐私政策》",
                              'https://privacy.qq.com/document/preview/1cfe904fb7004b8ab1193a55857f7272'),
                          TextSpan(
                            text: TIM_t(", "),
                          ),
                          webViewLink("《信息收集清单》",
                              'https://privacy.qq.com/document/preview/45ba982a1ce6493597a00f8c86b52a1e'),
                          TextSpan(
                            text: TIM_t("和"),
                          ),
                          webViewLink("《信息共享清单》",
                              'https://privacy.qq.com/document/preview/dea84ac4bb88454794928b77126e9246'),
                          TextSpan(
                              text: TIM_t(
                                  "并仔细阅读，如您同意以上内容，请点击“同意并继续”，开始使用我们的产品与服务！")),
                        ]),
                    overflow: TextOverflow.clip,
                  ),
                  Expanded(child: Container()),
                  CupertinoDialogAction(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 110, 253, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: Text(TIM_t("同意并继续"),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16))),
                    onPressed: () {
                      closeFunc();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(TIM_t("不同意并退出"),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16)),
                    isDestructiveAction: true,
                    onPressed: () {
                      exit(0);
                    },
                  ),
                ],
              ),
            ));
  }

  // 获取验证码
  getLoginCode(context) async {
    if (tel.isEmpty) {
      ToastUtils.toast(TIM_t("请输入手机号"));
      return;
    } else if (!RegExp(r"1[0-9]\d{9}$").hasMatch(tel)) {
      ToastUtils.toast(TIM_t("手机号格式错误"));
      return;
    } else {
      await _showMyDialog();
    }
  }

  // 验证验证码后台下发短信
  verifyPicture(messageObj) async {
    // String captchaWebAppid =
    //     Provider.of<AppConfig>(context, listen: false).appid;
    await lock.synchronized(() async {
      if (isSent) {
        return;
      }
      String phoneNum = "$dialCode$tel";
      final sdkAppid = IMDemoConfig.sdkappid.toString();
      print("sdkAppID$sdkAppid");
      Map<String, dynamic> response = await SmsLogin.vervifyPicture(
        phone: phoneNum,
        ticket: messageObj['ticket'],
        randstr: messageObj['randstr'],
        appId: sdkAppid,
      );
      int errorCode = response['errorCode'];
      if (errorCode == 0) {
        Map<String, dynamic> res = response['data'];
        String sid = res['sessionId'];
        setState(() {
          isGeted = true;
          sessionId = sid;
        });
        timeDown();
        ToastUtils.toast(TIM_t("验证码发送成功"));
        isSent = true;
      } else {
        // Utils.toast(errorMessage);
      }
    });
  }

  Future<void> _showMyDialog() async {
    if (PlatformUtils().isWindows &&
        !await WebviewWindow.isWebviewAvailable()) {
      TUIKitWidePopup.showPopupWindow(
          isDarkBackground: false,
          operationKey: TUIKitWideModalOperationKey.custom,
          context: context,
          width: 400,
          height: 220,
          title: TIM_t("运行环境检测"),
          child: (closeFunc) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(TIM_t("请先安装 Microsoft Edge WebView2 运行环境，以使用本程序。")),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          launchUrl(
                            Uri.parse(
                                "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Text(TIM_t("立即下载")))
                  ],
                ),
              ));
      return;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          content: SingleChildScrollView(
              child: WebLoginCaptcha(
                  onSuccess: verifyPicture,
                  onClose: () {
                    Navigator.of(dialogContext).pop(1);
                  })),
        );
      },
    );
  }

  directToHomePage() {
    Routes().directToHomePage();
  }

  smsFristLogin() async {
    if (tel == '' && IMDemoConfig.productEnv) {
      ToastUtils.toast(TIM_t("请输入手机号"));
    }
    if (sessionId == '' || code == '') {
      ToastUtils.toast(TIM_t("验证码异常"));
      return;
    }
    String phoneNum = "$dialCode$tel";
    Map<String, dynamic> response = await SmsLogin.smsFirstLogin(
      sessionId: sessionId,
      phone: phoneNum,
      code: code,
    );
    int errorCode = response['errorCode'];
    String errorMessage = response['errorMessage'];

    if (errorCode == 0) {
      Map<String, dynamic> datas = response['data'];
      // userId, sdkAppId, sdkUserSig, token, phone:tel
      String userId = datas['userId'];
      String userSig = datas['sdkUserSig'];
      String token = datas['token'];
      String phone = datas['phone'];
      String avatar = datas['avatar'];
      int sdkAppId = datas['sdkAppId'];

      var data = await coreInstance.login(
        userID: userId,
        userSig: userSig,
      );
      if (data.code != 0) {
        final option1 = data.desc;
        ToastUtils.toast(
            TIM_t_para("登录失败{{option1}}", "登录失败$option1")(option1: option1));
        return;
      }

      final userInfos = coreInstance.loginUserInfo;
      if (userInfos != null) {
        await coreInstance.setSelfInfo(
          userFullInfo: V2TimUserFullInfo.fromJson(
            {
              "nickName": userId,
              "faceUrl": avatar,
            },
          ),
        );
      }

      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      prefs.setString("smsLoginToken", token);
      prefs.setString("smsLoginPhone", phone.replaceFirst(dialCode, ""));
      prefs.setString("smsLoginUserID", userId);
      prefs.setString("sdkAppId", sdkAppId.toString());
      setState(() {
        tel = '';
        code = '';
        timer = 60;
        isGeted = false;
      });
      userSigEtController.clear();
      telEtController.clear();
      // await getIMData();
      // TIMUIKitConversationController().loadData();
      // Navigator.pop(context);
      directToHomePage();
    } else {
      ToastUtils.toast(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(750, 1624),
      minTextAdapt: true,
    );

    final theme = Provider.of<DefaultThemeData>(context).theme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x4Fbebebe),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TIM_t("欢迎"),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.darkTextColor,
                fontSize: CommonUtils.adaptFontSize(46),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              TIM_t("国家/地区"),
              style: TextStyle(fontSize: CommonUtils.adaptFontSize(28)),
            ),
            CountryListPick(
              pickerBuilder: (context, CountryCode? countryCode) {
                return Row(
                  children: [
                    // 屏蔽伊朗 98
                    // 朝鲜 82 850
                    // 叙利亚 963
                    // 古巴 53
                    Text(
                        "${countryName == "China" ? TIM_t("中国大陆") : countryName}(${countryCode?.dialCode})",
                        style: TextStyle(
                            color: const Color.fromRGBO(17, 17, 17, 1),
                            fontSize: CommonUtils.adaptFontSize(28))),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(17, 17, 17, 0.8),
                    ),
                  ],
                );
              },

              // To disable option set to false
              theme: CountryTheme(
                  isShowFlag: false,
                  isShowTitle: true,
                  isShowCode: true,
                  isDownIcon: true,
                  showEnglishName: true,
                  searchHintText: TIM_t("请使用英文搜索"),
                  searchText: TIM_t("搜索")),
              // Set default value
              initialSelection: '+86',
              onChanged: (code) {
                setState(() {
                  dialCode = code?.dialCode ?? "+86";
                  countryName = code?.name ?? TIM_t("中国大陆");
                });
              },
              useUiOverlay: false,
              // Whether the country list should be wrapped in a SafeArea
              useSafeArea: false,
            ),
            Container(
              decoration: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: Colors.grey))),
            ),
            Padding(
              padding: EdgeInsets.only(top: CommonUtils.adaptFontSize(34)),
              child: Text(
                TIM_t("手机号"),
                style: TextStyle(
                  fontSize: CommonUtils.adaptFontSize(28),
                ),
              ),
            ),
            TextField(
              controller: telEtController,
              decoration: InputDecoration(
                hintText: TIM_t("请输入手机号"),
                hintStyle: TextStyle(fontSize: CommonUtils.adaptFontSize(28)),
                //
              ),
              keyboardType: TextInputType.phone,
              onChanged: (v) {
                setState(() {
                  tel = v;
                });
              },
            ),
            Padding(
                child: Text(
                  TIM_t("验证码"),
                  style: TextStyle(fontSize: CommonUtils.adaptFontSize(28)),
                ),
                padding: EdgeInsets.only(
                  top: CommonUtils.adaptHeight(35),
                )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: userSigEtController,
                    decoration: InputDecoration(
                      hintText: TIM_t("请输入验证码"),
                      hintStyle:
                          TextStyle(fontSize: CommonUtils.adaptFontSize(28)),
                    ),
                    keyboardType: TextInputType.number,
                    //校验密码
                    onChanged: (value) {
                      if ('$code$code' == value && value.length > 5) {
                        //键入重复的情况
                        setState(() {
                          userSigEtController.value = TextEditingValue(
                            text: code, //不赋值新的 用旧的;
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: code.length),
                            ), //  此处是将光标移动到最后,
                          );
                        });
                      } else {
                        //第一次输入验证码
                        setState(() {
                          userSigEtController.value = TextEditingValue(
                            text: value,
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: value.length),
                            ), //  此处是将光标移动到最后,
                          );
                          code = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: CommonUtils.adaptWidth(200),
                  child: ElevatedButton(
                    child: isGeted
                        ? Text(timer.toString())
                        : Text(
                            TIM_t("获取验证码"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: CommonUtils.adaptFontSize(24),
                            ),
                          ),
                    onPressed: isGeted
                        ? null
                        : () {
                            //获取验证码
                            FocusScope.of(context).unfocus();
                            getLoginCode(context);
                          },
                  ),
                )
              ],
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    fillColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(0, 110, 253, 1),
                    ),
                    value: isSelectPolicy,
                    onChanged: (val) {
                      if (val == true && !isInitService) {
                        isInitService = true;
                        initService();
                      }
                      setState(() {
                        isSelectPolicy = val ?? false;
                        checkIsValidForm();
                      });
                    }),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: TIM_t(
                      "我已阅读并同意 ",
                    ),
                    style: TextStyle(
                      fontSize: CommonUtils.adaptFontSize(24),
                    ),
                  ),
                  TextSpan(
                    text: TIM_t(
                      "腾讯云IM各项协议及规定",
                    ),
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 110, 253, 1),
                      fontSize: CommonUtils.adaptFontSize(24),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        checkFirstEnter();
                      },
                  ),
                ])),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      child: Text(TIM_t("登录")),
                      onPressed:
                          (isValid && isSelectPolicy) ? smsFristLogin : null,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
