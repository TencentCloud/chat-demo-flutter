import 'package:flutter/material.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart'
    if (dart.library.html) 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';

class LocationMessageItem extends StatelessWidget{
  final bool? isSelf;
  final V2TimMessage message;

  const LocationMessageItem({Key? key, this.isSelf, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return LocationMsgElement(
    //   isAllowCurrentLocation: false,
    //   messageID: message.msgID,
    //   locationElem: LocationMessage(
    //     longitude: message.locationElem!.longitude,
    //     latitude: message.locationElem!.latitude,
    //     desc: message.locationElem?.desc ?? "",
    //   ),
    //   isFromSelf: message.isSelf ?? false,
    //   isShowJump: isShowJump,
    //   clearJump: clearJump,
    //   mapBuilder: (onMapLoadDone, mapKey) => BaiduMap(
    //     onMapLoadDone: onMapLoadDone,
    //     key: mapKey,
    //   ),
    //   locationUtils: LocationUtils(BaiduMapService()),
    // );

    String dividerForDesc = "/////";
    final theme = Provider.of<DefaultThemeData>(context).theme;
    final isFromSelf = isSelf ?? true;
    final borderRadius = isFromSelf
        ? const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(2),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10))
        : const BorderRadius.only(
        topLeft: Radius.circular(2),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: Border.all(color: hexToColor("DDDDDD")),
      ),
      constraints: const BoxConstraints(maxWidth: 240),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.locationElem?.desc
                        ?.split(dividerForDesc)[0] ??
                        TIM_t("腾讯大厦"),
                    softWrap: true,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    message.locationElem?.desc
                        ?.split(dividerForDesc)[0] ??
                        TIM_t("深圳市深南大道10000号"),
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 12, color: CommonColor.weakTextColor),
                  ),
                ],
              )),
          SizedBox(
            height: 100,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.weakDividerColor,
                  ),
                ),
                Center(
                  child: Text(
                    TIM_t("位置消息维护中"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, color: theme.darkTextColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}