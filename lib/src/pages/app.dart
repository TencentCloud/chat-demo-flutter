// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, unused_import,  prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/src/launch_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/login.dart';
import 'package:tencent_cloud_chat_demo/src/provider/custom_sticker_package.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/constant.dart';
import 'package:tencent_cloud_chat_demo/utils/init_step.dart';
import 'package:tencent_cloud_chat_demo/utils/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';

bool isInitScreenUtils = false;

class TencentChatApp extends StatefulWidget {
  const TencentChatApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TencentChatAppState();
}

class _TencentChatAppState extends State<TencentChatApp>
    with WidgetsBindingObserver {
  var subscription;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  final ConversationService _conversationService =
      serviceLocator<ConversationService>();
  bool _initialURILinkHandled = false;
  bool _isInitIMSDK = false;
  BuildContext? cachedBuildContext;

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
        _coreInstance.setOfflinePushStatus(
            status: AppStatus.background, totalCount: unreadCount);
        break;
      case AppLifecycleState.hidden:
        _coreInstance.setOfflinePushStatus(
            status: AppStatus.background, totalCount: unreadCount);
        break;
    }
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

  Future<void> _checkIfConnected() async {
    final res = await TencentImSDKPlugin.v2TIMManager.getLoginUser();
    if (res.data != null && res.data!.isNotEmpty) {
      return;
    } else if (res.data == null) {
      await initIMSDKAndAddIMListeners();
      InitStep.checkLogin(
          cachedBuildContext ?? context, initIMSDKAndAddIMListeners);
      return;
    } else if (res.data!.isEmpty) {
      InitStep.checkLogin(
          cachedBuildContext ?? context, initIMSDKAndAddIMListeners);
      return;
    } else {
      return;
    }
  }

  onKickedOffline() async {
// 被踢下线
    try {
      await TIMUIKitCore.getInstance().logout();
      InitStep.directToLogin(cachedBuildContext ?? context);
      // 去掉存的一些数据
      InitStep.removeLocalSetting();
      // ignore: empty_catches
    } catch (err) {}
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

  initIMSDKAndAddIMListeners() async {
    if (_isInitIMSDK) return;
    final LocalSetting localSetting =
        Provider.of<LocalSetting>(context, listen: false);
    await localSetting.loadSettingsFromLocal();
    final language = localSetting.language ?? await getLanguage();
    localSetting.updateLanguageWithoutWriteLocal(language);

    // The log path provided here is for demonstration purposes only.
    // You may customize the path according to your project requirements.
    String? logPath;
    if (!PlatformUtils().isWeb) {
      final String documentsDirectoryPath =
          "${Platform.environment['USERPROFILE']}";
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String pkgName = packageInfo.packageName;
      var timeName =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      logPath = p.join(documentsDirectoryPath, "Documents", ".TencentCloudChat",
          pkgName, "uikit_log", 'Flutter-TUIKit-$timeName.log');
    }

    final isInitSuccess = await _coreInstance.init(
      onWebLoginSuccess: getLoginUserInfo,
      uikitLogPath: logPath,
      config: const TIMUIKitConfig(
        // This status is default to true,
        // its unnecessary to specify this if you tend to use online status.
        isShowOnlineStatus: true,
        isCheckDiskStorageSpace: true,
      ),
      // language: LanguageEnum.zhHans,
      // extraLanguage: localSetting.language,
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
            } else if (callbackValue.errorCode == -4) {
              return;
            } else if (callbackValue.errorCode == -1) {
              return;
            } else {
              if (callbackValue.infoRecommendText != null &&
                  callbackValue.infoRecommendText!.isNotEmpty) {
                ToastUtils.toast(callbackValue.infoRecommendText!);
              } else {
                ToastUtils.toast(callbackValue.errorMsg ??
                    callbackValue.errorCode.toString());
              }
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
      sdkAppID: IMDemoConfig.sdkAppID,
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: V2TimSDKListener(
        onConnectFailed: (code, error) {
          // localSetting.connectStatus = ConnectStatus.failed;
        },
        onConnectSuccess: () {
          // localSetting.connectStatus = ConnectStatus.success;
          ToastUtils.log(TIM_t("即时通信服务连接成功"));
        },
        onConnecting: () {
          // localSetting.connectStatus = ConnectStatus.connecting;
        },
        onKickedOffline: () {
          ToastUtils.toast(TIM_t("您的账号已在其它终端登录"));
          onKickedOffline();
        },
        onSelfInfoUpdated: (info) {
          Provider.of<LoginUserInfo>(context, listen: false)
              .setLoginUserInfo(info);
          // onSelfInfoUpdated(info);
        },
        onUserSigExpired: () {
          // userSig过期，相当于踢下线
          ToastUtils.toast(TIM_t("账号已过期，请重新登录"));
          onKickedOffline();
        },
      ),
    );
    if (isInitSuccess == null || !isInitSuccess) {
      ToastUtils.toast(TIM_t("即时通信 SDK初始化失败"));
      return;
    } else {}
    _isInitIMSDK = true;
  }

  initApp() {
    // 检测登录状态
    InitStep.checkLogin(context, initIMSDKAndAddIMListeners);
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
        InitStep.directToLogin(cachedBuildContext ?? context);
      }

      if (pageType == "homePage") {
        InitStep.directToHomePage(cachedBuildContext ?? context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initApp();
    initRouteListener();
  }

  @override
  dispose() {
    super.dispose();
    print("========isDispose-=========");
    WidgetsBinding.instance.removeObserver(this);
    Routes().dispose();
  }

  @override
  Widget build(BuildContext context) {
    cachedBuildContext ??= context;
    initScreenUtils();
    ToastUtils.init(context);
    return const LaunchPage();
  }
}
