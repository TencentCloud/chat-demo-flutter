import 'dart:ui';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';


enum ThemeType { solemn, brisk, bright, fantasy }

class DefTheme {
  static ThemeType themeTypeFromString(String str) {
    return ThemeType.values
        .firstWhere((e) => e.toString() == str, orElse: () => ThemeType.brisk);
  }

  static final Map<ThemeType, TUITheme> defaultTheme = {
    ThemeType.solemn: const TUITheme(
      primaryColor: Color(0xFF00449E),
      lightPrimaryColor: Color(0xFF3371CD),
    ),
    ThemeType.brisk: const TUITheme(
      primaryColor: Color(0xFF147AFF),
      lightPrimaryColor: Color(0xFFC0E1FF),
    ),
    ThemeType.bright: const TUITheme(
      primaryColor: Color(0xFFF38787),
      lightPrimaryColor: Color(0xFFFAE1B6),
    ),
    ThemeType.fantasy: const TUITheme(
      primaryColor: Color(0xFF8783F0),
      lightPrimaryColor: Color(0xFFAEB6F4),
    ),
  };

  static final Map<ThemeType, String> defaultThemeName = {
    ThemeType.solemn: TIM_t("深沉"),
    ThemeType.brisk: TIM_t("轻快"),
    ThemeType.bright: TIM_t("明媚"),
    ThemeType.fantasy: TIM_t("梦幻")
  };
}
