// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, empty_catches

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';
import 'package:timuikit/src/config.dart';
import 'package:timuikit/src/launch_page.dart';
import 'package:timuikit/src/pages/home_page.dart';
import 'package:timuikit/src/pages/login.dart';
import 'package:timuikit/src/provider/login_user_Info.dart';
import 'package:timuikit/src/routes.dart';
import 'package:timuikit/utils/push/channel/channel_push.dart';
import 'package:timuikit/utils/toast.dart';

import 'package:timuikit/src/provider/custom_sticker_package.dart';
import 'package:timuikit/utils/constant.dart';
import 'package:provider/provider.dart';
import 'package:timuikit/utils/unicode_emoji.dart';

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // ChannelPush.clearAllNotification();
    if (Platform.isIOS) {
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
        await _checkIfConnected();
        _coreInstance.setOfflinePushStatus(status: AppStatus.foreground);
        break;
      case AppLifecycleState.paused:
        _coreInstance.setOfflinePushStatus(
            status: AppStatus.background, totalCount: unreadCount);
        break;
      case AppLifecycleState.detached:

        break;
    }
  }

  Future<void> _checkIfConnected() async {
    final res = await TencentImSDKPlugin.v2TIMManager.getLoginUser();
    if(res.data != null && res.data!.isNotEmpty){
      return;
    }else if(res.data == null){
      await initIMSDKAndAddIMListeners();
      await checkLogin();
      return;
    } else if (res.data!.isEmpty){
      await checkLogin();
      return;
    } else{
      return;
    }
  }

  checkLogin() async {
    // 这里执行各位自己的自动登陆逻辑
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

  directToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const LoginPage(),
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
          settings: const RouteSettings(name: '/homePage')
      ),
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

  onKickedOffline() async {
    try {
      directToLogin();
    } catch (err) {}
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
      ModalRoute.withName('/'),
    );
  }

  initIMSDKAndAddIMListeners() async {
    final isInitSuccess = await _coreInstance.init(
      // You can specify the language here,
      // not providing this field means using the system language.
      // language: LanguageEnum.zh,

      config: const TIMUIKitConfig(
        // This status is default to true,
        // its unnecessary to specify this if you tend to use online status.
        isShowOnlineStatus: true,
        isCheckDiskStorageSpace: true,
      ),
      onWebLoginSuccess: getLoginUserInfo,
      // language: LanguageEnum.zhHans,
      // extraLanguage: "zh-Hans",
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
              Utils.toast(TIM_t("当前群组不支持@全体成员"));
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
        onConnectFailed: (code, error) {},
        onConnectSuccess: () {
          // Connected to Tencent IM server success
          Utils.log(TIM_t("即时通信服务连接成功"));
        },
        onConnecting: () {},
        onKickedOffline: () {
          // The current user has been kicked off, by other devices
          onKickedOffline();
        },
        onSelfInfoUpdated: (info) {
          print(TIM_t("信息已变更"));
          Provider.of<LoginUserInfo>(context, listen: false)
              .setLoginUserInfo(info);
          // onSelfInfoUpdated(info);
        },
        onUserSigExpired: () {
          // The Usersig is expired
          onKickedOffline();
        },
      ),
    );
    if (isInitSuccess == null || !isInitSuccess) {
      Utils.toast(TIM_t("即时通信 SDK初始化失败"));
    } else {}
    // setState(() {
    //   hasInit = true;
    // });
  }

  initApp() {
    // 初始化IM SDK
    initIMSDKAndAddIMListeners();

    Future.delayed(const Duration(seconds: 1), () {
      directToLogin();
      // 修改自定义表情的执行时机
      setCustomSticker();
    });
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
    WidgetsBinding.instance?.addObserver(this);
    initApp();
    initRouteListener();
  }

  @override
  dispose() {
    super.dispose();
    Routes().dispose();
    WidgetsBinding.instance?.removeObserver(this);
    // subscription.cancle();
  }

  setCustomSticker() async {
    List<CustomStickerPackage> customStickerPackageList = [];

    // 表情项一：使用Emoji Unicode表情列表，以字符串形式。可以嵌入文字内容中。
    // Solution A: Use Emoji Unicode list, as String. Can be added to text messages.
    final defEmojiList = emojiData.asMap().keys.map((emojiIndex) {
      final emoji = Emoji.fromJson(emojiData[emojiIndex]);
      return CustomSticker(
          index: emojiIndex, name: emoji.name, unicode: emoji.unicode);
    }).toList();
    customStickerPackageList.add(CustomStickerPackage(
        name: "defaultEmoji",
        stickerList: defEmojiList,
        menuItem: defEmojiList[0]));

    // 表情项二：使用您提供的图片表情包。
    // Solution B: Use the image sticker.
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

  @override
  Widget build(BuildContext context) {
    initScreenUtils();
    return const LaunchPage();
  }
}

