import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/calling_message.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class GroupCallMessageItem extends StatefulWidget {
  final V2TimMessage? customMessage;

  const GroupCallMessageItem({
    Key? key,
    this.customMessage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupCallMessageItemState();
}

class _GroupCallMessageItemState extends State<GroupCallMessageItem> {

  // CustomMessage最终展示的内容
  String customMessageShowText = TIM_t("[自定义]");

  @override
  void initState() {
    super.initState();
    final customElem = widget.customMessage?.customElem;
    final groupId = widget.customMessage?.groupID;
    final callingMessage = CallingMessage.getCallMessage(customElem);
    getShowActionType(callingMessage!, groupId: groupId);
  }

  String getShowName(V2TimGroupMemberFullInfo info) {
    if (info.friendRemark != null && info.friendRemark!.isNotEmpty) {
      return info.friendRemark!;
    } else if (info.nickName != null && info.nickName!.isNotEmpty) {
      return info.nickName!;
    } else if (info.nameCard != null && info.nameCard!.isNotEmpty) {
      return info.nameCard!;
    } else {
      return info.userID;
    }
  }

  getShowNameListFromGroupList(
      List<String> inviteList, List<V2TimGroupMemberFullInfo?> groupInfoList) {
    final showNameList = [];
    for (var info in groupInfoList) {
      final isContains = inviteList.contains(info!.userID);
      if (isContains) {
        showNameList.add(getShowName(info));
      }
    }

    return showNameList;
  }

// 先更新为userID的封装
  handleShowUserIDFromInviteList(
      List<String> inviteeList, String actionTypeText) {
    String nameStr = "";
    for (String showName in inviteeList) {
      nameStr = "$nameStr、$showName";
    }
    nameStr = nameStr.substring(1);
    setState(() {
      customMessageShowText = "$nameStr $actionTypeText";
    });
  }

  // 后更新showName的封装
  handleShowNameStringFromList(
      List<dynamic> showNameList, String actionTypeText) {
    if (showNameList.isEmpty) {
      return;
    }
    if (mounted) {
      if (showNameList.length == 1) {
        setState(() {
          customMessageShowText = "${showNameList[0]} $actionTypeText";
        });
      } else {
        String nameStr = "";
        for (String showName in showNameList) {
          nameStr = "$nameStr、$showName";
        }
        nameStr = nameStr.substring(1);
        setState(() {
          customMessageShowText = "$nameStr $actionTypeText";
        });
      }
    }
  }

  // 封装需要节流获取情况用户成员的情况
  handleThrottleGetShowName(
      String groupId, String actionTypeText, CallingMessage callingMessage) {
    handleShowUserIDFromInviteList(callingMessage.inviteeList!, actionTypeText);
  }

  getShowActionType(CallingMessage callingMessage, {String? groupId}) async {
    final actionType = callingMessage.actionType!;
    final actionTypeText = CallingMessage.getActionType(actionType);
    // 1发起通话
    if (actionType == 1 && groupId != null) {
      String nameStr = "";
      TencentImSDKPlugin.v2TIMManager
          .getGroupManager().getGroupMembersInfo(groupID: groupId, memberList: [
        callingMessage.inviter!
      ]).then((V2TimValueCallback<List<V2TimGroupMemberFullInfo>> res) {
        List<V2TimGroupMemberFullInfo>? infoList = res.data ?? [];
        for (var element in infoList) {
          final showName = getShowName(element);
          nameStr = "$nameStr$showName";
        }
        setState(() {
          customMessageShowText = "$nameStr $actionTypeText";
        });
      });
    }
    // 2取消通话
    if (actionType == 2 && groupId != null) {
      setState(() {
        customMessageShowText = actionTypeText;
      });
    }
    // 3为接受
    if (actionType == 3 && groupId != null) {
      handleThrottleGetShowName(groupId, actionTypeText, callingMessage);
    }
    // 4为拒绝
    if (actionType == 4 && groupId != null) {
      List<String> inviteeShowNameList = [];
      V2TimValueCallback<List<V2TimGroupMemberFullInfo>>
      getGroupMembersInfoRes = await TencentImSDKPlugin.v2TIMManager
          .getGroupManager()
          .getGroupMembersInfo(
        groupID: groupId, // 需要获取的群组id
        memberList: callingMessage.inviteeList ?? [], // 需要获取的用户id列表
      );
      if (getGroupMembersInfoRes.code == 0) {
        // 获取成功
        getGroupMembersInfoRes.data?.forEach((element) {
          inviteeShowNameList.add(getShowName(element));
        });
      }
      callingMessage.inviteeList = inviteeShowNameList;
      handleThrottleGetShowName(groupId, actionTypeText, callingMessage);
    }
    // 5 为超时
    if (actionType == 5 && groupId != null) {
      String nameStr = "";
      TencentImSDKPlugin.v2TIMManager
          .getGroupManager()
          .getGroupMembersInfo(
          groupID: groupId, memberList: callingMessage.inviteeList!)
          .then((V2TimValueCallback<List<V2TimGroupMemberFullInfo>> res) {
        List<V2TimGroupMemberFullInfo>? infoList = res.data ?? [];
        for (var element in infoList) {
          final showName = getShowName(element);
          nameStr = "$nameStr、$showName";
        }
        nameStr = nameStr.substring(1);

        setState(() {
          customMessageShowText = "$nameStr $actionTypeText";
        });
      });
    }

    // return TIMUIKitCustomElem.getActionType(actionType);
  }

  static isCallEndExist(CallingMessage callMsg) {
    int? callEnd = callMsg.callEnd;
    int? actionType = callMsg.actionType;
    if (actionType == 2) return false;
    return callEnd == null
        ? false
        : callEnd > 0
        ? true
        : false;
  }

  Widget _callElemBuilder(BuildContext context) {
    final customElem = widget.customMessage?.customElem;
    final callingMessage = CallingMessage.getCallMessage(customElem);
    String showText = TIM_t("[自定义]");
    if (callingMessage != null) {
      // 如果是结束消息
      final isCallEnd = isCallEndExist(callingMessage);

      String? option2 = "";
      if (isCallEnd) {
        option2 = CallingMessage.getShowTime(callingMessage.callEnd!);
      }
      showText = isCallEnd
          ? TIM_t_para("通话时间：{{option2}}", "通话时间：$option2")(option2: option2)
          : customMessageShowText;

      return Text(
        showText,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: hexToColor("888888")),
        textAlign: TextAlign.center,
        softWrap: true,
      );
    } else {
      return Text(showText);
    }
  }

  Widget wrapMessageTips(Widget child) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10), child: child);
  }

  @override
  Widget build(BuildContext context) {
    return wrapMessageTips(_callElemBuilder(context));
  }
}