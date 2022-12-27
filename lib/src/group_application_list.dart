// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroup/tim_uikit_group_application_list.dart';

import 'package:timuikit/src/provider/theme.dart';
import 'package:provider/provider.dart';

class GroupApplicationList extends StatelessWidget{
  /// group ID
  final String groupID;

  const GroupApplicationList({Key? key, required this.groupID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: Text(
          TIM_t("进群申请列表"),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      body: TIMUIKitGroupApplicationList(groupID: groupID),
    );
  }

}