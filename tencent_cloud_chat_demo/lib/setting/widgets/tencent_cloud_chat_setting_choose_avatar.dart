import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_setting_leading.dart';

class TencentCloudChatSettingChooseAvatar extends StatefulWidget{
  static const String avatarFaceURL = "https://im.sdk.qcloud.com/download/tuikit-resource/avatar/avatar_%s.png";
  static const int avatarFaceCount = 26;
  List<String> avatarURLList = [];
  String selectedAvatarUrl;

  TencentCloudChatSettingChooseAvatar({Key? key, required this.selectedAvatarUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingChooseAvatarState();
}

class TencentCloudChatSettingChooseAvatarState extends TencentCloudChatState<TencentCloudChatSettingChooseAvatar> {
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < TencentCloudChatSettingChooseAvatar.avatarFaceCount; i++) {
      widget.avatarURLList.add(TencentCloudChatSettingChooseAvatar.avatarFaceURL.replaceAll("%s", (i + 1).toString()));
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Scaffold(
        appBar: AppBar(
          leadingWidth: getWidth(100),
          leading: const TencentCloudChatSettingLeading(),
          title: Text(
            tL10n.chooseAvatar,
            style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.settingTitleColor),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                _submitAvatar();
              },
              child: Text(tL10n.confirm,),
            )
          ],
          backgroundColor: colorTheme.settingBackgroundColor,
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0
          ),
          itemCount: widget.avatarURLList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  widget.selectedAvatarUrl = widget.avatarURLList[index];
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    widget.selectedAvatarUrl == widget.avatarURLList[index] ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.network(
                  widget.avatarURLList[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      )
    );
  }

  _submitAvatar() async {
    if (widget.selectedAvatarUrl != null && widget.selectedAvatarUrl != "") {
      final result = await TencentCloudChat.instance.chatSDKInstance.setSelfInfo(faceUrl: widget.selectedAvatarUrl);
      if (result?.code == 0) {
        if (mounted) {
          Navigator.of(context).pop(widget.selectedAvatarUrl);
        }
      }
    }
  }

}