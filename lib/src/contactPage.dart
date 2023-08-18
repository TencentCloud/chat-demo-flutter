// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';


import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          shadowColor: theme.weakDividerColor,
          elevation: 1,
          title: Text(
            TIM_t("联系我们"),
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                theme.primaryColor ?? CommonColor.primaryColor
              ]),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: hexToColor("ecf3fe"),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                // 因为底部有波浪图， icon向上一点，感觉视觉上更协调
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Text(
                      TIM_t("欢迎前往知聊社区参与讨论"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.darkTextColor,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 100),
                      child: SelectableText(
                        TIM_t("zhiliao.qq.com"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor),
                      ),
                    ),
                    Text(
                      TIM_t("此社区使用本 App 同款 Flutter UIKit 完成全平台开发"),
                      style: TextStyle(
                        color: theme.darkTextColor,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if(isInternational){
                            launchUrl(
                              Uri.parse("https://t.me/+1doS9AUBmndhNGNl"),
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            launchUrl(
                              Uri.parse("https://zhiliao.qq.com/s/c5GY7HIM62CK/c6RDBIIM62CQ"),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: Text(TIM_t("前往知聊社区")),
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  "assets/logo_bottom.png",
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                ),
              )
            ],
          ),
        ),
    );
  }
}
