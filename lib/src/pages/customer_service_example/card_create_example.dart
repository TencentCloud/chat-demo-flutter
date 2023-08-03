// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
// import 'package:tencent_cloud_chat_customer_service_plugin/tencent_cloud_chat_customer_service_plugin.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class CardCreateExample extends StatefulWidget {
  final TIMUIKitChatController controller;
  final Function onClosed;
  const CardCreateExample(
      {super.key, required this.controller, required this.onClosed});

  @override
  State<StatefulWidget> createState() => _CardCreateExampleState();
}

class _CardCreateExampleState extends State<CardCreateExample> {
  @override
  Widget build(BuildContext context) {
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    return Container();
    // return isWideScreen
    //     ? Container(
    //         padding: const EdgeInsets.all(16),
    //         child: TencentCloudChatCardCreate(
    //           onClosed: widget.onClosed,
    //           onSendCard: widget.controller.sendMessage,
    //           isWide: true,
    //         ),
    //       )
    //     : TencentCloudChatCardCreate(
    //         onClosed: widget.onClosed,
    //         onSendCard: widget.controller.sendMessage,
    //         isWide: false,
    //       );
  }
}
