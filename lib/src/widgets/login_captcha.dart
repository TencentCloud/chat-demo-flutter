import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum CaptchaStatus { unReady, loading, ready }

class LoginCaptcha extends StatefulWidget {
  const LoginCaptcha({Key? key, required this.onSuccess, required this.onClose})
      : super(key: key);
  final void Function(dynamic obj) onSuccess;
  final void Function() onClose;

  @override
  _LoginCaptchaState createState() => _LoginCaptchaState();
}

class _LoginCaptchaState extends State<LoginCaptcha> {
  late final WebViewController controller;
  CaptchaStatus captchaStatus = CaptchaStatus.unReady;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('messageHandler',
          onMessageReceived: (JavaScriptMessage message) {
            try {
              var messageObj = jsonDecode(message.message);
              widget.onSuccess(messageObj);
            } catch (e) {
              ToastUtils.toast(TIM_t("图片验证码校验失败"));
            }
            setState(() {
              captchaStatus = CaptchaStatus.unReady;
            });
            widget.onClose();
          })
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => setState(() {
          captchaStatus = CaptchaStatus.loading;
        }),
        onProgress: (progress) {
          setState(() {
            captchaStatus = CaptchaStatus.loading;
          });
        },
        onPageFinished: (url) {
          setState(() {
            captchaStatus = CaptchaStatus.ready;
          });
        },
        onWebResourceError: (error) {
          setState(() {
            captchaStatus = CaptchaStatus.unReady;
          });
        },
      ))
      ..loadRequest(Uri.parse(IMDemoConfig.captchaUrl));
  }

  double getSize() {
    switch (captchaStatus) {
      case CaptchaStatus.unReady:
        return 260;
      case CaptchaStatus.loading:
        return 130;
      case CaptchaStatus.ready:
        return 260;
    }
  }

  @override
  build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Center(
          child: SizedBox(
            width: getSize(),
            height: getSize(),
            child: WebViewWidget(controller: controller),
          ),
        ));
  }

  @override
  void dispose() {
    controller.clearCache();
    super.dispose();
  }
}
