// ignore_for_file: unused_import, unused_local_variable, avoid_print

import 'dart:io' show Platform;
import 'package:bugly/bugly.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';
import 'package:timuikit/custom_animation.dart';
import 'package:timuikit/i18n/strings.g.dart';
import 'package:timuikit/src/config.dart';
import 'package:timuikit/src/pages/app.dart';
import 'package:timuikit/src/pages/home_page.dart';
import 'package:timuikit/src/pages/web_support/app_web.dart';
import 'package:timuikit/src/provider/custom_sticker_package.dart';
import 'package:timuikit/src/provider/discuss.dart';
import 'package:timuikit/src/provider/local_setting.dart';
import 'package:timuikit/src/provider/login_user_Info.dart';
import 'package:timuikit/src/provider/theme.dart';

import 'package:provider/provider.dart';
import 'package:timuikit/utils/constant.dart';

import 'firebase_options.dart';
import 'i18n/i18n_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
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
  final String? deviceLocale =
      WidgetsBinding.instance?.window.locale.toLanguageTag();
  LocaleSettings.setLocale(TIMDemoI18n.findDeviceLocale(deviceLocale));

  // 这里打开后可以用Google FCM推送
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // 这里打开后可以用百度地图
  if (!kIsWeb && Platform.isIOS) {
    BMFMapSDK.setApiKeyAndCoordType(
        IMDemoConfig.baiduMapIOSAppKey, BMF_COORD_TYPE.BD09LL);
  } else if (!kIsWeb && Platform.isAndroid) {
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
  }
  BMFMapSDK.setAgreePrivacy(true);

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if (!kIsWeb && Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    BuglyOptions options = BuglyOptions(
      appId: Const.BAPPID,
      appKey: Const.BKEY,
      bundleId: Const.BID,
    );
    options.logger = (
      APMLogLevel level,
      String message, {
      String? tag,
      Object? exception,
      StackTrace? stackTrace,
    }) {
      print('[tencent im flutter uikit demo] ${level.name} $message $tag');
    };
    if (kIsWeb) {
      runApp(
        // runAutoApp(
        TranslationProvider(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => DiscussData()),
              ChangeNotifierProvider(create: (_) => LoginUserInfo()),
              ChangeNotifierProvider(create: (_) => LocalSetting()),
              ChangeNotifierProvider(create: (_) => DefaultThemeData()),
              ChangeNotifierProvider(create: (_) => CustomStickerPackageData()),
            ],
            child: const TUIKitDemoApp(),
          ),
        ),
      );
    } else {
      Bugly.init(options, appRunner: () {
        // main 函数原先的内容写在这里
        runApp(
          // runAutoApp(
          TranslationProvider(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => DiscussData()),
                ChangeNotifierProvider(create: (_) => LoginUserInfo()),
                ChangeNotifierProvider(create: (_) => LocalSetting()),
                ChangeNotifierProvider(create: (_) => DefaultThemeData()),
                ChangeNotifierProvider(
                    create: (_) => CustomStickerPackageData()),
              ],
              child: const TUIKitDemoApp(),
            ),
          ),
        );
      });
    }
  });
}

class TUIKitDemoApp extends StatelessWidget {
  const TUIKitDemoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return MaterialApp(
      title: 'Tencent Cloud Chat - 腾讯云IM - Flutter',
      navigatorKey: TUICalling.navigatorKey,
      locale: TranslationProvider.of(context).flutterLocale, // use provider
      supportedLocales: LocaleSettings.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // localeListResolutionCallback: (deviceLocale, supportedLocales){
      //   print('deviceLocale: $deviceLocale');
      // },
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: theme.primaryColor,
        )),
      ),
      home: kIsWeb ? const WebApp() : const MyApp(),
      builder: EasyLoading.init(),
      navigatorObservers: kIsWeb ? [] : [BuglyNavigatorObserver()],
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
