import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

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
  CaptchaStatus captchaStatus = CaptchaStatus.unReady;

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
            child: WebView(
              initialUrl: IMDemoConfig.captchaUrl,
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: {
                JavascriptChannel(
                    name: 'onLoading',
                    onMessageReceived: (JavascriptMessage message) {
                      // 防水墙loading
                      setState(() {
                        captchaStatus = CaptchaStatus.loading;
                      });
                    }),
                JavascriptChannel(
                    name: 'onCaptchaReady',
                    onMessageReceived: (JavascriptMessage message) {
                      // 防水墙ready
                      setState(() {
                        captchaStatus = CaptchaStatus.ready;
                      });
                    }),
                JavascriptChannel(
                    name: 'messageHandler',
                    onMessageReceived: (JavascriptMessage message) {
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
                    }),
                JavascriptChannel(
                    name: 'capClose',
                    onMessageReceived: (JavascriptMessage message) {
                      setState(() {
                        captchaStatus = CaptchaStatus.unReady;
                      });
                      widget.onClose();
                    })
              },
            ),
          ),
        ));
  }
}
