// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, unused_import,  prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tim_ui_kit/base_widgets/tim_ui_kit_base.dart';
import 'package:tim_ui_kit/data_services/conversation/conversation_services.dart';
import 'package:tim_ui_kit/data_services/core/core_services.dart';
import 'package:tim_ui_kit/data_services/core/tim_uikit_config.dart';
import 'package:tim_ui_kit/data_services/services_locatar.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tim_ui_kit/ui/utils/platform.dart';
import 'package:tim_ui_kit/ui/widgets/emoji.dart';
import 'package:tim_ui_kit_sticker_plugin/tim_ui_kit_sticker_plugin.dart';
import 'package:timuikit/src/channel.dart';
import 'package:timuikit/src/chat.dart';
import 'package:timuikit/src/config.dart';
import 'package:timuikit/src/pages/home_page.dart';
import 'package:timuikit/src/pages/login.dart';
import 'package:timuikit/src/provider/custom_sticker_package.dart';
import 'package:timuikit/src/provider/local_setting.dart';
import 'package:timuikit/src/provider/login_user_Info.dart';
import 'package:timuikit/src/provider/theme.dart';
import 'package:timuikit/src/routes.dart';
import 'package:timuikit/utils/constant.dart';
import 'package:timuikit/utils/push/channel/channel_push.dart';
import 'package:timuikit/utils/push/push_constant.dart';
import 'package:timuikit/utils/smsLogin.dart';
import 'package:timuikit/utils/theme.dart';
import 'package:timuikit/utils/toast.dart';
import 'package:timuikit/i18n/i18n_utils.dart';
import 'package:tim_ui_kit/ui/constants/emoji.dart';
import 'package:uni_links/uni_links.dart';

import 'package:timuikit/src/launch_page.dart';

bool isInitScreenUtils = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  var subscription;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  final ConversationService _conversationService =
      serviceLocator<ConversationService>();
  bool _initialURILinkHandled = false;
  BuildContext? _cachedContext;
  bool _isInitIMSDK = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (PlatformUtils().isIOS) {
      return;
    }
    print("--" + state.toString());
    int? unreadCount = await _getTotalUnreadCount();
    switch (state) {
      case AppLifecycleState.inactive:
        _coreInstance.setOfflinePushStatus(
            status: AppStatus.background, totalCount: unreadCount);
        if (unreadCount != null) {
          ChannelPush.setBadgeNum(unreadCount);
        }
        break;
      case AppLifecycleState.resumed:
        _coreInstance.setOfflinePushStatus(status: AppStatus.foreground);
        break;
      case AppLifecycleState.paused:
        _coreInstance.setOfflinePushStatus(
            status: AppStatus.background, totalCount: unreadCount);
        break;
      case AppLifecycleState.detached:
        // ignore: todo
        // TODO: Handle this case.
        break;
    }
  }

  directToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: LoginPage(initIMSDK: () => initIMSDKAndAddIMListeners()),
          );
        },
      ),
      ModalRoute.withName('/'),
    );
  }

  directToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: const HomePage(),
            );
          },
          settings: const RouteSettings(name: '/homePage')),
      ModalRoute.withName('/'),
    );
  }

  Future<int?> _getTotalUnreadCount() async {
    final res = await _sdkInstance
        .getConversationManager()
        .getTotalUnreadMessageCount();
    if (res.code == 0) {
      return res.data ?? 0;
    }
    return null;
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

  onKickedOffline() async {
// 被踢下线
    // 清除本地缓存，回到登录页TODO
    try {
      // Provider.of<ConversionModel>(context, listen: false).clear();
      // Provider.of<UserModel>(context, listen: false).clear();
      // Provider.of<CurrentMessageListModel>(context, listen: false).clear();
      // Provider.of<FriendListModel>(context, listen: false).clear();
      // Provider.of<FriendApplicationModel>(context, listen: false).clear();
      // Provider.of<GroupApplicationModel>(context, listen: false).clear();
      directToLogin();
      // 去掉存的一些数据
      removeLocalSetting();
      // ignore: empty_catches
    } catch (err) {}
    // Navigator.of(_cachedContext!).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
    //   ModalRoute.withName('/'),
    // );
  }

  initIMSDKAndAddIMListeners() async {
    if (_isInitIMSDK) return;

    final isInitSuccess = await _coreInstance.init(
      config: const TIMUIKitConfig(
        // This status is default to true,
        // its unnecessary to specify this if you tend to use online status.
        isShowOnlineStatus: true,
        isCheckDiskStorageSpace: true,
      ),
      onTUIKitCallbackListener: (TIMCallback callbackValue) {
        switch (callbackValue.type) {
          case TIMCallbackType.INFO:
            // Shows the recommend text for info callback directly
            Utils.toast(callbackValue.infoRecommendText!);
            break;

          case TIMCallbackType.API_ERROR:
            //Prints the API error to console, and shows the error message.
            print(
                "Error from TUIKit: ${callbackValue.errorMsg}, Code: ${callbackValue.errorCode}");
            if (callbackValue.errorCode == 10004 &&
                callbackValue.errorMsg!.contains("not support @all")) {
              Utils.toast(imt("当前群组不支持@全体成员"));
            } else {
              Utils.toast(
                  callbackValue.errorMsg ?? callbackValue.errorCode.toString());
            }
            break;

          case TIMCallbackType.FLUTTER_ERROR:
          default:
            // prints the stack trace to console or shows the catch error
            if (callbackValue.catchError != null) {
              Utils.toast(callbackValue.catchError.toString());
            } else {
              print(callbackValue.stackTrace);
            }
        }
      },
      sdkAppID: IMDemoConfig.sdkappid,
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: V2TimSDKListener(
        onConnectFailed: (code, error) {
          // localSetting.connectStatus = ConnectStatus.failed;
        },
        onConnectSuccess: () {
          // localSetting.connectStatus = ConnectStatus.success;
          Utils.log(imt("即时通信服务连接成功"));
        },
        onConnecting: () {
          // localSetting.connectStatus = ConnectStatus.connecting;
        },
        onKickedOffline: () {
          onKickedOffline();
        },
        onSelfInfoUpdated: (info) {
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
      Utils.toast(imt("即时通信 SDK初始化失败"));
      return;
    } else {}
    _isInitIMSDK = true;
  }

  initApp() {
    // getAllDiscussAndTopic();
    // 初始化IM SDK
    // initIMSDKAndAddIMListeners();
    // 获取登录凭证全局数据
    // getSmsLoginConfig();
    // 检测登录状态
    checkLogin();
  }

  // getSmsLoginConfig() async {
  //   Map<String, dynamic>? data = await SmsLogin.getGlsb();
  //   int errorCode = data!['errorCode'];
  //   String errorMessage = data['errorMessage'];
  //   Map<String, dynamic> info = data['data'];
  //   if (errorCode != 0) {
  //     Utils.toast(errorMessage);
  //   } else {
  //     // ignore: non_constant_identifier_names
  //     String captcha_web_appid = info['captcha_web_appid'].toString();
  //     print(captcha_web_appid);
  //     // Provider.of<AppConfig>(context, listen: false)
  //     //     .updateAppId(captcha_web_appid);
  //   }
  // }

  setTheme(String themeTypeString) {
    ThemeType themeType = DefTheme.themeTypeFromString(themeTypeString);
    Provider.of<DefaultThemeData>(context, listen: false).currentThemeType =
        themeType;
    Provider.of<DefaultThemeData>(context, listen: false).theme =
        DefTheme.defaultTheme[themeType]!;
    _coreInstance.setTheme(theme: DefTheme.defaultTheme[themeType]!);
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
    customStickerPackageList.addAll(Const.emojiList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
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
    Utils.log("$token $phone $userId");
    if (token != null && phone != null && userId != null) {
      Map<String, dynamic> response = await SmsLogin.smsTokenLogin(
        userId: userId,
        token: token,
      );
      int errorCode = response['errorCode'];
      String errorMessage = response['errorMessage'];

      if (errorCode == 0) {
        Map<String, dynamic> datas = response['data'];
        String userId = datas['userId'];
        String userSig = datas['sdkUserSig'];
        print(_coreInstance.loginUserInfo);
        await initIMSDKAndAddIMListeners();
        V2TimCallback data =
            await _coreInstance.login(userID: userId, userSig: userSig);

        if (data.code != 0) {
          final option8 = data.desc;
          Utils.toast(
              imt_para("登录失败 {{option8}}", "登录失败 $option8")(option8: option8));
          removeLocalSetting();
          directToLogin();
          return;
        }
        directToHomePage();
      } else {
        Utils.toast(errorMessage);
        directToLogin();
      }
    } else {
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
    _cachedContext = context;
    WidgetsBinding.instance?.addObserver(this);
    initApp();
    initRouteListener();
  }

  @override
  dispose() {
    super.dispose();
    print("========isDispose-=========");
    WidgetsBinding.instance?.removeObserver(this);
    Routes().dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtils();
    return const LaunchPage();
  }
}
