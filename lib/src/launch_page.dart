import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return Container(
      decoration: BoxDecoration(
        color: hexToColor("ecf3fe"),
      ),
      child: isWideScreen
          ? MoveWindow(
              child:  Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: theme.primaryColor ?? Colors.grey,
                  size: 50,
                ),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  // 因为底部有波浪图， icon向上一点，感觉视觉上更协调
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        color: theme.primaryColor ?? Colors.grey,
                        size: 76,
                      )
                    ],
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
    );
  }
}
