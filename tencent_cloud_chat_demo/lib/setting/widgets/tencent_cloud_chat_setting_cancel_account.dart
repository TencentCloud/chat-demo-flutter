// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_demo/main.dart';

class TencentCloudChatSettingCancelAccount extends StatefulWidget {
  const TencentCloudChatSettingCancelAccount({super.key});

  @override
  State<TencentCloudChatSettingCancelAccount> createState() => _TencentCloudChatSettingCancelAccountState();
}

class _TencentCloudChatSettingCancelAccountState extends TencentCloudChatState<TencentCloudChatSettingCancelAccount> {
  V2TimUserFullInfo userFullInfo = TencentCloudChat.instance.dataInstance.basic.currentUser!;

  _handleLogout(BuildContext context) async {
    final res = await TencentCloudChat.instance.chatController.resetUIKit(
      shouldLogout: true,
    );
    if (res) {
      _resetUIKit();
    }
  }

  _resetUIKit() async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } catch (err) {
      // ToastUtils.log("someError");
      // ToastUtils.log(err);
    }
  }

  CupertinoActionSheet mapAppSheet(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(tL10n.deleteAccount),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            _handleLogout(context);
          },
          child: Text(
            tL10n.deleteAccount,
            style: const TextStyle(
              fontSize: 17.0,
              color: Color(0xFFFF584C),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                elevation: 1,
                title: Text(
                  tL10n.deleteAccount,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
                flexibleSpace: Container(),
                backgroundColor: colorTheme.loginBackgroundColor,
                leading: IconButton(
                  padding: const EdgeInsets.only(left: 16),
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.white,
                  // 返回Home事件
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              body: Container(
                decoration: const BoxDecoration(),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              height: 80,
                              width: 80,
                              child: TencentCloudChatAvatar(
                                imageList: [userFullInfo.faceUrl ?? ""],
                                scene: TencentCloudChatAvatarScene.custom,
                              )),
                          const Positioned(
                            right: -10,
                            bottom: -10,
                            child: Icon(
                              Icons.do_not_disturb_on,
                              color: Color(0xFFFA5151),
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 80),
                        padding: const EdgeInsets.only(right: 40, left: 40),
                        child: Text(
                          tL10n.deleteAccountNotification,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            // color: theme.darkTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40, left: 40),
                        child: MaterialButton(
                          elevation: 0,
                          highlightElevation: 0,
                          minWidth: double.infinity,
                          color: Colors.white,
                          textColor: const Color(0xFFFA5151),
                          height: 46,
                          child: Text(
                            tL10n.deleteAccount,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            showCupertinoModalPopup(context: context, builder: (BuildContext context) => mapAppSheet(context)).then((value) => null);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              height: 80,
                              width: 80,
                              child: TencentCloudChatAvatar(
                                imageList: [userFullInfo.faceUrl ?? ""],
                                scene: TencentCloudChatAvatarScene.custom,
                              )),
                          const Positioned(
                            right: -10,
                            bottom: -10,
                            child: Icon(
                              Icons.do_not_disturb_on,
                              color: Color(0xFFFA5151),
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 80),
                        padding: const EdgeInsets.only(right: 40, left: 40),
                        child: Text(
                          tL10n.deleteAccountNotification,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            // color: theme.darkTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: Text(
                          tL10n.deleteAccount,
                          style: TextStyle(
                            color: colorTheme.primaryColor,
                          ),
                        ),
                        onPressed: () {
                          showCupertinoModalPopup(context: context, builder: (BuildContext context) => mapAppSheet(context)).then((value) => null);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
