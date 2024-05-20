//通话协议类型
import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

enum CallProtocolType { unknown, send, accept, reject, cancel, hangup, timeout, lineBusy, switchToAudio, switchToAudioConfirm }

//通话媒体类型
enum CallStreamMediaType { unknown, audio, video }

//通话参与者样式
enum CallParticipantType {
  unknown,
  c2c,
  group,
}

//通话人员角色
enum CallParticipantRole { unknown, caller, callee }

enum CallMessageDirection { incoming, outcoming }

class CallingMessageDataProvider {
  Map? _jsonData;
  V2TimSignalingInfo? _signalingInfo;
  V2TimMessage? _innerMessage;

  CallProtocolType _protocolType = CallProtocolType.unknown;
  CallStreamMediaType _streamMediaType = CallStreamMediaType.unknown;
  CallParticipantType _participantType = CallParticipantType.unknown;
  CallParticipantRole _participantRole = CallParticipantRole.unknown;
  CallMessageDirection _direction = CallMessageDirection.outcoming;
  bool _excludeFromHistory = false;
  String _callerId = '';
  String _content = '';
  bool _isCallingSignal = false;

  CallProtocolType get protocolType => _protocolType;
  // 媒体类型
  CallStreamMediaType get streamMediaType => _streamMediaType;
  // 通话类型
  CallParticipantType get participantType => _participantType;
  // 用户角色
  CallParticipantRole get participantRole => _participantRole;
  // 上屏信息的方向信息
  CallMessageDirection get direction => _direction;
  // 是否需要上屏
  bool get excludeFromHistory => _excludeFromHistory;
  // 主角ID
  String get callerId => _callerId;
  // 上屏内容
  String get content => _content;
  // 是否Call信令
  bool get isCallingSignal => _isCallingSignal;

  CallingMessageDataProvider(V2TimMessage message) {
    _initInter(message);

    //这里的顺序不能乱
    _setIsCallingSignal();
    _setProtocolType();
    _setStreamMediaType();
    _setParticipantType();
    _setCallerId();
    _setParticipantRole();
    _setDirection();
    _setExcludeFromHistory();
    _setContent();
  }

  _initInter(V2TimMessage message) async {
    _innerMessage = message;
    try {
      if (_innerMessage?.customElem?.data != null) {
        final signalingInfoData = jsonDecode(_innerMessage!.customElem!.data!);
        _signalingInfo = V2TimSignalingInfo.fromJson(signalingInfoData);
      } else {
        return;
      }
    } catch (err) {
      return;
    }

    try {
      if (_signalingInfo?.data != null) {
        _jsonData = jsonDecode(_signalingInfo!.data!);
      } else {
        return;
      }
    } catch (err) {
      return;
    }
  }

  _setIsCallingSignal() {
    if (_innerMessage == null || _signalingInfo == null || _jsonData == null) {
      _isCallingSignal = false;
      return;
    }

    final businessID = _jsonData!['businessID'];
    if (businessID != null && businessID == 'av_call') {
      _isCallingSignal = true;
    } else {
      _isCallingSignal = false;
    }
  }

  _setProtocolType() {
    if (_innerMessage == null || _signalingInfo == null || _jsonData == null) {
      _protocolType = CallProtocolType.unknown;
      return;
    }

    switch (_signalingInfo!.actionType) {
      case 1:
        final data = _jsonData!['data'];
        if (data != null) {
          final cmd = data['cmd'];
          if (cmd != null) {
            if (cmd == 'switchToAudio') {
              _protocolType = CallProtocolType.switchToAudio;
            } else if (cmd == 'hangup') {
              _protocolType = CallProtocolType.hangup;
            } else if (cmd == 'videoCall') {
              _protocolType = CallProtocolType.send;
            } else if (cmd == 'audioCall') {
              _protocolType = CallProtocolType.send;
            } else {
              _protocolType = CallProtocolType.unknown;
            }
          } else {
            _protocolType = CallProtocolType.unknown;
          }
        } else {
          final callEnd = _jsonData!['call_end'];
          if (callEnd != null) {
            _protocolType = CallProtocolType.hangup;
          } else {
            _protocolType = CallProtocolType.send;
          }
        }
        break;
      case 2:
        _protocolType = CallProtocolType.cancel;
        break;
      case 3:
        final data = _jsonData!['data'];
        if (data != null) {
          final cmd = data['cmd'];
          if (cmd != null) {
            if (cmd == 'switchToAudio') {
              _protocolType = CallProtocolType.switchToAudioConfirm;
            } else {
              _protocolType = CallProtocolType.accept;
            }
          } else {
            _protocolType = CallProtocolType.accept;
          }
        } else {
          _protocolType = CallProtocolType.accept;
        }
        break;
      case 4:
        if (_jsonData!['line_busy'] != null) {
          _protocolType = CallProtocolType.lineBusy;
        } else {
          _protocolType = CallProtocolType.reject;
        }
        break;
      case 5:
        _protocolType = CallProtocolType.timeout;
        break;
      default:
        _protocolType = CallProtocolType.unknown;
        break;
    }
  }

  _setStreamMediaType() {
    _streamMediaType = CallStreamMediaType.unknown;
    if (_protocolType == CallProtocolType.unknown) {
      _streamMediaType = CallStreamMediaType.unknown;
      return;
    }

    final callType = _jsonData!['call_type'];
    if (callType != null) {
      if (callType == 1) {
        _streamMediaType = CallStreamMediaType.audio;
      } else if (callType == 2) {
        _streamMediaType = CallStreamMediaType.video;
      }
    }

    if (_protocolType == CallProtocolType.send) {
      final data = _jsonData!['data'];
      if (data != null) {
        final cmd = data['cmd'];
        if (cmd != null) {
          if (cmd == 'audioCall') {
            _streamMediaType = CallStreamMediaType.audio;
          } else if (cmd == 'videoCall') {
            _streamMediaType = CallStreamMediaType.video;
          }
        }
      }
    } else if (_protocolType == CallProtocolType.switchToAudio || _protocolType == CallProtocolType.switchToAudioConfirm) {
      _streamMediaType = CallStreamMediaType.video;
    }
  }

  _setParticipantType() {
    if (_protocolType == CallProtocolType.unknown) {
      _participantType = CallParticipantType.unknown;
      return;
    }

    if (_signalingInfo!.groupID != null && _signalingInfo!.groupID!.isNotEmpty) {
      _participantType = CallParticipantType.group;
    } else {
      _participantType = CallParticipantType.c2c;
    }
  }

  _setCallerId() async {
    if (_protocolType == CallProtocolType.unknown) {
      return;
    }

    final data = _jsonData!['data'];
    if (data != null) {
      final inviter = data['inviter'];
      if (inviter != null) {
        _callerId = inviter as String;
      }
    }

    if (_callerId.isEmpty) {
      _callerId = TIMUIKitCore.getInstance().loginInfo.userID;
    }
  }

  _setParticipantRole() async {
    final loginUserId = TIMUIKitCore.getInstance().loginInfo.userID;

    if (_callerId == loginUserId) {
      _participantRole = CallParticipantRole.caller;
    } else {
      _participantRole = CallParticipantRole.callee;
    }
  }

  _setDirection() {
    if (_participantRole == CallParticipantRole.caller) {
      _direction = CallMessageDirection.outcoming;
    } else {
      _direction = CallMessageDirection.incoming;
    }
  }

  _setExcludeFromHistory() {
    _excludeFromHistory = _protocolType != CallProtocolType.unknown && _innerMessage!.isExcludedFromLastMessage! && _innerMessage!.isExcludedFromUnreadCount!;
  }

  _setContent() {
    if (_excludeFromHistory) {
      _content = '';
      return;
    }

    bool isCaller = _participantRole == CallParticipantRole.caller;
    final showName = _getShowName();

    if (_participantType == CallParticipantType.c2c) {
      if (_protocolType == CallProtocolType.reject) {
        _content = isCaller ? TIM_t('对方已拒绝') : TIM_t('已拒绝');
      } else if (_protocolType == CallProtocolType.cancel) {
        _content = isCaller ? TIM_t('已取消') : TIM_t('对方已取消');
      } else if (_protocolType == CallProtocolType.hangup) {
        final time = _getShowTime(_jsonData!['call_end']);
        _content = TIM_t('通话时长') + '：$time';
      } else if (_protocolType == CallProtocolType.timeout) {
        _content = isCaller ? TIM_t('对方无应答') : TIM_t('对方已取消');
      } else if (_protocolType == CallProtocolType.lineBusy) {
        _content = isCaller ? TIM_t('对方忙线中') : TIM_t('对方已取消');
      } else if (_protocolType == CallProtocolType.send) {
        _content = TIM_t('发起通话');
      } else if (_protocolType == CallProtocolType.accept) {
        _content = TIM_t('接听通话');
      } else if (_protocolType == CallProtocolType.switchToAudio) {
        _content = TIM_t('视频转语音');
      } else if (_protocolType == CallProtocolType.switchToAudioConfirm) {
        _content = TIM_t('确认转语音');
      } else {
        _content = TIM_t('未知通话');
      }
    } else if (_participantType == CallParticipantType.group) {
      if (_protocolType == CallProtocolType.send) {
        _content = showName + TIM_t('发起了群通话');
      } else if (_protocolType == CallProtocolType.cancel) {
        _content = TIM_t('通话结束');
      } else if (_protocolType == CallProtocolType.hangup) {
        _content = TIM_t('通话结束');
      } else if (_protocolType == CallProtocolType.timeout || _protocolType == CallProtocolType.lineBusy) {
        String inviteeNames = '';
        for (String invitee in _signalingInfo!.inviteeList) {
          inviteeNames = inviteeNames + invitee + '、';
        }
        _content = inviteeNames.substring(0, inviteeNames.length - 1) + TIM_t('未接听');
      } else if (_protocolType == CallProtocolType.reject) {
        _content = showName + TIM_t('拒绝群通话');
      } else if (_protocolType == CallProtocolType.accept) {
        _content = showName + TIM_t('接听');
      } else if (_protocolType == CallProtocolType.switchToAudio) {
        _content = showName + TIM_t('视频转语音');
      } else if (_protocolType == CallProtocolType.switchToAudioConfirm) {
        _content = showName + TIM_t('同意视频转语音');
      } else {
        _content = TIM_t('未知通话');
      }
    } else {
      _content = TIM_t('未知通话');
    }
  }

  _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  _getShowTime(int seconds) {
    int secondsShow = seconds % 60;
    int minutesShow = seconds ~/ 60;
    return "${_twoDigits(minutesShow)}:${_twoDigits(secondsShow)}";
  }

  _getShowName() {
    String showName = _innerMessage?.sender ?? "";
    if (_innerMessage?.nameCard != null && _innerMessage!.nameCard!.isNotEmpty) {
      showName = _innerMessage!.nameCard!;
    } else if (_innerMessage?.friendRemark != null && _innerMessage!.friendRemark!.isNotEmpty) {
      showName = _innerMessage!.friendRemark!;
    } else if (_innerMessage?.nickName != null && _innerMessage!.nickName!.isNotEmpty) {
      showName = _innerMessage!.nickName!;
    }
    return showName;
  }
}
