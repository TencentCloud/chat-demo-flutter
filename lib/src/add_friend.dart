import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:timuikit/src/user_profile.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        title: Text(
          TIM_t("添加好友"),
          style: TextStyle(color: hexToColor("1f2329"), fontSize: 16),
        ),
        backgroundColor: hexToColor("f2f3f5"),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 16),
          icon: Icon(
            Icons.arrow_back_ios,
            color: hexToColor("2a2e35"),
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: TIMUIKitAddFriend(
        onTapAlreadyFriendsItem: (String userID) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(userID: userID),
              ));
        },
      ),
    );
  }
}
