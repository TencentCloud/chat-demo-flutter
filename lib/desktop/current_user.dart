import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_column_menu/tencent_cloud_chat_column_menu.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_demo/desktop/app_layout.dart';
import 'package:tencent_cloud_chat_demo/desktop/tencent_specific/about_us.dart';
import 'package:tencent_cloud_chat_demo/desktop/tencent_specific/contact_us.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentUserAvatar extends StatefulWidget {
  const CurrentUserAvatar({
    Key? key,
  }) : super(key: key);

  @override
  State<CurrentUserAvatar> createState() => _CurrentUserAvatarState();
}

class _CurrentUserAvatarState extends State<CurrentUserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (details) {
            TencentCloudChatDesktopPopup.showColumnMenu(
              context: context,
              offset: Offset(details.globalPosition.dx + 10, details.globalPosition.dy - 180),
              items: [
                ColumnMenuItem(
                    label: tL10n.me,
                    onClick: () async {
                      desktopAppLayoutKey.currentState?.navigateToSettings();
                    }),
                ColumnMenuItem(
                    label: tL10n.about,
                    onClick: () {
                      TencentCloudChatDesktopPopup.showPopupWindow(
                        title: tL10n.aboutTencentCloudChat,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.6,
                        operationKey: TencentCloudChatPopupOperationKey.custom,
                        context: context,
                        child: (closeFunc) => DesktopAboutUs(closeFunc: closeFunc),
                      );
                    }),
                ColumnMenuItem(
                    label: tL10n.contactUs,
                    onClick: () {
                      TencentCloudChatDesktopPopup.showPopupWindow(
                        title: tL10n.contactUs,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.6,
                        operationKey: TencentCloudChatPopupOperationKey.custom,
                        context: context,
                        child: (closeFunc) => DesktopContactUs(closeFunc: closeFunc),
                      );
                    }),
                ColumnMenuItem(
                    label: tL10n.settings,
                    onClick: () {
                      desktopAppLayoutKey.currentState?.navigateToSettings();
                    }),
                ColumnMenuItem(
                    label: tL10n.feedback,
                    onClick: () {
                      launchUrl(
                        Uri.parse("https://wj.qq.com/s2/11858997/6b56/"),
                        mode: LaunchMode.externalApplication,
                      );
                    }),
              ],
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, top: 40),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: TencentCloudChatCommonBuilders.getCommonAvatarBuilder(
                scene: TencentCloudChatAvatarScene.custom,
                width: 36,
                height: 36,
                imageList: [
                  TencentCloudChatUtils.checkString(TencentCloudChat.dataInstance.basic.currentUser?.faceUrl) ?? "https://comm.qq.com/im/static-files/im-demo/im_virtual_customer.png",
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
