// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class NewContact extends StatelessWidget {
  const NewContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    Widget newContactWidget() {
      return TIMUIKitNewContact(
        emptyBuilder: (c) {
          return Center(
            child: Text(TIM_t("暂无新联系人")),
          );
        },
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: newContactWidget(),
        defaultWidget: Scaffold(
          appBar: AppBar(
              title: Text(
                TIM_t("新的联系人"),
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              shadowColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                    theme.primaryColor ?? CommonColor.primaryColor
                  ]),
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              )),
          body: TIMUIKitNewContact(
            emptyBuilder: (c) {
              return Center(
                child: Text(TIM_t("暂无新联系人")),
              );
            },
          ),
        ));
  }
}
