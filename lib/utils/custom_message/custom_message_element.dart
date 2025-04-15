import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/calling_message_data_provider.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/group_call_message_builder.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/single_call_message_builder.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/extensions.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';
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
  final TIMUIKitChatController chatController;

  const CustomMessageElem({
    Key? key,
    required this.message,
    required this.isShowJump,
    required this.chatController,
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

    final callingMessageDataProvider =
        CallingMessageDataProvider(widget.message);

    final linkMessage = getLinkMessage(customElem);
    final webLinkMessage = getWebLinkMessage(customElem);

    if (customElem?.data == "group_create") {
      return renderMessageItem(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TIM_t(("群聊创建成功！"))),
          ],
        ),
        theme,
        false,
      );
    } else if (MessageUtils.getCustomGroupCreatedOrDismissedString(
            widget.message)
        .isNotEmpty) {
      return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: MessageUtils.getCustomGroupCreatedOrDismissedString(
                  widget.message),
              style: TextStyle(color: theme.weakTextColor),
            ),
          ], style: const TextStyle(fontSize: 12))));
    } else if (linkMessage != null) {
      final String option1 = linkMessage.link ?? "";
      return renderMessageItem(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(linkMessage.text ?? ""),
            MarkdownBody(
              data: TIM_t_para("[查看详情 >>]({{option1}})", "[查看详情 >>]($option1)")(
                  option1: option1),
              styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                      textTheme: const TextTheme(
                          // ignore: deprecated_member_use
                          bodyMedium: TextStyle(fontSize: 16.0))))
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
        theme,
        false,
      );
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
        theme,
        false,
      );
    } else if (!callingMessageDataProvider.excludeFromHistory &&
        callingMessageDataProvider.isCallingSignal) {
      if (callingMessageDataProvider.participantType ==
          CallParticipantType.group) {
        // Group Call message
        return GroupCallMessageItem(
            callingMessageDataProvider: callingMessageDataProvider);
      } else {
        // One-to-one Call message
        return renderMessageItem(
          CallMessageItem(
              callingMessageDataProvider: callingMessageDataProvider,
              padding: const EdgeInsets.all(0)),
          theme,
          false,
        );
      }
    } else {
      return renderMessageItem(const Text("[自定义]"), theme, false);
    }
  }

  Widget renderMessageItem(Widget child, TUITheme theme, bool isVoteMessage) {
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
        padding: isVoteMessage
            ? null
            : (widget.textPadding ?? const EdgeInsets.all(10)),
        decoration: isVoteMessage
            ? BoxDecoration(
                border: Border.all(
                    width: 1, color: theme.weakDividerColor ?? Colors.grey))
            : BoxDecoration(
                color: widget.messageBackgroundColor ?? backgroundColor,
                borderRadius: widget.messageBorderRadius ?? borderRadius,
              ),
        constraints: BoxConstraints(
            maxWidth:
                isVoteMessage ? 298 : 240), // vote message width need more
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
