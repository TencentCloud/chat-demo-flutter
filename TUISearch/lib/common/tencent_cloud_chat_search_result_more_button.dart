import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';

class TencentCloudChatSearchResultMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TencentCloudChatSearchResultMoreButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tL10n.more,
                        style: TextStyle(fontSize: 14.0, color: colorTheme.secondaryTextColor),
                      ),
                      const SizedBox(width: 4.0),
                      Icon(
                        Icons.keyboard_double_arrow_down_rounded,
                        size: 20.0,
                        color: colorTheme.secondaryTextColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
