import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/login/GenerateUserSig.dart';
import 'package:tencent_cloud_chat_demo/login/toast_utils.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<LoginInfo> generateLoginInfo;

  LoginPage({super.key, required this.generateLoginInfo});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends TencentCloudChatState<LoginPage> {
  String userID = '';

  userLogin() async {
    if (userID.trim() == '') {
      ToastUtils.toast("Please input userID");
      return;
    }

    String key = IMConfig.key;
    int sdkAppId = IMConfig.sdkAppID;
    if (key == "") {
      ToastUtils.toast("Please set sdkAppID and key in config.dart");
      return;
    }

    GenerateDevUsersigForTest generateTestUserSig = GenerateDevUsersigForTest(
      sdkappid: sdkAppId,
      key: key,
    );

    // 7 x 24 x 60 x 60 = 604800 = 7 days
    String userSig = generateTestUserSig.genSig(identifier: userID, expire: 604800);
    LoginInfo loginInfo = LoginInfo();
    loginInfo.userID = userID;
    loginInfo.userSig = userSig;
    widget.generateLoginInfo(loginInfo);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        child: MoveWindow(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                colors: <Color>[
                  colorTheme.desktopBackgroundColorLinearGradientOne,
                  colorTheme.desktopBackgroundColorLinearGradientTwo,
                  colorTheme.desktopBackgroundColorLinearGradientOne
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/icon.png"),
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    tL10n.tencentCloudChat,
                    style: TextStyle(fontSize: 24, color: colorTheme.primaryColor.withOpacity(0.7)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 14),
                      hintText: "please input userID",
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[500],
                      ),
                    ),
                    style: const TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    onChanged: (v) {
                      setState(() {
                        userID = v;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        onPressed: userLogin,
                        style: TextButton.styleFrom(
                          backgroundColor: colorTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginInfo {
  String userID = "";
  String userSig = "";
}
