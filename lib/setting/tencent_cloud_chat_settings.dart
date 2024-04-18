import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/data/basic/tencent_cloud_chat_basic_data.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/empty_page/tencent_cloud_chat_empty_page.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_settings_body.dart';

class TencentCloudChatSettings extends StatefulWidget {
  final VoidCallback onLogOut;

  const TencentCloudChatSettings({super.key, required this.onLogOut});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsState();
}

class TencentCloudChatSettingsState
    extends TencentCloudChatState<TencentCloudChatSettings> {
  V2TimUserFullInfo? _userFullInfo;

  Widget? _settingModule;
  String? _title;

  @override
  void initState() {
    super.initState();

    _addEventListener();
    _userFullInfo = TencentCloudChat.instance.dataInstance.basic.currentUser;
  }

  void _addEventListener() {
    TencentCloudChat.instance.eventBusInstance
        .on<TencentCloudChatBasicData<TencentCloudChatBasicDataKeys>>()
        ?.listen((event) {
      if (event.currentUpdatedFields ==
          TencentCloudChatBasicDataKeys.selfInfo) {
        safeSetState(() {
          _userFullInfo = event.currentUser;
        });
      }
    });
  }

  @override
  Widget tabletAppBuilder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: desktopBuilder(context),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          backgroundColor: colorTheme.settingBackgroundColor,
          title: Row(
            children: [
              Container(
                width: getWidth(14),
              ),
              Expanded(
                  child: Text(
                tL10n.settings,
                style: TextStyle(
                    color: colorTheme.settingTitleColor,
                    fontSize: textStyle.fontsize_34,
                    fontWeight: FontWeight.w600),
              )),
            ],
          ),
        ),
        body: _userFullInfo != null
            ? TencentCloudChatSettingBody(
                userFullInfo: _userFullInfo!,
                onLogOut: widget.onLogOut,
              )
            : Container(),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        color: colorTheme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: getHeight(11.4),
                      horizontal: getWidth(16),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: colorTheme.dividerColor,
                        ),
                      ),
                    ),
                    child: Text(
                      _title ?? tL10n.settings,
                      style: TextStyle(
                          color: colorTheme.settingTitleColor,
                          fontSize: textStyle.fontsize_24 + 4,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: getWidth(280)),
                    child: _userFullInfo != null
                        ? TencentCloudChatSettingBody(
                            userFullInfo: _userFullInfo!,
                            onLogOut: widget.onLogOut,
                            setWidget: (widget, title) {
                              setState(() {
                                _settingModule = widget;
                                _title = title;
                              });
                            },
                          )
                        : Container(),
                  ),
                  Expanded(
                    child: _settingModule ??
                        TencentCloudChatEmptyPage(
                          primaryText: tL10n.tencentCloudChat,
                          icon: Icons.settings,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
