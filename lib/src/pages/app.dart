// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, unused_import,  prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_demo/utils/init_step.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/data_services/conversation/conversation_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/config.dart';
import 'package:tencent_cloud_chat_demo/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/login.dart';
import 'package:tencent_cloud_chat_demo/src/provider/custom_sticker_package.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/constant.dart';
import 'package:tencent_cloud_chat_demo/utils/push/channel/channel_push.dart';
import 'package:tencent_cloud_chat_demo/utils/push/push_constant.dart';
import 'package:tencent_cloud_chat_demo/utils/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:tencent_cloud_chat_demo/utils/unicode_emoji.dart';
import 'package:uni_links/uni_links.dart';
import 'package:tencent_cloud_chat_demo/src/launch_page.dart';

bool isInitScreenUtils = false;

class MobileApp extends StatefulWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> with WidgetsBindingObserver {
  var subscription;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  final ConversationService _conversationService =
      serviceLocator<ConversationService>();
  bool _initialURILinkHandled = false;
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
        await _checkIfConnected();
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
    if(res.data != null && res.data!.isNotEmpty){
      return;
    }else if(res.data == null){
      await initIMSDKAndAddIMListeners();
      InitStep.checkLogin(context, initIMSDKAndAddIMListeners);
      return;
    } else if (res.data!.isEmpty){
      InitStep.checkLogin(context, initIMSDKAndAddIMListeners);
      return;
    } else{
      return;
    }
  }

  onKickedOffline() async {
// 被踢下线
    try {
      InitStep.directToLogin(context);
      // 去掉存的一些数据
      InitStep.removeLocalSetting();
      // ignore: empty_catches
    } catch (err) {}
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
      // language: LanguageEnum.zhHans,
      // extraLanguage: "zh-Hans",
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
            } else if (callbackValue.errorCode == -1) {
              return;
            } else {
              ToastUtils.toast(
                  callbackValue.errorMsg ?? callbackValue.errorCode.toString());
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
        InitStep.directToLogin(context);
      }

      if (pageType == "homePage") {
        InitStep.directToHomePage(context);
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
    initScreenUtils();
    ToastUtils.init(context);
    return const LaunchPage();
  }
}
