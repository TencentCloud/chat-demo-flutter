import 'dart:convert';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';

typedef WebEvent = void Function(String name, dynamic body);

class TIMWebView extends StatefulWidget {
  final String initialUrl;
  final double? width;
  final double? height;
  final WebEvent webEventHandler;

  const TIMWebView(
      {Key? key,
      required this.initialUrl,
      this.width,
      this.height,
      required this.webEventHandler})
      : super(key: key);

  @override
  State<TIMWebView> createState() => _TIMWebViewState();
}

class _TIMWebViewState extends State<TIMWebView> {

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  initWebView() async {
    final String documentsDirectoryPath =
        "${Platform.environment['USERPROFILE']}";
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String pkgName = packageInfo.packageName;
    final webviewPath = p.join(documentsDirectoryPath, "Documents", ".TencentCloudChat",
        pkgName, "webview");

    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        userDataFolderWindows: webviewPath,
        windowHeight: 360,
        windowWidth: 360,
        title: "Tencent Verify",
      ),
    );
    webview.registerJavaScriptMessageHandler("onLoading", (name, body) {
      widget.webEventHandler("onLoading", "");
    });
    webview.registerJavaScriptMessageHandler("onCaptchaReady", (name, body) {
      var messageObj = jsonDecode(body);
      widget.webEventHandler("onCaptchaReady", messageObj);
    });
    webview.registerJavaScriptMessageHandler("messageHandler", (name, body) {
      try {
        var messageObj = jsonDecode(body);
        widget.webEventHandler(name, messageObj);
      } catch (e) {
        ToastUtils.toast(TIM_t("图片验证码校验失败"));
      }
      webview.close();
    });
    webview.registerJavaScriptMessageHandler("capClose", (name, body) {
      webview.close();
      widget.webEventHandler("capClose", "");
    });
    webview.onClose.whenComplete(() {
      widget.webEventHandler("capClose", "");
    });
    webview.addOnWebMessageReceivedCallback((message) {
      try {
        var messageObj = jsonDecode(message);
        widget.webEventHandler(messageObj["operation"], messageObj);
        if (messageObj["operation"] == "capClose" ||
            messageObj["operation"] == "messageHandler") {
          webview.close();
        }
      } catch (e) {
        ToastUtils.toast(TIM_t("图片验证码校验失败"));
      }
    });
    webview.launch(widget.initialUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
