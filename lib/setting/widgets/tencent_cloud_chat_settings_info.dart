import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_settings_set_info.dart';

class TencentCloudChatSettingsInfo extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;
  final Function(Widget widget, String title)? setWidget;

  const TencentCloudChatSettingsInfo({super.key, required this.userFullInfo, this.setWidget});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsInfoState();
}

class TencentCloudChatSettingsInfoState extends TencentCloudChatState<TencentCloudChatSettingsInfo> {
  navigateToSetInfo() {
    if (widget.setWidget != null) {
      widget.setWidget!(
          TencentCloudChatSettingsSetInfo(
            userFullInfo: widget.userFullInfo,
          ),
          tL10n.profile);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TencentCloudChatSettingsSetInfo(
                  userFullInfo: widget.userFullInfo,
                )),
      );
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(30), vertical: getHeight(10)),
        color: colorTheme.settingTabBackgroundColor,
        child: GestureDetector(
          onTap: navigateToSetInfo,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TencentCloudChatSettingsInfoAvatar(userFullInfo: widget.userFullInfo),
              SizedBox(
                width: getWidth(8),
              ),
              TencentCloudChatSettingsInfoContent(
                userFullInfo: widget.userFullInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(16)),
        color: colorTheme.settingTabBackgroundColor,
        child: InkWell(
          onTap: navigateToSetInfo,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TencentCloudChatSettingsInfoAvatar(userFullInfo: widget.userFullInfo),
              SizedBox(
                width: getWidth(8),
              ),
              TencentCloudChatSettingsInfoContent(
                userFullInfo: widget.userFullInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatSettingsInfoAvatar extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingsInfoAvatar({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsInfoAvatarState();
}

class TencentCloudChatSettingsInfoAvatarState extends TencentCloudChatState<TencentCloudChatSettingsInfoAvatar> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatAvatar(
      scene: TencentCloudChatAvatarScene.custom,
      imageList: [widget.userFullInfo.faceUrl],
      width: getSquareSize(66),
      height: getSquareSize(66),
      borderRadius: getSquareSize(66),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatAvatar(
      scene: TencentCloudChatAvatarScene.custom,
      imageList: [widget.userFullInfo.faceUrl],
      width: getSquareSize(48),
      height: getSquareSize(48),
      borderRadius: getSquareSize(48),
    );
  }
}

class TencentCloudChatSettingsInfoContent extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingsInfoContent({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsInfoContentState();
}

class TencentCloudChatSettingsInfoContentState extends TencentCloudChatState<TencentCloudChatSettingsInfoContent> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.userFullInfo.nickName ?? widget.userFullInfo.userID ?? "",
              style: TextStyle(fontSize: textStyle.fontsize_24, fontWeight: FontWeight.w500, color: colorTheme.settingTitleColor),
            ),
            Text(
              'ID: ${widget.userFullInfo.userID}',
              style: TextStyle(fontSize: textStyle.fontsize_12, fontWeight: FontWeight.w400, color: colorTheme.settingTitleColor),
            ),
            if (TencentCloudChatUtils.checkString(widget.userFullInfo.selfSignature ?? "") != null)
              Text(
                widget.userFullInfo.selfSignature ?? "",
                style: TextStyle(fontSize: textStyle.fontsize_12, fontWeight: FontWeight.w400, color: colorTheme.settingTitleColor),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.userFullInfo.nickName ?? widget.userFullInfo.userID ?? "",
              style: TextStyle(fontSize: textStyle.fontsize_18, color: colorTheme.primaryTextColor),
            ),
            Text(
              'ID: ${widget.userFullInfo.userID}',
              style: TextStyle(fontSize: textStyle.fontsize_12, color: colorTheme.secondaryTextColor),
            ),
            if (TencentCloudChatUtils.checkString(widget.userFullInfo.selfSignature ?? "") != null)
              Text(
                widget.userFullInfo.selfSignature ?? "",
                style: TextStyle(fontSize: textStyle.fontsize_12, color: colorTheme.secondaryTextColor),
              )
          ],
        ),
      ),
    );
  }
}
