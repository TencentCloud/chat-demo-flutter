import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_demo/utils/theme.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';

class DefaultThemeData with ChangeNotifier {
  ThemeType _currentThemeType = ThemeType.brisk;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  TUITheme _theme = CommonColor.defaultTheme;

  TUITheme get theme {
    return _theme;
  }

  set theme(TUITheme theme) {
    _theme = theme;
    notifyListeners();
  }

  ThemeType get currentThemeType => _currentThemeType;

  set currentThemeType(ThemeType type) {
    _currentThemeType = type;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((prefs) {
      prefs.setString("themeType", type.toString());
    });
    _coreInstance.setTheme(theme: DefTheme.defaultTheme[type]!);
    theme = DefTheme.defaultTheme[type]!;
    notifyListeners();
  }
}
