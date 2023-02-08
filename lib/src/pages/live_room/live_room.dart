import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/config/display_config.dart';
import 'package:tencent_cloud_av_chat_room/model/anchor_info.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_controller.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_custom_widget.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';
import 'package:timuikit/src/pages/live_room/gift_panel.dart';
import 'package:timuikit/src/pages/live_room/live_player.dart';

class LiveRoom extends StatelessWidget {
  final String loginUserID;
  final String playUrl;
  final String avChatRoomID = '@TGS#aCWHGJ3LC';

  final TencentCloudAvChatRoomController controller =
      TencentCloudAvChatRoomController();

  LiveRoom({Key? key, required this.loginUserID, required this.playUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LiveRoomPlayer(playUrl: playUrl),
        PageViewWithOpacity(
          child: Stack(
            children: [
              Positioned(
                  right: -15,
                  bottom: 25,
                  child: Lottie.asset(
                    'assets/live/hearts.json',
                    width: 100,
                    height: 400,
                    repeat: true,
                  )),
              TencentCloudAVChatRoom(
                controller: controller,
                config: TencentCloudAvChatRoomConfig(
                    avChatRoomID: avChatRoomID,
                    loginUserID: loginUserID,
                    giftHttpBase: "https://qcloudimg.tencent-cloud.cn/raw/",
                    displayConfig: DisplayConfig(
                      showAnchor: true,
                      showOnlineMemberCount: true,
                      showTextFieldGiftAction: true,
                      showTextFieldThumbsUpAction: true,
                    )),
                customWidgets: TencentCloudAvChatRoomCustomWidgets(
                  // anchorInfoPanelBuilder: (context, groupID) {
                  //   return const Text("anchorInfoPanelBuilder");
                  // },
                  // onlineMemberListPanelBuilder: (context, groupID) {
                  //   return const Text("onlineMemberListPanelBuilder");
                  // },
                  // roomHeaderAction: const Text("roomHeaderAction"),
                  // roomHeaderLeading: const Text("roomHeaderAction"),
                  roomHeaderTag: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: RoundedContainer(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/live/Vector.png",
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text(
                            "小时榜排名162名",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ),
                  giftsPanelBuilder: (c) {
                    return GiftPanel(
                      onTap: (item) {
                        final customInfo = {
                          "version": 1.0, // 协议版本号
                          "businessID": "flutter_live_kit", // 业务标识字段
                          "data": {
                            "cmd":
                                "send_gift_message", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
                            "cmdInfo": {
                              "type": item.type,
                              "giftUrl": item.giftUrl,
                              "giftCount": 1,
                              "giftSEUrl": item.seUrl,
                              "giftName": item.name,
                              "giftUnits": "朵",
                            },
                          }
                        };
                        controller.sendGiftMessage(jsonEncode(customInfo));
                        Navigator.pop(c);
                      },
                    );
                  },
                  // messageItemBuilder: (context, message) {
                  //   return Text("message item builder");
                  // },
                  // messageItemPrefixBuilder: (context, message) {
                  //   return Text("message item prefix builder");
                  // },
                  // giftMessageBuilder: (context, message) {
                  //   return Text("gift message builder");
                  // },
                  // textFieldDecoratorBuilder: (context) {
                  //   return Text("textFieldDecoratorBuilder");
                  // },
                  // textFieldActionBuilder: (context) {
                  //   return [Text("text field action")];
                  // },
                  // giftsPanelBuilder: (context) {
                  //   return Text("gifts panel builder");
                  // },
                ),
                data: TencentCloudAvChatRoomData(
                  isSubscribe: false,
                  notification:
                      "欢迎来到直播间！严禁未成年人直播、打赏或向末成年人销售酒类商品。若主播销售酒类商品，请未成年人在监护人陪同下观看。直播间内严禁出现违法违规、低俗色情、吸烟酗酒、人身伤害等内容。如主播在直播中以不当方式诱导打赏私下交易请谨慎判断以防人身财产损失购买商品请点击下方购物车按钮，请勿私下交易，请大家注意财产安全，谨防网络诈骗。",
                  anchorInfo: AnchorInfo(
                      subscribeNum: 200,
                      fansNum: 5768,
                      nickName: "风雨人生",
                      avatarUrl:
                          "https://qcloudimg.tencent-cloud.cn/raw/9c6b6806f88ee33b3685f0435fe9a8b3.png"),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: SafeArea(
              child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 32,
              height: 35,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          )),
        )
      ],
    );
    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   body:
    // );
  }
}

class PageViewWithOpacity extends StatefulWidget {
  final Widget child;

  const PageViewWithOpacity({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageViewWithOpacityState();
}

class _PageViewWithOpacityState extends State<PageViewWithOpacity> {
  final PageController _pageController = PageController(initialPage: 1);
  double _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _initPageControllerListener();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        itemCount: 2,
        allowImplicitScrolling: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              color: Colors.transparent,
            );
          } else {
            return Opacity(
              opacity: _currentPage,
              child: widget.child,
            );
          }
        });
  }

  _initPageControllerListener() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 1.0;
      });
    });
  }
}
