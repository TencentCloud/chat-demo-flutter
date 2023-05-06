import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/login.dart';
import 'package:tencent_cloud_chat_demo/src/provider/custom_sticker_package.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/constant.dart';
import 'package:tencent_cloud_chat_demo/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/utils/unicode_emoji.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';

class InitStep {
  static setTheme(String themeTypeString, BuildContext context) {
    final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
    ThemeType themeType = DefTheme.themeTypeFromString(themeTypeString);
    Provider.of<DefaultThemeData>(context, listen: false).currentThemeType =
        themeType;
    Provider.of<DefaultThemeData>(context, listen: false).theme =
    DefTheme.defaultTheme[themeType]!;
    _coreInstance.setTheme(theme: DefTheme.defaultTheme[themeType]!);
  }

  static setCustomSticker(BuildContext context) async {
    // 添加自定义表情包
    List<CustomStickerPackage> customStickerPackageList = [];

    // 不使用emoji
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
  }

  static void removeLocalSetting() async {
  }

  static directToLogin(BuildContext context, [Function? initIMSDKAndAddIMListeners]) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: LoginPage(initIMSDK: initIMSDKAndAddIMListeners),
          );
        },
      ),
      ModalRoute.withName('/'),
    );
  }

  static directToHomePage(BuildContext context) {
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: isWideScreen
                  ? const HomePageWideScreen()
                  : const HomePage(),
            );
          },
          settings: const RouteSettings(name: '/homePage')),
      ModalRoute.withName('/'),
    );
  }

  static void checkLogin(BuildContext context, initIMSDKAndAddIMListeners) async {
    // 初始化IM SDK
    initIMSDKAndAddIMListeners();

    Future.delayed(const Duration(seconds: 1), () {
      directToLogin(context);
      // 修改自定义表情的执行时机
      setCustomSticker(context);
    });
  }
}