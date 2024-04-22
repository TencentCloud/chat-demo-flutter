import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_vote_plugin/components/vote_create/vote_create.dart';

class VoteCreateExample extends StatelessWidget {
  final String groupID;
  final TIMUIKitChatController controller;
  final Function onClosed;
  const VoteCreateExample({
    super.key,
    required this.groupID,
    required this.controller,
    required this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    var body = Container(
      padding: const EdgeInsets.all(16),
      child: TencentCloudChatVoteCreate(
        groupID: groupID,
        onCreateVoteSuccess: () {
          controller.loadHistoryMessageList(
            count: 20,
          );
          onClosed();
        },
      ),
    );
    return TUIKitScreenUtils.getDeviceWidget(
      context: context,
      desktopWidget: body,
      defaultWidget: Scaffold(
        appBar: AppBar(
          title: const Text("创建投票"),
        ),
        body: body,
      ),
    );
  }
}