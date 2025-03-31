import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:url_launcher/url_launcher.dart';

class DesktopAboutUs extends StatefulWidget {
  final VoidCallback closeFunc;

  const DesktopAboutUs({Key? key, required this.closeFunc}) : super(key: key);

  @override
  State<DesktopAboutUs> createState() => _DesktopAboutUsState();
}

class _DesktopAboutUsState extends TencentCloudChatState<DesktopAboutUs> {
  final V2TIMManager sdkInstance = TencentImSDKPlugin.v2TIMManager;
  String sdkVersion = TencentCloudChat.instance.dataInstance.basic.version;

  @override
  Widget defaultBuilder(BuildContext context) {
    final locale = TencentCloudChatIntl().getCurrentLocale(context);
    final isChinese = locale.languageCode == "zh";

    TextSpan webViewLink(String title, [String? url]) {
      return TextSpan(
        text: title,
        style: const TextStyle(
          fontSize: 12,
          color: Color.fromRGBO(0, 110, 253, 1),
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (url != null) {
              launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            }
          },
      );
    }

    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(TextSpan(children: [
                    webViewLink(tL10n.officialWebsite,
                        "https://trtc.io/products/chat?utm_source=flutter_demo&utm_medium=link&utm_campaign=%E6%B8%A0%E9%81%93&_channel_track_key=k6WgfCKn"),
                    webViewLink("  |  "),
                    webViewLink(tL10n.allSDKs, "https://pub.dev/publishers/comm.qq.com/packages"),
                    webViewLink("  |  "),
                    webViewLink(tL10n.sourceCode, "https://github.com/TencentCloud/chat-demo-flutter/tree/v2"),
                  ])),
                  const SizedBox(
                    height: 4,
                  ),
                  if (isChinese)
                    Text.rich(TextSpan(children: [
                      if (isChinese) webViewLink("ICP备案号: 粤B2-20090059-2674A", "https://beian.miit.gov.cn"),
                    ])),
                  if (isChinese)
                    const SizedBox(
                      height: 4,
                    ),
                  Text.rich(TextSpan(children: [
                    webViewLink(tL10n.privacyPolicy,
                        "https://privacy.qq.com/document/preview/1cfe904fb7004b8ab1193a55857f7272"),
                    webViewLink("  |  "),
                    webViewLink(
                        tL10n.userAgreement, "https://web.sdk.qcloud.com/document/Tencent-IM-User-Agreement.html"),
                    webViewLink("  |  "),
                    webViewLink(tL10n.personalInformationCollectionList,
                        "https://privacy.qq.com/document/preview/45ba982a1ce6493597a00f8c86b52a1e"),
                    webViewLink("  |  "),
                    webViewLink(tL10n.thirdPartyInformationSharingList,
                        "https://privacy.qq.com/document/preview/dea84ac4bb88454794928b77126e9246"),
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Copyright © 2013-2024 Tencent Cloud. All Rights Reserved. 腾讯云 版权所有",
                    style: TextStyle(color: colorTheme.secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getHeight(40),
                      child: const Image(
                        image: AssetImage("assets/trtc.png"),
                      ),
                    ),
                    Container(
                      height: getHeight(40),
                      width: getWidth(1),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: colorTheme.secondaryTextColor.withOpacity(0.4),
                    ),
                    SizedBox(
                      height: getHeight(40),
                      child: const Image(
                        image: AssetImage("assets/trtcchat.png"),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      "Chat",
                      style: TextStyle(color: colorTheme.secondaryTextColor,fontSize: textStyle.fontsize_20),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tL10n.sdkVersion,
                      style: TextStyle(color: colorTheme.secondaryTextColor),
                    ),
                    Text(
                      ": $sdkVersion",
                      style: TextStyle(color: colorTheme.secondaryTextColor),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      width: 1,
                      height: 14,
                      child: Container(
                        color: colorTheme.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      tL10n.version,
                      style: TextStyle(color: colorTheme.secondaryTextColor),
                    ),
                    Text(
                      ": ${IMConfig.appVersion}",
                      style: TextStyle(color: colorTheme.secondaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      TencentCloudChatDialog.showAdaptiveDialog(
                        context: context,
                        title: Text(tL10n.disclaimer),
                        content: const Text(
                            "Tencent Cloud Chat APP ('this product') is a sample app provided by Tencent Cloud. Tencent Cloud owns the copyright and ownership of this product. This product is for functional experience only and may not be used for any commercial purposes. It is strictly prohibited to spread any pornographic, abusive, violent, terrorist, political-related and other illegal content during use."),
                        actions: <Widget>[
                          TextButton(
                            child: Text(tL10n.cancel),
                            onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                          ),
                          TextButton(
                            child: Text(tL10n.confirm),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                    child: Text(tL10n.disclaimer)),
                const SizedBox(
                  height: 80,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
