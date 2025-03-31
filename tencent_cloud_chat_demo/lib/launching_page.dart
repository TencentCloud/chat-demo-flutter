import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/login/login.dart';

class TencentCloudChatLoginData {
  static int sdkAppID = IMConfig.sdkAppID;
  static String userID = IMConfig.userid;
  static String userSig = IMConfig.usersig;

  static Future<void> removeLocalSetting() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    SharedPreferences prefs = await prefs0;
    prefs.remove(LoginPage.DEV_LOGIN_USER_ID);
    prefs.remove(LoginPage.DEV_LOGIN_USER_SIG);
    return;
  }
}

class LaunchingPage extends StatefulWidget {
  final ValueChanged<bool> changeLoginState;

  const LaunchingPage({super.key, required this.changeLoginState});

  @override
  State<LaunchingPage> createState() => _LaunchingPageState();
}

class _LaunchingPageState extends TencentCloudChatState<LaunchingPage>
    with SingleTickerProviderStateMixin {
  Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  double _progressValue = 0.1;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressController)
          ..addListener(() {
            setState(() {
              _progressValue = _progressAnimation.value;
            });
          });

    _initSampleApp();
  }

  void _initSampleApp() async {
    _updateProgressBar(0.1);
    SharedPreferences prefs = await prefs0;
    final userID = prefs.getString(LoginPage.DEV_LOGIN_USER_ID);
    final userSig = prefs.getString(LoginPage.DEV_LOGIN_USER_SIG);
    if (userID != null && userID.isNotEmpty && userSig != null && userSig.isNotEmpty) {
      safeSetState(() {
        TencentCloudChatLoginData.sdkAppID = IMConfig.sdkAppID;
        TencentCloudChatLoginData.userID = userID;
        TencentCloudChatLoginData.userSig = userSig;
      });
      _navigateBackToHomePage();
    } else {
      _navigateToLogin();
    }
  }

  _navigateToLogin() {
    _updateProgressBar(1.0);
    TencentCloudChatLoginData.removeLocalSetting();
    Future.delayed(const Duration(milliseconds: 10), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            changeLoginState: (bool isLogin) {
              widget.changeLoginState(isLogin);
            },
          ),
        ),
      );
    });
  }

  _navigateBackToHomePage() {
    _updateProgressBar(1.0);
    Future.delayed(const Duration(milliseconds: 210), () {
      widget.changeLoginState(true);
    });
  }

  void _updateProgressBar([double? progress]) {
    double newProgressValue = 0.1;
    if (progress != null) {
      newProgressValue = progress;
    } else {
      double progressIncrement = 0.3;
      newProgressValue = 0.1;
      newProgressValue += progressIncrement;
    }

    _progressAnimation = _progressController.drive(
      Tween<double>(begin: _progressValue, end: newProgressValue),
    );
    _progressController.reset();
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return Scaffold(
      body: TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Stack(
          children: [
            Container(
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
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/icon.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        tL10n.tencentCloudChat,
                        style: TextStyle(
                          color: colorTheme.primaryColor.withOpacity(0.7),
                          fontSize: textStyle.fontsize_22,
                        ),
                      )
                    ],
                  ),
                )),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: LinearProgressIndicator(
                  value: _progressValue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/splash_new.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: LinearProgressIndicator(
                value: _progressValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
