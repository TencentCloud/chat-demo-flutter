import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/extensions.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';
import 'package:tim_ui_kit_calling_plugin/model/calling_message.dart';
import 'package:tim_ui_kit_calling_plugin/view/callingMessageItemBuilder/call_message_item_builder.dart';
import 'package:tim_ui_kit_calling_plugin/view/callingMessageItemBuilder/group_call_message_item_builder.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/link_message.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/web_link_message.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMessageElem extends StatefulWidget {
  final TextStyle? messageFontStyle;
  final BorderRadius? messageBorderRadius;
  final Color? messageBackgroundColor;
  final EdgeInsetsGeometry? textPadding;
  final V2TimMessage message;
  final bool isShowJump;
  final VoidCallback? clearJump;

  const CustomMessageElem({
    Key? key,
    required this.message,
    required this.isShowJump,
    this.clearJump,
    this.messageFontStyle,
    this.messageBorderRadius,
    this.messageBackgroundColor,
    this.textPadding,
  }) : super(key: key);

  static Future<void> launchWebURL(BuildContext context, String url) async {
    try {
      await launchUrl(
        Uri.parse(url).withScheme,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TIM_t("无法打开URL"))), // Cannot launch the url
      );
    }
  }

  @override
  State<CustomMessageElem> createState() => _CustomMessageElemState();
}

class _CustomMessageElemState extends State<CustomMessageElem> {
  bool isShowJumpState = false;
  bool isShining = false;
  bool isShowBorder = false;

  _showJumpColor() {
    isShining = true;
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
      isShowBorder = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
          isShowBorder = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        isShining = false;
        timer.cancel();
      }
      shineAmount--;
    });
    if (widget.clearJump != null) {
      widget.clearJump!();
    }
  }

  Widget _callElemBuilder(BuildContext context, TUITheme theme) {
    final customElem = widget.message.customElem;
    final callingMessage = CallingMessage.getCallMessage(customElem);
    final linkMessage = getLinkMessage(customElem);
    final webLinkMessage = getWebLinkMessage(customElem);

    if (callingMessage != null) {
      if (widget.message.groupID != null) {
        // Group Call message
        return GroupCallMessageItem(customMessage: widget.message);
      } else {
        // One-to-one Call message
        return renderMessageItem(
            CallMessageItem(
                customElem: customElem,
                isFromSelf: widget.message.isSelf ?? true,
                padding: const EdgeInsets.all(0)),
            theme);
      }
    } else if (linkMessage != null) {
      final String option1 = linkMessage.link ?? "";
      return renderMessageItem(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(linkMessage.text ?? ""),
              MarkdownBody(
                data:
                    TIM_t_para("[查看详情 >>]({{option1}})", "[查看详情 >>]($option1)")(
                        option1: option1),
                styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                        textTheme: const TextTheme(
                            bodyText2: TextStyle(fontSize: 16.0))))
                    .copyWith(
                  a: TextStyle(color: LinkUtils.hexToColor("015fff")),
                ),
                onTapLink: (
                  String link,
                  String? href,
                  String title,
                ) {
                  LinkUtils.launchURL(context, linkMessage.link ?? "");
                },
              )
            ],
          ),
          theme);
    } else if (webLinkMessage != null) {
      return renderMessageItem(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(text: webLinkMessage.title),
                    TextSpan(
                      text: webLinkMessage.hyperlinks_text?["key"],
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 110, 253, 1),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          CustomMessageElem.launchWebURL(
                            context,
                            webLinkMessage.hyperlinks_text?["value"],
                          );
                        },
                    )
                  ])),
              if (webLinkMessage.description != null &&
                  webLinkMessage.description!.isNotEmpty)
                Text(
                  webLinkMessage.description!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
            ],
          ),
          theme);
    } else if (customElem?.data == "group_create") {
      return renderMessageItem(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TIM_t(("群聊创建成功！"))),
            ],
          ),
          theme);
    } else {
      return renderMessageItem(const Text("[自定义]"), theme);
    }
  }

  Widget renderMessageItem(Widget child, TUITheme theme) {
    final isFromSelf = widget.message.isSelf ?? true;
    final borderRadius = isFromSelf
        ? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10))
        : const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10));

    final defaultStyle = isFromSelf
        ? theme.lightPrimaryMaterialColor.shade50
        : theme.weakBackgroundColor;
    final backgroundColor =
        isShowJumpState ? const Color.fromRGBO(245, 166, 35, 1) : defaultStyle;

    return Container(
        padding: widget.textPadding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.messageBackgroundColor ?? backgroundColor,
          borderRadius: widget.messageBorderRadius ?? borderRadius,
        ),
        constraints: const BoxConstraints(maxWidth: 240),
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        if (widget.clearJump != null) {
          widget.clearJump!();
        }
      }
    }

    return _callElemBuilder(context, theme);
  }
}
