import 'dart:convert';
import 'package:tencent_im_base/tencent_im_base.dart';

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

  CallingMessage(
      {this.inviter,
        this.actionType,
        this.inviteID,
        this.inviteeList,
        this.timeout,
        this.roomID,
        this.callType,
        this.callEnd,
        this.isGroup});

  CallingMessage.fromJSON(json) {
    final detailData = jsonDecode(json["data"]);
    actionType = json["actionType"];
    timeout = json["timeout"];
    inviter = json["inviter"];
    inviteeList = List<String>.from(json["inviteeList"]);
    inviteID = json["inviteID"];
    callType = detailData["call_type"];
    roomID = detailData["room_id"];
    callEnd = detailData["call_end"];
    isGroup = detailData["is_group"];
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

  static String getActionType(int actionType) {
    final actionMessage = {
      1: TIM_t("发起通话"),
      2: TIM_t("取消通话"),
      3: TIM_t("接受通话"),
      4: TIM_t("拒绝通话"),
      5: TIM_t("超时未接听"),
    };
    return actionMessage[actionType] ?? "";
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