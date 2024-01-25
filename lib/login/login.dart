import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends TencentCloudChatState<LoginPage> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        child: MoveWindow(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/icon.png"),
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    tL10n.tencentCloudChat,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Please specify `sdkappid`, `userid` and `usersig` in the `lib/config.dart` file before using this sample app.",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
