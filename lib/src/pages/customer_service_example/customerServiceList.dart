import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_customer_service_plugin/tencent_cloud_chat_customer_service_plugin.dart';
import 'package:tencent_cloud_chat_demo/src/config.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class CustomerServiceList extends StatefulWidget {
  final void Function(V2TimUserFullInfo friendInfo)? onTapItem;
  final Widget Function(BuildContext context)? emptyBuilder;

  const CustomerServiceList({Key? key, this.onTapItem, this.emptyBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomerServiceListState();
}

class _CustomerServiceListState extends TIMUIKitState<CustomerServiceList> {
  List<V2TimUserFullInfo> customerServiceInfoList = [];
  @override
  void initState() {
    super.initState();
    _getCustomerServiceInfo();
  }

  _getCustomerServiceInfo() async {
    customerServiceInfoList =
        await TencentCloudChatCustomerServicePlugin.getCustomerServiceInfo(
            IMDemoConfig.customerServiceUserList);
    setState(() {
      customerServiceInfoList = customerServiceInfoList;
    });
  }

  _getShowName(V2TimUserFullInfo item) {
    final nickName = item.nickName ?? "";
    final userID = item.userID;
    final showName = nickName != "" ? nickName : userID;
    return showName;
  }

  Widget _itemBuilder(BuildContext context, V2TimUserFullInfo friendInfo) {
    final theme = Provider.of<TUIThemeViewModel>(context).theme;
    final showName = _getShowName(friendInfo);
    final faceUrl = friendInfo.faceUrl ?? "";
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;

    Widget itemWidget() {
      return Material(
        color: theme.wideBackgroundColor,
        child: InkWell(
          onTap: () {
            if (widget.onTapItem != null) {
              widget.onTapItem!(friendInfo);
            }
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: theme.weakDividerColor ??
                            CommonColor.weakDividerColor))),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  margin: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    height: isDesktopScreen ? 30 : 40,
                    width: isDesktopScreen ? 30 : 40,
                    child: Avatar(faceUrl: faceUrl, showName: showName),
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    showName,
                    style: TextStyle(
                        color: theme.black,
                        fontSize: isDesktopScreen ? 14 : 18),
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    }

    return itemWidget();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    if (customerServiceInfoList.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: customerServiceInfoList.length,
        itemBuilder: (context, index) {
          final friendInfo = customerServiceInfoList[index];
          final itemBuilder = _itemBuilder;
          return itemBuilder(context, friendInfo);
        },
      );
    }

    if (widget.emptyBuilder != null) {
      return widget.emptyBuilder!(context);
    }

    return Container();
  }
}
