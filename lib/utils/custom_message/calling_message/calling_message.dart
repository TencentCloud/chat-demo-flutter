import 'dart:convert';
import 'package:tencent_im_base/tencent_im_base.dart';

enum CallProtocolType {
  send,
  cancel,
  accept,
  reject,
  busy,
  timeout,
  hangup,
  midway,
  end,
  unknown,
}

class CallingMessage {
  /// 发起邀请方
  String? inviter;

  /// 被邀请方
  List<String>? inviteeList;

  int? callType;

  // 1: 邀请方发起邀请
  // 2: 邀请方取消邀请
  // 3: 被邀请方接受邀请
  // 4: 被邀请方拒绝邀请
  // 5: 邀请超时
  int? actionType;

  /// 邀请ID
  String? inviteID;

  /// 通话时间
  int? timeout;

  /// 通话房间
  int? roomID;

  // 通话时间：秒，大于0代表通话时间
  int? callEnd;
  // 是否是群组通话
  bool? isGroup;

  String? cmd;

  String? initialCallId;

  String? excludeFromHistoryMessage;

  CallingMessage(
      {this.inviter,
        this.actionType,
        this.inviteID,
        this.inviteeList,
        this.timeout,
        this.roomID,
        this.callType,
        this.callEnd,
        this.isGroup,
        this.cmd,
        this.initialCallId,
        this.excludeFromHistoryMessage});

  CallingMessage.fromJSON(json) {
    final detailData = jsonDecode(json["data"]);
    final detailDataData = detailData["data"];
    actionType = json["actionType"];
    timeout = json["timeout"];
    inviter = json["inviter"];
    inviteeList = List<String>.from(json["inviteeList"]);
    inviteID = json["inviteID"];
    callType = detailData["call_type"];
    roomID = detailData["room_id"];
    callEnd = detailData["call_end"];
    isGroup = detailData["is_group"];
    cmd = detailDataData["cmd"];
    initialCallId =  detailDataData['initialCallId'];
    try {
      excludeFromHistoryMessage = detailDataData['excludeFromHistoryMessage'];
    } catch(e) {
      excludeFromHistoryMessage = null;
    }
  }

  static CallingMessage? getCallMessage(V2TimCustomElem? customElem) {
    try {
      if (customElem?.data != null) {
        final customMessage = jsonDecode(customElem!.data!);
        return CallingMessage.fromJSON(customMessage);
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  static CallProtocolType getCallProtocolType(CallingMessage callingMessage) {
    final actionType = callingMessage.actionType!;
    final cmd = callingMessage.cmd ?? '';
    final initialCallId = callingMessage.initialCallId;

    switch (actionType) {
      case 1:
        if (cmd == 'hangup') {
          if (callingMessage.excludeFromHistoryMessage == null) {
            return CallProtocolType.end;
          }
          return CallProtocolType.hangup;
        } else if(cmd == 'videoCall') {
          if (initialCallId != null) {
            return CallProtocolType.midway;
          }
          return CallProtocolType.send;
        } else if (cmd == 'audioCall') {
          if (initialCallId != null) {
            return CallProtocolType.midway;
          }
          return CallProtocolType.send;
        } else {
          return CallProtocolType.unknown;
        }
      case 2:
        return CallProtocolType.cancel;
      case 3:
        return CallProtocolType.accept;
      case 4:
        return CallProtocolType.reject;
      case 5:
        return CallProtocolType.timeout;
      default:
        return CallProtocolType.unknown;
    }
  }

  static bool isShowInGroup(CallingMessage callingMessage) {
    final type = getCallProtocolType(callingMessage);
    if (type == CallProtocolType.hangup ||
        type == CallProtocolType.midway ||
        type == CallProtocolType.busy ||
        type == CallProtocolType.end) {
      return false;
    }
    return true;
  }

  static String getActionType(CallingMessage callingMessage) {
    final type = getCallProtocolType(callingMessage);
    switch (type) {
      case CallProtocolType.send:
        return TIM_t("发起通话");
      case CallProtocolType.cancel:
        return TIM_t("取消通话");
      case CallProtocolType.accept:
        return TIM_t("接受通话");
      case CallProtocolType.reject:
        return TIM_t("拒绝通话");
      case CallProtocolType.timeout:
        return TIM_t("超时未接听");
      case CallProtocolType.busy:
        return '';
      case CallProtocolType.hangup:
        return '';
      case CallProtocolType.midway:
        return '';
      case CallProtocolType.end:
        return TIM_t('通话结束');
      case CallProtocolType.unknown:
        return '';
    }
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

  static isGroupCallEndExist(CallingMessage callMsg) {
    final actionType = callMsg.actionType!;
    final cmd = callMsg.cmd ?? '';
    final inviteID = callMsg.inviteID;
    if (actionType == 1 && cmd == 'hangup' && callMsg.excludeFromHistoryMessage == null && inviteID != null) {
      return true;
    }
    return false;
  }

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static getShowTime(int seconds) {
    int secondsShow = seconds % 60;
    int minutesShow = seconds ~/ 60;
    return "${twoDigits(minutesShow)}:${twoDigits(secondsShow)}";
  }
}