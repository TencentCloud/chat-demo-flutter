import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DesktopContactUs extends StatefulWidget {
  final VoidCallback closeFunc;

  const DesktopContactUs({Key? key, required this.closeFunc}) : super(key: key);

  @override
  State<DesktopContactUs> createState() => _DesktopContactUsState();
}

class _DesktopContactUsState extends TencentCloudChatState<DesktopContactUs> {
  bool isInternational = true;

  @override
  void initState() {
    super.initState();
    setLanguage();
  }

  void setLanguage() {
    final Locale currentLocale = TencentCloudChatIntl().getCurrentLocale(context);
    final String languageCode = currentLocale.languageCode;
    final String? scriptCode = currentLocale.scriptCode;
    String languageType = (languageCode == 'zh' && (TencentCloudChatUtils.checkString(scriptCode) != null ? scriptCode == "Hans" : true)) ? 'zh' : 'other';
    setState(() {
      isInternational = (languageType == "zh") ? false : true;
    });
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  tL10n.channelSwitch,
                  style: TextStyle(fontSize: 18, color: colorTheme.primaryTextColor),
                ),
                SizedBox(width: 8,),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isInternational = !isInternational;
                      });
                    },
                    child: Text(isInternational ? tL10n.weChat : tL10n.tGWA)),
              ],
            ),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tL10n.contactUsIfQuestions,
                  style: TextStyle(color: colorTheme.secondaryTextColor),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(isInternational ? "assets/telegram.png" : "assets/wechat_qr.png", height: isInternational ? 80 : 150),
                        const SizedBox(
                          height: 20,
                        ),
                        if (isInternational)
                          const Text(
                            "Telegram",
                            style: TextStyle(fontSize: 16),
                          ),
                        if (!isInternational) Image.asset("assets/wechat.png", height: 30),
                        const SizedBox(
                          height: 20,
                        ),
                        if (isInternational)
                          ElevatedButton(
                              onPressed: () {
                                launchUrl(
                                  Uri.parse("https://t.me/+1doS9AUBmndhNGNl"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Text(tL10n.chatNow)),
                      ],
                    ),
                    if (isInternational)
                      const SizedBox(
                        width: 140,
                      ),
                    if (isInternational)
                      Column(
                        children: [
                          Image.asset(isInternational ? "assets/whatsapp.png" : "assets/qq_qr.png", height: isInternational ? 80 : 150),
                          const SizedBox(
                            height: 20,
                          ),
                          if (isInternational)
                            const Text(
                              "WhatsApp",
                              style: TextStyle(fontSize: 16),
                            ),
                          if (!isInternational) Image.asset("assets/qq.png", height: 35),
                          const SizedBox(
                            height: 20,
                          ),
                          if (isInternational)
                            ElevatedButton(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse("https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                child: Text(tL10n.chatNow)),
                        ],
                      )
                  ],
                ),
                SizedBox(
                  height: isInternational ? 20 : 0,
                ),
                Text(
                  tL10n.onlineServiceTimeFrom10To20,
                  style: TextStyle(color: colorTheme.secondaryTextColor),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
