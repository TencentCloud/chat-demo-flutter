// ignore_for_file: unused_import, deprecated_member_use

import 'dart:io' show Platform;

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_webview_window_for_is/desktop_webview_window_for_is.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:tencent_calls_uikit/debug/generate_test_user_sig.dart';
import 'package:tencent_cloud_chat_demo/custom_animation.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/src/pages/app.dart';
import 'package:tencent_cloud_chat_demo/src/provider/custom_sticker_package.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/provider/user_guide_provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

void main(List<String> args) {
  debugPrint('args: $args');
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  WidgetsFlutterBinding.ensureInitialized();
  // 设置状态栏样式
  SystemUiOverlayStyle style = SystemUiOverlayStyle(
    statusBarColor: hexToColor('ededed'),
  );
  SystemChrome.setSystemUIOverlayStyle(style);
  // 全局loading
  configLoading();
  // AutoSizeUtil.setStandard(375, isAutoTextSize: true);
  // fast i18n use device locale
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  if (PlatformUtils().isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      // runAutoApp(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LoginUserInfo()),
            ChangeNotifierProvider(create: (_) => DefaultThemeData()),
            ChangeNotifierProvider(create: (_) => CustomStickerPackageData()),
            ChangeNotifierProvider(
              create: (_) => LocalSetting(),
            ),
            ChangeNotifierProvider(create: (_) => UserGuideProvider()),
          ],
          child: const TUIKitDemoApp(),
        ),
      ),
    );
  });

  if (PlatformUtils().isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(1300, 830);
      appWindow.minSize = const Size(1100, 630);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }

  /// 使用 TUIVoIP Extension 插件，收到 VoIP 推送， APP 被激活， 这个时候需要完成自动登陆操作。
  /// 自动登陆 操作需要在 UI 绘制之前完成（APP 切到前台时， 才会执行UI 绘制的代码）。
  /// 请根据您的业务代码， 在程序激活后完成登陆！！！
  ///
  /// Use TUIVoIP Extension plug-in, receive VoIP push, APP is activated, at this time you need to complete the automatic login operation.
  /// The automatic login operation needs to be completed before the UI is drawn (the UI drawing code will be executed only when the APP is switched to the foreground).
  /// Please complete the login after the program is activated according to your business code! ! !
  TUICallKit.instance.login(IMDemoConfig.sdkAppID, '****', GenerateTestUserSig.genTestSig("****", IMDemoConfig.sdkAppID, IMDemoConfig.key));
}

class TUIKitDemoApp extends StatelessWidget {
  const TUIKitDemoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return MaterialApp(
      title: 'Tencent Cloud Chat - 腾讯云IM - Flutter',
      debugShowCheckedModeBanner: false,
      locale: TranslationProvider.of(context).flutterLocale, // use provider
      supportedLocales: LocaleSettings.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
        )),
      ),
      home: const TencentChatApp(),
      builder: EasyLoading.init(),
      navigatorObservers: !PlatformUtils().isMobile ? [] : [TUICallKit.navigatorObserver],
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}
