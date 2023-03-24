// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, empty_catches

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';
import 'package:tencent_cloud_chat_demo/src/config.dart';
import 'package:tencent_cloud_chat_demo/src/launch_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/login.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/smsLogin.dart';
import 'package:tencent_cloud_chat_demo/utils/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:tencent_cloud_chat_demo/src/provider/custom_sticker_package.dart';
import 'package:tencent_cloud_chat_demo/utils/constant.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/utils/unicode_emoji.dart';

bool isInitScreenUtils = false;

class CrossPlatformApp extends StatefulWidget {
  const CrossPlatformApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<CrossPlatformApp> with WidgetsBindingObserver {
  var subscription;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();

  directToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const WebLoginPage(),
          );
        },
      ),
      ModalRoute.withName('/'),
    );
  }

  directToHomePage() {
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == ScreenType.Wide;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: isWideScreen
                ? HomePageWideScreen(key: widget.key)
                : HomePage(key: widget.key),
          );
        },
      ),
      ModalRoute.withName('/'),
    );
  }

  onKickedOffline() async {
    try {
      directToLogin();
    } catch (err) {}
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (BuildContext context) => const WebLoginPage()),
      ModalRoute.withName('/'),
    );
  }

  getLoginUserInfo() async {
    final res = await _sdkInstance.getLoginUser();
    if (res.code == 0) {
      final result = await _sdkInstance.getUsersInfo(userIDList: [res.data!]);

      if (result.code == 0) {
        Provider.of<LoginUserInfo>(context, listen: false)
            .setLoginUserInfo(result.data![0]);
      }
    }
  }

  Future<String> getLanguage() async {
    final String? deviceLocale =
        WidgetsBinding.instance.window.locale.toLanguageTag();
    final AppLocale appLocale = I18nUtils.findDeviceLocale(deviceLocale);
    switch (appLocale) {
      case AppLocale.zhHans:
        return "zh-Hans";
      case AppLocale.zhHant:
        return "zh-Hant";
      case AppLocale.en:
        return "en";
      case AppLocale.ja:
        return "ja";
      case AppLocale.ko:
        return "ko";
    }
  }

  Future<void> initIMSDKAndAddIMListeners() async {
    final LocalSetting localSetting =
        Provider.of<LocalSetting>(context, listen: false);
    await localSetting.loadSettingsFromLocal();
    localSetting.language ??= await getLanguage();
    try {
      final isInitSuccess = await _coreInstance.init(
        // You can specify the language here,
        // not providing this field means using the system language.
        extraLanguage: localSetting.language,
        onWebLoginSuccess: getLoginUserInfo,
        config: TIMUIKitConfig(
          // This status is default to true,
          // its unnecessary to specify this if you tend to use online status.
          isShowOnlineStatus: localSetting.isShowOnlineStatus,
        ),
        onTUIKitCallbackListener: (TIMCallback callbackValue) {
          switch (callbackValue.type) {
            case TIMCallbackType.INFO:
              // Shows the recommend text for info callback directly
              ToastUtils.toast(callbackValue.infoRecommendText!);
              break;

            case TIMCallbackType.API_ERROR:
              //Prints the API error to console, and shows the error message.
              print(
                  "Error from TUIKit: ${callbackValue.errorMsg}, Code: ${callbackValue.errorCode}");
              if (callbackValue.errorCode == 10004 &&
                  callbackValue.errorMsg!.contains("not support @all")) {
                ToastUtils.toast(TIM_t("当前群组不支持@全体成员"));
              } else {
                ToastUtils.toast(callbackValue.errorMsg ??
                    callbackValue.errorCode.toString());
              }
              break;

            case TIMCallbackType.FLUTTER_ERROR:
            default:
              // prints the stack trace to console or shows the catch error
              if (callbackValue.catchError != null) {
                ToastUtils.toast(callbackValue.catchError.toString());
              } else {
                print(callbackValue.stackTrace);
              }
          }
        },
        sdkAppID: IMDemoConfig.sdkappid,
        loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
        listener: V2TimSDKListener(
          onConnectFailed: (code, error) {},
          onConnectSuccess: () {
            ToastUtils.log(TIM_t("即时通信服务连接成功"));
          },
          onConnecting: () {},
          onKickedOffline: () {
            onKickedOffline();
          },
          onSelfInfoUpdated: (info) {
            print(TIM_t("信息已变更"));
            Provider.of<LoginUserInfo>(context, listen: false)
                .setLoginUserInfo(info);
            // onSelfInfoUpdated(info);
          },
          onUserSigExpired: () {
            // userSig过期，相当于踢下线
            onKickedOffline();
          },
        ),
      );
      if (isInitSuccess == null || !isInitSuccess) {
        ToastUtils.toast(TIM_t("即时通信 SDK初始化失败"));
      }
    } catch (e) {
      ToastUtils.toast(e.toString());
    }
    return;
  }

  initApp() async {
    // 初始化IM SDK
    await initIMSDKAndAddIMListeners();

    Future.delayed(const Duration(seconds: 1), () {
      checkLogin();
      // 修改自定义表情的执行时机
      setCustomSticker();
    });
  }

  setTheme(String themeTypeString) {
    ThemeType themeType = DefTheme.themeTypeFromString(themeTypeString);
    Provider.of<DefaultThemeData>(context, listen: false).currentThemeType =
        themeType;
    Provider.of<DefaultThemeData>(context, listen: false).theme =
        DefTheme.defaultTheme[themeType]!;
    _coreInstance.setTheme(theme: DefTheme.defaultTheme[themeType]!);
  }

  removeLocalSetting() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.remove("smsLoginToken");
    prefs.remove("smsLoginPhone");
    prefs.remove("smsLoginUserID");
    prefs.remove("channelListMain");
    prefs.remove("discussListMain");
    prefs.remove("themeType");
  }

  checkLogin() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    String? token = prefs.getString("smsLoginToken");
    String? phone = prefs.getString("smsLoginPhone");
    String? userId = prefs.getString("smsLoginUserID");
    String themeTypeString = prefs.getString("themeType") ?? "";
    setTheme(themeTypeString);
    setCustomSticker();
    if (token != null && phone != null && userId != null) {
      Map<String, dynamic> response = await SmsLogin.smsTokenLogin(
        userId: userId,
        token: token,
      );
      int errorCode = response['errorCode'];

      if (errorCode == 0) {
        Map<String, dynamic> datas = response['data'];
        String userId = datas['userId'];
        String userSig = datas['sdkUserSig'];
        V2TimCallback data =
            await _coreInstance.login(userID: userId, userSig: userSig);

        if (data.code != 0) {
          final option8 = data.desc;
          ToastUtils.toast(TIM_t_para("登录失败 {{option8}}", "登录失败 $option8")(
              option8: option8));
          removeLocalSetting();
          directToLogin();
          return;
        }
        directToHomePage();
      } else {
        removeLocalSetting();
        directToLogin();
      }
    } else {
      removeLocalSetting();
      directToLogin();
    }
  }

  initScreenUtils() {
    if (isInitScreenUtils) return;
    ScreenUtil.init(
      context,
      designSize: const Size(750, 1624),
      minTextAdapt: true,
    );
    isInitScreenUtils = true;
  }

  initRouteListener() {
    final routes = Routes();
    routes.addListener(() {
      final pageType = routes.pageType;
      if (pageType == "loginPage") {
        directToLogin();
      }

      if (pageType == "homePage") {
        directToHomePage();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      ToastUtils.init(context);
      initRouteListener();
      WidgetsBinding.instance.addObserver(this);
      initApp();
    } catch (e) {
      ToastUtils.toast(e.toString());
    }
  }

  @override
  dispose() {
    super.dispose();
    Routes().dispose();
    WidgetsBinding.instance.removeObserver(this);
    // subscription.cancle();
  }

  setCustomSticker() async {
    // 添加自定义表情包
    List<CustomStickerPackage> customStickerPackageList = [];
    final defEmojiList = emojiData.asMap().keys.map((emojiIndex) {
      final emo = Emoji.fromJson(emojiData[emojiIndex]);
      return CustomSticker(
          index: emojiIndex, name: emo.name, unicode: emo.unicode);
    }).toList();
    customStickerPackageList.add(CustomStickerPackage(
        name: "defaultEmoji",
        stickerList: defEmojiList,
        menuItem: defEmojiList[0]));
    StickerListUtil stickerListUtil =
        StickerListUtil(Const.emojiList.map((e) => e.toJson()).toList());
    customStickerPackageList.addAll(Const.emojiList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map((idx) =>
                  CustomSticker(index: idx, name: customEmojiPackage.list[idx]))
              .toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList());
    Provider.of<CustomStickerPackageData>(context, listen: false)
        .customStickerPackageList = customStickerPackageList;
    Provider.of<CustomStickerPackageData>(context, listen: false)
        .stickerListUtil = stickerListUtil;
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtils();
    ToastUtils.init(context);
    return const LaunchPage();
  }
}
