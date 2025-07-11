import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_demo/src/provider/login_user_Info.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_type.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_group_member.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';

enum GroupTypeForUIKit { single, work, chat, meeting, public, community }

GlobalKey<_CreateGroup> createGroupKey = GlobalKey();

class CreateGroup extends StatefulWidget {
  final GroupTypeForUIKit convType;
  final ValueChanged<V2TimConversation>? directToChat;

  const CreateGroup({Key? key, required this.convType, this.directToChat})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateGroup();
}

class _CreateGroup extends State<CreateGroup> {
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  final MessageService _messageService = serviceLocator<MessageService>();
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  List<V2TimFriendInfo> friendList = [];
  List<V2TimFriendInfo> selectedFriendList = [];

  _getConversationList() async {
    final res = await _sdkInstance.getFriendshipManager().getFriendList();
    if (res.code == 0 && res.data != null) {
      friendList = res.data!;
      setState(() {});
    }
  }

  _createSingleConversation() async {
    final userID = selectedFriendList.first.userID;
    final conversationID = "c2c_$userID";
    final res = await _sdkInstance
        .getConversationManager()
        .getConversation(conversationID: conversationID);

    if (res.code == 0) {
      final V2TimConversation conversation = res.data ??
          V2TimConversation(
              conversationID: conversationID, userID: userID, type: 1);
      if (widget.directToChat != null) {
        widget.directToChat!(conversation);
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Chat(selectedConversation: conversation)));
      }
    }
  }

  _getShowName(V2TimFriendInfo item) {
    final friendRemark = item.friendRemark ?? "";
    final nickName = item.userProfile?.nickName ?? "";
    final userID = item.userID;
    final showName = nickName != "" ? nickName : userID;
    return friendRemark != "" ? friendRemark : showName;
  }

  bool _isValidGroupName(String groupName) {
    final List<int> bytes = utf8.encode(groupName);
    return !(bytes.length > 30);
  }

  String _generateGroupName() {
    String groupName =
        selectedFriendList.map((e) => _getShowName(e)).join(", ");
    if (_isValidGroupName(groupName)) {
      return groupName;
    }

    final option1 = selectedFriendList.length;
    groupName = _getShowName(selectedFriendList[0]) +
        TIM_t_para(" 等{{option1}}人", " 等$option1人")(option1: option1);
    if (_isValidGroupName(groupName)) {
      return groupName;
    }

    final option2 = selectedFriendList.length + 1;
    groupName = _getShowName(selectedFriendList[0]) +
        TIM_t_para("{{option2}}人群", "$option2人群")(option2: option2);
    if (_isValidGroupName(groupName)) {
      return groupName;
    }

    return TIM_t("新群聊");
  }

  _createGroup(String groupType) async {
    String groupName = _generateGroupName();
    final groupMember = selectedFriendList.map((e) {
      final role = e.userProfile!.role!;
      GroupMemberRoleTypeEnum roleEnum =
          GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_UNDEFINED;
      switch (role) {
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
          break;
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
          break;
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_OWNER;
          break;
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_UNDEFINED:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_UNDEFINED;
          break;
      }

      return V2TimGroupMember(role: roleEnum, userID: e.userID);
    }).toList();
    final res = await _sdkInstance.getGroupManager().createGroup(
        groupType: groupType,
        groupName: groupName,
        memberList: groupType != GroupType.AVChatRoom ? groupMember : null);
    if (res.code == 0) {
      final groupID = res.data;
      final conversationID = "group_$groupID";
      if (groupType == "AVChatRoom" && groupID != null) {
        await _sdkInstance.joinGroup(groupID: groupID, message: "Hi");
      }
      final convRes = await _sdkInstance
          .getConversationManager()
          .getConversation(conversationID: conversationID);
      if (convRes.code == 0) {
        await _sendMessageToNewlyCreatedGroup(groupType, groupID!);
        final conversation = convRes.data ??
            V2TimConversation(
                conversationID: conversationID,
                type: 2,
                showName: groupName,
                groupType: groupType,
                groupID: groupID);

        if (widget.directToChat != null) {
          widget.directToChat!(conversation);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Chat(selectedConversation: conversation)
              ),
              ModalRoute.withName("/homePage")
          );
        }
      }
    }
  }

  _sendMessageToNewlyCreatedGroup(String groupType, String groupID) async {
    final loginUserInfo = _coreInstance.loginUserInfo;
    V2TimMsgCreateInfoResult? res = await _messageService.createCustomMessage(
        data: json.encode(
            {"businessID": "group_create",
              "version": 4,
              "opUser": loginUserInfo?.nickName ?? loginUserInfo!.userID,
              "content": groupType == GroupType.Community ? "创建社群" : "创建群组",
              "cmd": groupType == GroupType.Community ? 1 : 0}));
    if (res != null) {
      final sendMsgRes = await _messageService.sendMessage(
          id: res.id!,
          groupID: groupID,
          receiver: '');
    }
  }

  @override
  void initState() {
    super.initState();
    _getConversationList();
  }

  void onSubmit() {
    if (selectedFriendList.isNotEmpty) {
      switch (widget.convType) {
        case GroupTypeForUIKit.single:
          _createSingleConversation();
          break;
        case GroupTypeForUIKit.chat:
          break;
        case GroupTypeForUIKit.community:
          _createGroup(GroupType.Community);
          break;
        case GroupTypeForUIKit.meeting:
          _createGroup(GroupType.Meeting);
          break;
        case GroupTypeForUIKit.work:
          _createGroup(GroupType.Work);
          break;
        case GroupTypeForUIKit.public:
          _createGroup(GroupType.Public);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    Widget chooseMembers() {
      return ContactList(
        bgColor: isWideScreen ? theme.wideBackgroundColor : null,
        contactList: friendList,
        isCanSelectMemberItem: true,
        maxSelectNum: widget.convType == GroupTypeForUIKit.single ? 1 : null,
        onSelectedMemberItemChange: (selectedMember) {
          selectedFriendList = selectedMember;
          setState(() {});
        },
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: chooseMembers(),
        ),
        defaultWidget: Scaffold(
          appBar: AppBar(
              title: Text(
                TIM_t("选择联系人"),
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              shadowColor: theme.weakDividerColor,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                    theme.primaryColor ?? CommonColor.primaryColor
                  ]),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: onSubmit,
                  child: Text(
                    TIM_t("确定"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
              iconTheme: const IconThemeData(
                color: Colors.white,
              )),
          body: chooseMembers(),
        ));
  }
}
