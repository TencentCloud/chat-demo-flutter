import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_demo/src/config.dart';
import 'package:tencent_cloud_chat_demo/src/pages/live_room/live_room.dart';

class Live extends StatefulWidget {
  const Live({Key? key}) : super(key: key);

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  final avChatRoomID = IMDemoConfig.liveRoomId;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  String groupName = "";
  String backgroundUrl = "";

  @override
  void initState() {
    super.initState();
    _getAvChatRoomInfo();
  }

  @override
  Widget build(BuildContext context) {
    final showList = groupName.isEmpty && backgroundUrl.isEmpty;
    final loginUserInfo = _coreInstance.loginInfo;
    if (showList) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LiveRoom(
                        loginUserID: loginUserInfo.userID,
                        playUrl: IMDemoConfig.livePlayUrl,
                      )));
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage(backgroundUrl))),
                width: 200,
                height: 200,
              ),
              Text(
                groupName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  _getAvChatRoomInfo() async {
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    final responst = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupsInfo(groupIDList: [avChatRoomID]);
    if (responst.code == 0) {
      final responseList = responst.data;
      final info = responseList!.first.groupInfo;
      groupName = info!.groupName ?? "";
      backgroundUrl = info.faceUrl ?? "";
      setState(() {});
    }
  }
}
