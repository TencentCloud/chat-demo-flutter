import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_demo/desktop/tencent_specific/about_us.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_settings_about.dart';

class TencentCloudChatSettingsTab extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  final VoidCallback onLogOut;
  final Function(Widget widget, String title)? setWidget;

  const TencentCloudChatSettingsTab({
    super.key,
    required this.userFullInfo,
    required this.onLogOut,
    this.setWidget,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsTabState();
}

class TencentCloudChatSettingsTabState
    extends TencentCloudChatState<TencentCloudChatSettingsTab> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return Column(
      children: [
        TencentCloudChatSettingTabFriendPermission(
            userFullInfo: widget.userFullInfo),
        const TencentCloudChatSettingTabTheme(),
        TencentCloudChatSettingsInfoAbout(
          setWidget: widget.setWidget,
        ),
        TencentCloudChatSettingsTabLogout(
          onLogOut: widget.onLogOut,
        ),
      ],
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return Column(
      children: [
        TencentCloudChatSettingTabFriendPermission(
            userFullInfo: widget.userFullInfo),
        const TencentCloudChatSettingTabTheme(),
        TencentCloudChatSettingsInfoAbout(
          setWidget: widget.setWidget,
        ),
        TencentCloudChatSettingsTabLogout(
          onLogOut: widget.onLogOut,
        ),
      ],
    );
  }
}

class TencentCloudChatSettingTabFriendPermission extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingTabFriendPermission(
      {super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatSettingTabFriendPermissionState();
}

class TencentCloudChatSettingTabFriendPermissionState
    extends TencentCloudChatState<TencentCloudChatSettingTabFriendPermission> {
  static List<String> permission = [
    tL10n.allowAny,
    tL10n.denyAny,
    tL10n.requireRequest,
    tL10n.none
  ];
  String dropdownValue = permission.first;

  @override
  initState() {
    super.initState();
    dropdownValue = permission[widget.userFullInfo.allowType ?? 0];
  }

  onPermissionChanged(String value) {
    int allowType = permission.indexOf(value);
    TencentCloudChat.instance.chatSDKInstance.setSelfInfo(allowType: allowType);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            margin: EdgeInsets.only(top: getHeight(23), bottom: getHeight(20)),
            padding: EdgeInsets.symmetric(
                vertical: getHeight(12), horizontal: getWidth(16)),
            color: colorTheme.settingTabBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: Text(tL10n.friendsPermission,
                      style: TextStyle(
                          fontSize: textStyle.fontsize_16,
                          color: colorTheme.settingTabTitleColor)),
                ),
                DropdownButton<String>(
                  alignment: Alignment.centerRight,
                  value: dropdownValue,
                  icon: Container(
                    margin: EdgeInsets.only(left: getWidth(8)),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: getSquareSize(12),
                    ),
                  ),
                  style: TextStyle(
                      fontSize: textStyle.fontsize_16,
                      fontWeight: FontWeight.w400,
                      color: colorTheme.contactItemFriendNameColor),
                  elevation: 16,
                  underline: Container(),
                  isDense: true,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    safeSetState(() {
                      dropdownValue = value!;
                      onPermissionChanged(value);
                    });
                  },
                  items:
                      permission.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            )));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
            margin: EdgeInsets.only(top: getHeight(23), bottom: getHeight(20)),
            padding: EdgeInsets.symmetric(
                vertical: getHeight(12), horizontal: getWidth(16)),
            color: colorTheme.settingTabBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: Text(tL10n.friendsPermission,
                      style: TextStyle(
                          fontSize: textStyle.fontsize_14,
                          color: colorTheme.secondaryTextColor)),
                ),
                DropdownButton<String>(
                  alignment: Alignment.centerRight,
                  value: dropdownValue,
                  icon: Container(
                    margin: EdgeInsets.only(left: getWidth(8)),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: getSquareSize(12),
                    ),
                  ),
                  style: TextStyle(
                      fontSize: textStyle.fontsize_14,
                      color: colorTheme.primaryTextColor),
                  elevation: 16,
                  underline: Container(),
                  isDense: true,
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    safeSetState(() {
                      dropdownValue = value!;
                      onPermissionChanged(value);
                    });
                  },
                  items:
                      permission.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            )));
  }
}

class TencentCloudChatSettingTabTheme extends StatefulWidget {
  const TencentCloudChatSettingTabTheme({super.key});

  @override
  State<StatefulWidget> createState() =>
      _TencentCloudChatSettingTabThemeState();
}

class _TencentCloudChatSettingTabThemeState
    extends TencentCloudChatState<TencentCloudChatSettingTabTheme> {
  static List<Brightness> skin = [Brightness.light, Brightness.dark];
  Brightness skinValue = skin.first;

  onSkinValueChanged(Brightness value) {
    TencentCloudChat.instance.chatController.toggleBrightnessMode(brightness: value);
  }

  List<(String, String, Locale)> language = [
    ("en", tL10n.english, const Locale('en')),
    ("ar", tL10n.ar, const Locale('ar')),
    (
      "zhHans",
      tL10n.simplifiedChinese,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
    ),
    (
      "zhHant",
      tL10n.traditionalChinese,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
    ),
    ("ja", tL10n.japanese, const Locale('ja')),
    ("ko", tL10n.korean, const Locale('ko')),
  ];

  late (String, String, Locale) languageValue;

  onLanguageValueChanged((String, String, Locale) language) {
    TencentCloudChatIntl().setLocale(language.$3);
    TencentCloudChat.instance.cache.cacheLocale(language.$3);
    showRestartDialog(context);
  }

  void showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TencentCloudChatThemeWidget(
            build: (context, colorTheme, textStyle) => AlertDialog(
                  content: Text(tL10n.restartAppForLanguage),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        tL10n.cancel,
                        style: TextStyle(color: colorTheme.secondaryTextColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        exit(0);
                      },
                      child: Text(tL10n.confirm),
                    ),
                  ],
                ));
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Locale currentLocale = TencentCloudChatIntl().getCurrentLocale(context);
    languageValue = language.firstWhere(
        (element) => element.$3.languageCode == currentLocale.languageCode);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: getHeight(12), horizontal: getWidth(16)),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: colorTheme.settingBackgroundColor)),
                    color: colorTheme.settingTabBackgroundColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(tL10n.appearance,
                            style: TextStyle(
                                fontSize: textStyle.fontsize_16,
                                color: colorTheme.settingTabTitleColor)),
                      ),
                      DropdownButton<Brightness>(
                        alignment: Alignment.centerRight,
                        value: skinValue,
                        icon: Container(
                          margin: EdgeInsets.only(left: getWidth(8)),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: getSquareSize(12),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: textStyle.fontsize_16,
                            fontWeight: FontWeight.w400,
                            color: colorTheme.contactItemFriendNameColor),
                        elevation: 16,
                        underline: Container(),
                        isDense: true,
                        onChanged: (Brightness? value) {
                          // This is called when the user selects an item.
                          safeSetState(() {
                            skinValue = value!;
                            onSkinValueChanged(value);
                          });
                        },
                        items: skin.map<DropdownMenuItem<Brightness>>(
                            (Brightness value) {
                          return DropdownMenuItem<Brightness>(
                            value: value,
                            child: Text(value == Brightness.dark
                                ? tL10n.darkTheme
                                : tL10n.lightTheme),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: getHeight(12), horizontal: getWidth(16)),
                  color: colorTheme.settingTabBackgroundColor,
                  child: Row(children: [
                    Expanded(
                      child: Text(tL10n.language,
                          style: TextStyle(
                              fontSize: textStyle.fontsize_16,
                              color: colorTheme.settingTabTitleColor)),
                    ),
                    DropdownButton<(String, String, Locale)>(
                      alignment: Alignment.centerRight,
                      value: languageValue,
                      icon: Container(
                        margin: EdgeInsets.only(left: getWidth(8)),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: getSquareSize(12),
                        ),
                      ),
                      style: TextStyle(
                          fontSize: textStyle.fontsize_16,
                          fontWeight: FontWeight.w400,
                          color: colorTheme.contactItemFriendNameColor),
                      elevation: 16,
                      underline: Container(),
                      isDense: true,
                      onChanged: ((String, String, Locale)? value) {
                        // This is called when the user selects an item.
                        safeSetState(() {
                          languageValue = value!;
                          onLanguageValueChanged(value);
                        });
                      },
                      items: language
                          .map<DropdownMenuItem<(String, String, Locale)>>(
                              ((String, String, Locale) value) {
                        return DropdownMenuItem<(String, String, Locale)>(
                          value: value,
                          child: Text(value.$2),
                        );
                      }).toList(),
                    ),
                  ]),
                )
              ],
            ));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: getHeight(12), horizontal: getWidth(16)),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: colorTheme.settingBackgroundColor)),
              color: colorTheme.settingTabBackgroundColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(tL10n.appearance,
                      style: TextStyle(
                          fontSize: textStyle.fontsize_14,
                          color: colorTheme.secondaryTextColor)),
                ),
                DropdownButton<Brightness>(
                  alignment: Alignment.centerRight,
                  value: skinValue,
                  icon: Container(
                    margin: EdgeInsets.only(left: getWidth(8)),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: getSquareSize(12),
                    ),
                  ),
                  style: TextStyle(
                      fontSize: textStyle.fontsize_14,
                      color: colorTheme.primaryTextColor),
                  elevation: 16,
                  underline: Container(),
                  isDense: true,
                  onChanged: (Brightness? value) {
                    // This is called when the user selects an item.
                    safeSetState(() {
                      skinValue = value!;
                      onSkinValueChanged(value);
                    });
                  },
                  items: skin
                      .map<DropdownMenuItem<Brightness>>((Brightness value) {
                    return DropdownMenuItem<Brightness>(
                      value: value,
                      child: Text(value == Brightness.dark
                          ? tL10n.darkTheme
                          : tL10n.lightTheme),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: getHeight(12), horizontal: getWidth(16)),
            color: colorTheme.settingTabBackgroundColor,
            child: Row(children: [
              Expanded(
                child: Text(tL10n.language,
                    style: TextStyle(
                        fontSize: textStyle.fontsize_14,
                        color: colorTheme.secondaryTextColor)),
              ),
              DropdownButton<(String, String, Locale)>(
                alignment: Alignment.centerRight,
                value: languageValue,
                icon: Container(
                  margin: EdgeInsets.only(left: getWidth(8)),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: getSquareSize(12),
                  ),
                ),
                style: TextStyle(
                    fontSize: textStyle.fontsize_14,
                    color: colorTheme.primaryTextColor),
                elevation: 16,
                underline: Container(),
                isDense: true,
                onChanged: ((String, String, Locale)? value) {
                  // This is called when the user selects an item.
                  safeSetState(() {
                    languageValue = value!;
                    onLanguageValueChanged(value);
                  });
                },
                items: language.map<DropdownMenuItem<(String, String, Locale)>>(
                    ((String, String, Locale) value) {
                  return DropdownMenuItem<(String, String, Locale)>(
                    value: value,
                    child: Text(value.$2),
                  );
                }).toList(),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class TencentCloudChatSettingsInfoAbout extends StatefulWidget {
  final Function(Widget widget, String title)? setWidget;

  const TencentCloudChatSettingsInfoAbout({super.key, this.setWidget});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatSettingsInfoAboutState();
}

class TencentCloudChatSettingsInfoAboutState
    extends TencentCloudChatState<TencentCloudChatSettingsInfoAbout> {
  onTapInfo() {
    if (widget.setWidget != null) {
      widget.setWidget!(
        const TencentCloudChatSettingsAbout(),
        tL10n.settings,
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TencentCloudChatSettingsAbout()));
    }
  }

  onTapAbout() {
    if (widget.setWidget != null) {
      widget.setWidget!(
        DesktopAboutUs(closeFunc: () {}),
        tL10n.about,
      );
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => InkWell(
              onTap: onTapInfo,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: getHeight(20)),
                padding: EdgeInsets.symmetric(
                    vertical: getHeight(12), horizontal: getWidth(16)),
                color: colorTheme.settingTabBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tL10n.aboutTencentCloudChat,
                      style: TextStyle(
                          fontSize: textStyle.fontsize_16,
                          fontWeight: FontWeight.w400,
                          color: colorTheme.settingTabTitleColor),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: getSquareSize(12),
                      color: colorTheme.settingTabTitleColor,
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: getHeight(20)),
            child: Material(
              color: colorTheme.settingTabBackgroundColor,
              child: InkWell(
                onTap: onTapAbout,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: getHeight(12), horizontal: getWidth(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tL10n.aboutTencentCloudChat,
                        style: TextStyle(
                            fontSize: textStyle.fontsize_14,
                            color: colorTheme.secondaryTextColor),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: getSquareSize(12),
                        color: colorTheme.settingTabTitleColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: getHeight(20)),
            child: Material(
              color: colorTheme.settingTabBackgroundColor,
              child: InkWell(
                onTap: onTapInfo,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: getHeight(12), horizontal: getWidth(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tL10n.more,
                        style: TextStyle(
                            fontSize: textStyle.fontsize_14,
                            color: colorTheme.secondaryTextColor),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: getSquareSize(12),
                        color: colorTheme.settingTabTitleColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TencentCloudChatSettingsTabLogout extends StatefulWidget {
  final VoidCallback onLogOut;

  const TencentCloudChatSettingsTabLogout({super.key, required this.onLogOut});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatSettingsTabLogoutState();
}

class TencentCloudChatSettingsTabLogoutState
    extends TencentCloudChatState<TencentCloudChatSettingsTabLogout> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => GestureDetector(
        onTap: widget.onLogOut,
        child: Container(
          transformAlignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          color: colorTheme.settingTabBackgroundColor,
          padding: EdgeInsets.symmetric(
              vertical: getHeight(12), horizontal: getWidth(16)),
          child: Text(tL10n.logOut,
              style: TextStyle(
                  fontSize: textStyle.fontsize_16,
                  fontWeight: FontWeight.w400,
                  color: colorTheme.settingLogoutColor)),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        color: colorTheme.settingTabBackgroundColor,
        child: InkWell(
          onTap: widget.onLogOut,
          child: Container(
            transformAlignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
                vertical: getHeight(12), horizontal: getWidth(16)),
            child: Text(tL10n.logOut,
                style: TextStyle(
                    fontSize: textStyle.fontsize_14,
                    color: colorTheme.settingLogoutColor)),
          ),
        ),
      ),
    );
  }
}
