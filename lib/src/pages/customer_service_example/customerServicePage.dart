import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/src/pages/customer_service_example/customerServeiceProfile.dart';
import 'package:tencent_cloud_chat_demo/src/pages/customer_service_example/customerServiceList.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;

    Widget customerService() {
      return CustomerServiceList(
        emptyBuilder: (_) {
          return Center(
            child: Text(TIM_t("暂无在线客服")),
          );
        },
        onTapItem: (V2TimUserFullInfo friendInfo) {
          final isWideScreen =
              TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
          if (isWideScreen) {
            // TODO
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CustomerServeiceProfile(userID: friendInfo.userID!),
                ));
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            TIM_t("在线客服"),
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
      body: customerService(),
    );
  }
}
