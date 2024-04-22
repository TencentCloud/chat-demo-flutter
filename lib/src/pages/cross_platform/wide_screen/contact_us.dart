
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  final VoidCallback closeFunc;

  const ContactUs({Key? key, required this.closeFunc}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool isInternational = true;

  @override
  void initState() {
    super.initState();
    setLanguage();
  }

  void setLanguage(){
    final String? deviceLocale = WidgetsBinding.instance.window.locale.toLanguageTag();
    final AppLocale appLocale = I18nUtils.findDeviceLocale(deviceLocale);
    String languageType =
    (appLocale == AppLocale.zhHans || appLocale == AppLocale.zhHant)
        ? 'zh'
        : 'other';
    setState(() {
      isInternational = (languageType == "zh") ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [Text(TIM_t("渠道切换："),style: TextStyle(fontSize: 18, color: theme.darkTextColor),),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isInternational = !isInternational;
                    });
                  },
                  child: Text(isInternational ? TIM_t("中国大陆") : TIM_t("国际"))),],
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TIM_t("如果您在使用过程中有任何疑问，请通过如下渠道联系我们"),
                style: TextStyle(color: theme.weakTextColor),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                          isInternational
                              ? "assets/telegram.png"
                              : "assets/wechat_qr.png",
                          height: isInternational ? 80 : 150),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isInternational)
                        const Text(
                          "Telegram",
                          style: TextStyle(fontSize: 16),
                        ),
                      if (!isInternational)
                        Image.asset("assets/wechat.png", height: 30),
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
                            child: Text(TIM_t("立即进群"))),
                    ],
                  ),
                  const SizedBox(
                    width: 140,
                  ),
                  Column(
                    children: [
                      Image.asset(
                          isInternational
                              ? "assets/whatsapp.png"
                              : "assets/qq_qr.png",
                          height: isInternational ? 80 : 150),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isInternational)
                        const Text(
                          "WhatsApp",
                          style: TextStyle(fontSize: 16),
                        ),
                      if (!isInternational)
                        Image.asset("assets/qq.png", height: 35),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isInternational)
                        ElevatedButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    "https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(TIM_t("立即进群"))),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: isInternational ? 20 : 0,
              ),
              Text(
                TIM_t("在线时间: 周一到周五，早上10点 - 晚上8点"),
                style: TextStyle(color: theme.weakTextColor),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
