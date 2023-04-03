import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/calling_message.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class CallMessageItem extends StatelessWidget {
  final V2TimCustomElem? customElem;
  final bool isFromSelf;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isShowIcon;

  const CallMessageItem({
    Key? key,
    this.customElem,
    this.isFromSelf = false,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.isShowIcon = true,
  }) : super(key: key);

  Widget _callElemBuilder(BuildContext context) {
    final callingMessage = CallingMessage.getCallMessage(customElem);

    if (callingMessage != null) {
      // 如果是结束消息
      final isCallEnd = CallingMessage.isCallEndExist(callingMessage);

      final isVoiceCall = callingMessage.callType == 1;

      String? callTime = "";
      if (isCallEnd) {
        callTime = CallingMessage.getShowTime(callingMessage.callEnd!);
      }

      final option1 = callTime;

      if (!isShowIcon) {
        return isCallEnd
            ? Text(TIM_t_para("通话时间：{{option1}}", "通话时间：$option1")(option1: option1))
            : Text(CallingMessage.getActionType(callingMessage.actionType!));
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFromSelf)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Image.asset(
                isVoiceCall ? "assets/calling_message/voice_call.png" : "assets/calling_message/video_call.png",
                height: 16,
                width: 16,
              ),
            ),
          isCallEnd
              ? Text(TIM_t_para("通话时间：{{option1}}", "通话时间：$option1")(option1: option1))
              : Text(CallingMessage.getActionType(callingMessage.actionType!)),
          if (isFromSelf)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Image.asset(
                isVoiceCall
                    ? "assets/calling_message/voice_call.png"
                    : "assets/calling_message/video_call_self.png",
                height: 16,
                width: 16,
              ),
            ),
        ],
      );
    } else {
      return Text(TIM_t("[自定义]"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadiusDefault = isFromSelf
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
    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? borderRadiusDefault,
      ),
      constraints: const BoxConstraints(maxWidth: 240),
      child: _callElemBuilder(context),
    );
  }
}