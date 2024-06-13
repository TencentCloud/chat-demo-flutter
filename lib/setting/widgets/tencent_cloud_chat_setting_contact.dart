import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class TencentCloudChatSettingContact extends StatefulWidget {

  const TencentCloudChatSettingContact({super.key});

  @override
  State<TencentCloudChatSettingContact> createState() => _TencentCloudChatSettingContactState();
}

class _TencentCloudChatSettingContactState extends State<TencentCloudChatSettingContact> {
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
    String languageType = (languageCode == 'zh' && (TencentCloudChatUtils.checkString(scriptCode) != null ? scriptCode!.toLowerCase() == "hans" : true) && (TencentCloudChatUtils.checkString(currentLocale.countryCode) != null ? currentLocale.countryCode!.toLowerCase() == "cn" : true)) ? 'zh' : 'other';
    setState(() {
      isInternational = (languageType == "zh") ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                elevation: 1,
                title: Text(
                  tL10n.contactUs,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
                backgroundColor: colorTheme.loginBackgroundColor,
                leading: IconButton(
                  padding: const EdgeInsets.only(left: 16),
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.white,
                  // 返回Home事件
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0xFFecf3fe),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      // 因为底部有波浪图， icon向上一点，感觉视觉上更协调
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "欢迎前往知聊社区参与讨论",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 100),
                            child: const SelectableText(
                              "zhiliao.qq.com",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Text(
                            "此社区使用本 App 同款 Flutter UIKit 完成全平台开发",
                            style: TextStyle(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                if (isInternational) {
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
                              child: Text(tL10n.contactUs),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
