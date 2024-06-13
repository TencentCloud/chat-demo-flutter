import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_message_common_defines.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/builders/tencent_cloud_chat_common_builders.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
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
                TencentCloudChatMessageGeneralOptionItem(
                    label: tL10n.me,
                    onTap: ({Offset? offset}) async {
                      desktopAppLayoutKey.currentState?.navigateToSettings();
                    }),
                TencentCloudChatMessageGeneralOptionItem(
                    label: tL10n.about,
                    onTap: ({Offset? offset}) {
                      TencentCloudChatDesktopPopup.showPopupWindow(
                        title: tL10n.aboutTencentCloudChat,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.6,
                        operationKey: TencentCloudChatPopupOperationKey.custom,
                        context: context,
                        child: (closeFunc) => DesktopAboutUs(closeFunc: closeFunc),
                      );
                    }),
                TencentCloudChatMessageGeneralOptionItem(
                    label: tL10n.contactUs,
                    onTap: ({Offset? offset}) {
                      TencentCloudChatDesktopPopup.showPopupWindow(
                        title: tL10n.contactUs,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.6,
                        operationKey: TencentCloudChatPopupOperationKey.custom,
                        context: context,
                        child: (closeFunc) => DesktopContactUs(closeFunc: closeFunc),
                      );
                    }),
                TencentCloudChatMessageGeneralOptionItem(
                    label: tL10n.settings,
                    onTap: ({Offset? offset}) {
                      desktopAppLayoutKey.currentState?.navigateToSettings();
                    }),
                TencentCloudChatMessageGeneralOptionItem(
                    label: tL10n.feedback,
                    onTap: ({Offset? offset}) {
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
                  TencentCloudChatUtils.checkString(TencentCloudChat.instance.dataInstance.basic.currentUser?.faceUrl),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
