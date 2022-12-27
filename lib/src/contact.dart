import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:timuikit/src/blackList.dart';
import 'package:timuikit/src/group_list.dart';
import 'package:timuikit/src/provider/local_setting.dart';
import 'package:timuikit/src/provider/theme.dart';
import 'package:timuikit/src/user_profile.dart';
import 'newContact.dart';


class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  void initState() {
    super.initState();
  }

  _topListItemTap(String id) {
    switch (id) {
      case "newContact":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewContact(),
            ));
        break;
      case "groupList":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupList(),
            ));
        break;
      case "blackList":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BlackList(),
            ));
    }
  }

  String _getImagePathByID(String id) {
    final themeTypeSuffix = Provider.of<DefaultThemeData>(context)
        .currentThemeType
        .toString()
        .replaceFirst('ThemeType.', '');
    switch (id) {
      case "newContact":
        return "assets/newContact_$themeTypeSuffix.png";
      case "groupList":
        return "assets/groupList_$themeTypeSuffix.png";
      case "blackList":
        return "assets/blackList_$themeTypeSuffix.png";
      default:
        return "";
    }
  }

  Widget? _topListBuilder(TopListItem item) {
    final showName = item.name;
    if (item.id == "newContact") {
      return InkWell(
        onTap: () {
          _topListItemTap(item.id);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: hexToColor("DBDBDB")))),
          padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 12),
                child: Avatar(
                    faceUrl: _getImagePathByID(item.id),
                    showName: showName,
                    isFromLocalAsset: true,
                    ),
              ),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        showName,
                        style:
                            TextStyle(color: hexToColor("111111"), fontSize: 18),
                      ),
                      Expanded(child: Container()),
                      const TIMUIKitUnreadCount(),
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: hexToColor('BBBBBB'),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    return TIMUIKitContact(
      isShowOnlineStatus: localSetting.isShowOnlineStatus,
      topList: [
        TopListItem(
            name: TIM_t("新的联系人"),
            id: "newContact",
            icon: Image.asset(_getImagePathByID("newContact")),
            onTap: () {
              _topListItemTap("newContact");
            }),
        TopListItem(
            name: TIM_t("我的群聊"),
            id: "groupList",
            icon: Image.asset(_getImagePathByID("groupList")),
            onTap: () {
              _topListItemTap("groupList");
            }),
        TopListItem(
            name: TIM_t("黑名单"),
            id: "blackList",
            icon: Image.asset(_getImagePathByID("blackList")),
            onTap: () {
              _topListItemTap("blackList");
            })
      ],
      topListItemBuilder: _topListBuilder,
      onTapItem: (item) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userID: item.userID),
            ));
      },
      emptyBuilder: (context) => Center(
        child: Text(TIM_t("无联系人")),
      ),
    );
  }
}
