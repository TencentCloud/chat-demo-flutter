import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_settings_info.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_settings_tab.dart';

class TencentCloudChatSettingBody extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;
  final VoidCallback onLogOut;
  final Function(Widget widget, String title)? setWidget;

  const TencentCloudChatSettingBody(
      {super.key,
      required this.userFullInfo,
      required this.onLogOut,
      this.setWidget});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingBodyState();
}

class TencentCloudChatSettingBodyState
    extends TencentCloudChatState<TencentCloudChatSettingBody> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        color: colorTheme.settingBackgroundColor,
        child: Column(
          children: [
            TencentCloudChatSettingsInfo(
              userFullInfo: widget.userFullInfo,
              setWidget: widget.setWidget,
            ),
            TencentCloudChatSettingsTab(
              userFullInfo: widget.userFullInfo,
              onLogOut: widget.onLogOut,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        decoration: BoxDecoration(
          color: colorTheme.settingBackgroundColor,
          border: Border(
            right: BorderSide(
              width: 1,
              color: colorTheme.dividerColor,
            ),
          ),
        ),
        child: Column(
          children: [
            TencentCloudChatSettingsInfo(
              userFullInfo: widget.userFullInfo,
              setWidget: widget.setWidget,
            ),
            TencentCloudChatSettingsTab(
              userFullInfo: widget.userFullInfo,
              onLogOut: widget.onLogOut,
              setWidget: widget.setWidget,
            )
          ],
        ),
      ),
    );
  }
}
