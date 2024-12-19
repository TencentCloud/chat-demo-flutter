
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/commonUtils.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  final VoidCallback closeFunc;
  const AboutUs({Key? key, required this.closeFunc}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  String sdkVersion = "null";

  void getSDKVersion() async {
    final versionValue = await sdkInstance.getVersion();
    setState(() {
      sdkVersion = versionValue.data ?? "null";
    });
  }

  @override
  void initState() {
    getSDKVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    TextSpan webViewLink(String title, [String? url]) {
      return TextSpan(
        text: TIM_t(title),
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

    return Container(
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
                  webViewLink("官方网站",
                      "https://www.tencentcloud.com/products/im?from=pub"),
                  webViewLink("  |  "),
                  webViewLink("所有 SDK",
                      "https://pub.dev/publishers/comm.qq.com/packages"),
                  webViewLink("  |  "),
                  webViewLink("源代码",
                      "https://github.com/TencentCloud/chat-demo-flutter"),
                ])),
                const SizedBox(
                  height: 4,
                ),
                Text.rich(TextSpan(children: [
                  webViewLink("隐私政策",
                      "https://privacy.qq.com/document/preview/1cfe904fb7004b8ab1193a55857f7272"),
                  webViewLink("  |  "),
                  webViewLink("用户协议",
                      "https://web.sdk.qcloud.com/document/Tencent-IM-User-Agreement.html"),
                  webViewLink("  |  "),
                  webViewLink("信息收集清单",
                      "https://privacy.qq.com/document/preview/45ba982a1ce6493597a00f8c86b52a1e"),
                  webViewLink("  |  "),
                  webViewLink("信息共享清单",
                      "https://privacy.qq.com/document/preview/dea84ac4bb88454794928b77126e9246"),
                ])),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Copyright © 2013-2023 Tencent Cloud. All Rights Reserved. 腾讯云 版权所有",
                  style: TextStyle(color: theme.weakTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: CommonUtils.adaptWidth(100),
                child: const Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                TIM_t("腾讯云即时通信IM"),
                style: TextStyle(
                  color: theme.darkTextColor,
                  fontSize: CommonUtils.adaptFontSize(40),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TIM_t("SDK版本号"),
                    style: TextStyle(color: theme.weakTextColor),
                  ),
                  Text(
                    ": $sdkVersion",
                    style: TextStyle(color: theme.weakTextColor),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: 1,
                    height: 14,
                    child: Container(
                      color: theme.weakTextColor,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    TIM_t("应用版本号"),
                    style: TextStyle(color: theme.weakTextColor),
                  ),
                  Text(
                    ": ${IMDemoConfig.appVersion}",
                    style: TextStyle(color: theme.weakTextColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: (){
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    widget.closeFunc();
                    return AlertDialog(
                      title: Text(TIM_t("免责声明")),
                      content: Text(TIM_t(
                          "腾讯云IM APP（“本产品”）是由腾讯云提供的一款测试产品，腾讯云享有本产品的著作权和所有权。本产品仅用于功能体验，不得用于任何商业用途。严禁在使用中有任何色情、辱骂、暴恐、涉政等违法内容传播。")),
                      actions: <Widget>[
                        TextButton(
                          child: Text(TIM_t("取消")),
                          onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                        ),
                        TextButton(
                          child: Text(TIM_t("确定")),
                          onPressed: () {
                            //关闭对话框并返回true
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
              }, child: Text(TIM_t("免责声明"))),
              const SizedBox(
                height: 80,
              ),
            ],
          )
        ],
      ),
    );
  }
}
