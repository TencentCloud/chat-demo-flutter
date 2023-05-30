import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_demo/src/add_friend.dart';
import 'package:tencent_cloud_chat_demo/src/add_group.dart';
import 'package:tencent_cloud_chat_demo/src/create_group.dart';
import 'package:tencent_cloud_chat_demo/src/create_group_introduction.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/search.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/drag_widget.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';

enum PlusType { create, add }

class SearchEntryWide extends StatefulWidget {
  final TIMUIKitConversationController conversationController;
  final PlusType? plusType;
  final VoidCallback? onClickSearch;
  final ValueChanged<V2TimConversation>? directToChat;

  const SearchEntryWide(
      {Key? key,
      required this.conversationController,
      this.plusType = PlusType.create,
      required this.onClickSearch,
      this.directToChat})
      : super(key: key);

  @override
  State<SearchEntryWide> createState() => _SearchEntryWideState();
}

class _SearchEntryWideState extends State<SearchEntryWide> {
  late TIMUIKitConversationController _controller;
  final GlobalKey plusKey = GlobalKey();
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    _controller = widget.conversationController;
  }

  final contactTooltip = [
    {
      "id": "addFriend",
      "asset": "assets/add_friend.png",
      "label": TIM_t("添加好友")
    },
    {"id": "addGroup", "asset": "assets/add_group.png", "label": TIM_t("添加群聊")}
  ];

  final conversationTooltip = [
    {
      "id": "createConv",
      "asset": "assets/c2c_conv.png",
      "label": TIM_t("发起会话")
    },
    {
      "id": "createGroup",
      "asset": "assets/group_conv.png",
      "label": TIM_t("创建群聊")
    },
  ];

  void _handleOnConvItemTapedWithPlace(V2TimConversation? selectedConv,
      [V2TimMessage? toMessage]) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            selectedConversation: selectedConv!,
            initFindingMsg: toMessage,
          ),
        ));
    _controller.reloadData();
  }

  _handleTapTooltipItem(String id) {
    switch (id) {
      case "addFriend":
        TUIKitWidePopup.showPopupWindow(
          context: context,
          operationKey: TUIKitWideModalOperationKey.addFriend,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.4,
          title: TIM_t("添加好友"),
          child: (closeFunc) => AddFriend(
            closeFunc: closeFunc,
            directToChat: widget.directToChat,
          ),
        );
        break;
      case "addGroup":
        TUIKitWidePopup.showPopupWindow(
          context: context,
          operationKey: TUIKitWideModalOperationKey.addGroup,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.4,
          title: TIM_t("添加群聊"),
          child: (closeFunc) => AddGroup(
            closeFunc: closeFunc,
            directToChat: widget.directToChat,
          ),
        );
        break;
      case "createConv":
        TUIKitWidePopup.showPopupWindow(
          operationKey: TUIKitWideModalOperationKey.addFriend,
          context: context,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.4,
          title: TIM_t("添加好友"),
          onSubmit: () {
            createGroupKey.currentState?.onSubmit();
          },
          child: (closeFunc) => CreateGroup(
            key: createGroupKey,
            convType: GroupTypeForUIKit.single,
            directToChat: widget.directToChat,
          ),
        );
        break;
      case "createGroup":
        TUIKitWidePopup.showPopupWindow(
          operationKey: TUIKitWideModalOperationKey.chooseGroupType,
          context: context,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.5,
          title: TIM_t("选择群类型"),
          child: (closeFunc) => CreateGroupIntroduction(
            directToChat: widget.directToChat,
            closeFunc: closeFunc,
          ),
        );
        break;
    }
  }

  List<ColumnMenuItem> _getTooltipContent(BuildContext context) {
    List toolTipList =
        widget.plusType == PlusType.add ? contactTooltip : conversationTooltip;
    return toolTipList.map((e) {
      return ColumnMenuItem(
        label: e['label']!,
        icon: Image.asset(
          e["asset"]!,
          width: 18,
          height: 18,
        ),
        onClick: () {
          _handleTapTooltipItem(e["id"]!);
          entry!.remove();
          entry = null;
        },
      );
    }).toList();
  }

  showStartConversation(Offset? offset) {
    if (entry != null) {
      return;
    }
    entry = OverlayEntry(builder: (BuildContext context) {
      return TUIKitDragArea(
          closeFun: () {
            if (entry != null) {
              entry?.remove();
              entry = null;
            }
          },
          initOffset: offset ??
              Offset(MediaQuery.of(context).size.height * 0.5,
                  MediaQuery.of(context).size.height * 0.5),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFbebebe),
                  offset: Offset(5, 5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: const EdgeInsets.only(top: 4),
            child: TUIKitColumnMenu(
              padding: const EdgeInsets.all(6),
              data: _getTooltipContent(context),
            ),
          ));
    });
    Overlay.of(context).insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 2.0),
        )
      ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (widget.onClickSearch != null) {
                    widget.onClickSearch!();
                  } else {
                    Future<SharedPreferences> _prefs =
                        SharedPreferences.getInstance();
                    SharedPreferences prefs = await _prefs;
                    List<String> guideList =
                        prefs.getStringList('guidedPage') ?? [];
                    bool isFocus = guideList.contains('search');
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Search(
                            onTapConversation: _handleOnConvItemTapedWithPlace,
                            isAutoFocus: isFocus,
                          ),
                        ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: hexToColor("f3f3f4"),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: hexToColor("979797"),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(TIM_t("搜索"),
                          style: TextStyle(
                            color: hexToColor("979797"),
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                final alignBox =
                    plusKey.currentContext?.findRenderObject() as RenderBox?;
                var offset = alignBox?.localToGlobal(Offset.zero);
                final double? dx = (offset?.dx != null) ? offset!.dx : null;
                final double? dy =
                    (offset?.dy != null && alignBox?.size.height != null)
                        ? offset!.dy + alignBox!.size.height + 2
                        : null;
                showStartConversation(
                    (dx != null && dy != null) ? Offset(dx, dy) : null);
              },
              child: Container(
                key: plusKey,
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: hexToColor("f3f3f4"),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Icon(
                  widget.plusType == PlusType.create
                      ? Icons.add
                      : Icons.person_add_alt,
                  color: hexToColor("838383"),
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
