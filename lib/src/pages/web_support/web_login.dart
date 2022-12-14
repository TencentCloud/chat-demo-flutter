// ignore_for_file: unused_import, avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:timuikit/country_list_pick-1.0.1+5/lib/country_list_pick.dart';
import 'package:timuikit/country_list_pick-1.0.1+5/lib/country_selection_theme.dart';
import 'package:timuikit/country_list_pick-1.0.1+5/lib/support/code_country.dart';
import 'package:timuikit/src/config.dart';
import 'package:timuikit/src/pages/home_page.dart';
import 'package:timuikit/src/pages/privacy/privacy_webview.dart';
import 'package:timuikit/src/pages/web_support/web_login_captcha.dart';
import 'package:timuikit/src/provider/theme.dart';
import 'package:timuikit/src/routes.dart';
import 'package:timuikit/src/widgets/login_captcha.dart';
import 'package:timuikit/utils/GenerateUserSig.dart';
import 'package:timuikit/utils/commonUtils.dart';
import 'package:timuikit/utils/smsLogin.dart';
import 'package:timuikit/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:url_launcher/url_launcher.dart';

class WebLoginPage extends StatelessWidget {
  final Function? initIMSDK;
  const WebLoginPage({Key? key, this.initIMSDK}) : super(key: key);

  removeLocalSetting() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.remove("smsLoginToken");
    prefs.remove("smsLoginPhone");
    prefs.remove("smsLoginUserID");
    prefs.remove("channelListMain");
    prefs.remove("discussListMain");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: AppLayout(initIMSDK: initIMSDK),
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
                            TIM_t("?????????????????????IM"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: CommonUtils.adaptFontSize(58),
                            ),
                          ),
                          Text(
                            TIM_t("??????????????? APP ??????????????? IM ????????????"),
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
  String countryName = TIM_t("????????????");

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
    // ????????????????????????????????????????????????????????????
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
                        "????????????????????????????????? IM?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????SDK???????????????????????????"),
                  ),
                  const TextSpan(
                    text: "\n",
                  ),
                  TextSpan(
                    text: TIM_t("????????????"),
                  ),
                  webViewLink("??????????????????",
                      'https://web.sdk.qcloud.com/document/Tencent-IM-User-Agreement.html'),
                  TextSpan(
                    text: TIM_t(", "),
                  ),
                  webViewLink("????????????????????????",
                      'https://privacy.qq.com/document/preview/c63a48325d0e4a35b93f675205a65a77'),
                  TextSpan(
                    text: TIM_t(", "),
                  ),
                  webViewLink("??????????????????",
                      'https://privacy.qq.com/document/preview/1cfe904fb7004b8ab1193a55857f7272'),
                  TextSpan(
                    text: TIM_t(", "),
                  ),
                  webViewLink("????????????????????????",
                      'https://privacy.qq.com/document/preview/45ba982a1ce6493597a00f8c86b52a1e'),
                  TextSpan(
                    text: TIM_t("???"),
                  ),
                  webViewLink("????????????????????????",
                      'https://privacy.qq.com/document/preview/dea84ac4bb88454794928b77126e9246'),
                  TextSpan(
                      text: TIM_t("?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????")),
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
                  child: Text(TIM_t("???????????????"),
                      style:
                      const TextStyle(color: Colors.white, fontSize: 16))),
              onPressed: () {
                initService();
                Navigator.of(context).pop(true);
              },
            ),
            CupertinoDialogAction(
              child: Text(TIM_t("??????????????????"),
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

  // ???????????????
  getLoginCode(context) async {
    if (tel.isEmpty) {
      Utils.toast(TIM_t("??????????????????"));
      return;
    } else if (!RegExp(r"1[0-9]\d{9}$").hasMatch(tel)) {
      Utils.toast(TIM_t("?????????????????????"));
      return;
    } else {
      await _showMyDialog();
    }
  }

  // ?????????????????????????????????
  verifyPicture(messageObj) async {
    // String captchaWebAppid =
    //     Provider.of<AppConfig>(context, listen: false).appid;
    await lock.synchronized(() async {
      if(isSent){
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
        Utils.toast(TIM_t("?????????????????????"));
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
      Utils.toast(TIM_t("??????????????????"));
    }
    if (sessionId == '' || code == '') {
      Utils.toast(TIM_t("???????????????"));
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
        Utils.toast(
            TIM_t_para("????????????{{option1}}", "????????????$option1")(option1: option1));
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
      Utils.toast(errorMessage);
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
                //??????
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                //??????????????????
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
                      TIM_t("??????/??????"),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: CommonUtils.adaptFontSize(34)),
                    ),
                    CountryListPick(
                      appBar: AppBar(
                        // backgroundColor: Colors.blue,
                        title: Text(TIM_t("????????????????????????"),
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
                            // ???????????? 98
                            // ?????? 82 850
                            // ????????? 963
                            // ?????? 53
                            Text(
                                "${countryName == "China" ? "????????????" : countryName}(${countryCode?.dialCode})",
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
                          searchHintText: TIM_t("?????????????????????"),
                          searchText: TIM_t("??????")),
                      // Set default value
                      initialSelection: '+86',
                      onChanged: (code) {
                        setState(() {
                          dialCode = code?.dialCode ?? "+86";
                          countryName = code?.name ?? TIM_t("????????????");
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
                        TIM_t("?????????"),
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
                        hintText: TIM_t("??????????????????"),
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
                          TIM_t("?????????"),
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
                              hintText: TIM_t("??????????????????"),
                              hintStyle: TextStyle(
                                  fontSize: CommonUtils.adaptFontSize(32)),
                            ),
                            keyboardType: TextInputType.number,
                            //????????????
                            onChanged: (value) {
                              if ('$code$code' == value && value.length > 5) {
                                //?????????????????????
                                setState(() {
                                  userSigEtController.value = TextEditingValue(
                                    text: code, //??????????????? ?????????;
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: code.length),
                                    ), //  ?????????????????????????????????,
                                  );
                                });
                              } else {
                                //????????????????????????
                                setState(() {
                                  userSigEtController.value = TextEditingValue(
                                    text: value,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: value.length),
                                    ), //  ?????????????????????????????????,
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
                              TIM_t("???????????????"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CommonUtils.adaptFontSize(24),
                              ),
                            ),
                            onPressed: isGeted
                                ? null
                                : () {
                              //???????????????
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
                              child: Text(TIM_t("??????")),
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
