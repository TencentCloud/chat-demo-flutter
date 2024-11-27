import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_demo/src/config.dart';

class AvatarSelectPage extends StatefulWidget {
  static const String avatarFaceUrl = "https://im.sdk.qcloud.com/download/tuikit-resource/avatar/avatar_%s.png";
  static const int avatarFaceCount = 26;

  List<String> avatarURLList = [];
  final TIMUIKitProfileController? controller;
  String selectedAvatarUrl;

  AvatarSelectPage({Key? key, required this.controller, required this.selectedAvatarUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AvatarSelectPageState();
}

class AvatarSelectPageState extends State<AvatarSelectPage> {
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < AvatarSelectPage.avatarFaceCount; i++) {
      widget.avatarURLList.add(AvatarSelectPage.avatarFaceUrl.replaceAll("%s", (i + 1).toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    return Scaffold(
      appBar: isWideScreen
          ? null
          : AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              shadowColor: theme.weakDividerColor,
              elevation: 1,
              title: Text(
                TIM_t("选择头像"),
                style: const TextStyle(fontSize: IMDemoConfig.appBarTitleFontSize),
              ),
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
            onPressed: () {
              _submitAvatar();
            },
            child: Text(
              TIM_t("确定"),
              style: TextStyle(
                color: theme.white,
                fontSize: IMDemoConfig.appBarTitleFontSize,
              ),
            ),
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 设置每行显示的网格数量
          childAspectRatio: 1.0, // 设置网格宽高比
        ),
        itemCount: widget.avatarURLList.length, // 数据源
        itemBuilder: (context, index) {
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
        }
      ),
    );
  }

  _submitAvatar() async {
    if (widget.selectedAvatarUrl != null && widget.selectedAvatarUrl != "") {
      final result = await widget.controller?.updateAvatar(widget.selectedAvatarUrl);
      if (result?.code == 0) {
        Navigator.of(context).pop(widget.selectedAvatarUrl);
      }
    }
  }
}