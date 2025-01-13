import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/data/theme/color/color_base.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_tatal_unread_count.dart';
import 'package:tencent_cloud_chat_demo/desktop/current_user.dart';

class NavigationBarData {
  final Widget unselectedIcon;

  final Widget selectedIcon;

  final String title;

  final Widget? widget;

  final ValueChanged<int>? onTap;

  final int? index;

  NavigationBarData({
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.title,
    this.widget,
    this.onTap,
    this.index,
  });
}

class LeftBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChange;

  const LeftBar({Key? key, required this.index, required this.onChange}) : super(key: key);

  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  List<NavigationBarData> getBottomNavigatorList(TencentCloudChatThemeColors colorTheme) {
    return [
      NavigationBarData(
        index: 0,
        title: tL10n.chats,
        selectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(colorTheme.primaryColor, BlendMode.srcATop),
              child: Image.asset(
                "assets/chat_active.png",
                width: 24,
                height: 24,
              ),
            ),
            Positioned(
              top: -5,
              right: -6,
              child: UnconstrainedBox(child: TencentCloudChatConversationTotalUnreadCount(
                builder: (BuildContext _, int totalUnreadCount) {
                  if (totalUnreadCount == 0) {
                    return Container();
                  }
                  return UnconstrainedBox(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "$totalUnreadCount",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorTheme.primaryTextColor,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
        unselectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
                colorFilter: ColorFilter.mode(colorTheme.secondaryTextColor.withOpacity(0.3), BlendMode.srcATop),
                child: Image.asset(
                  "assets/chat.png",
                  width: 24,
                  height: 24,
                )),
            Positioned(
              top: -5,
              right: -6,
              child: UnconstrainedBox(
                child: TencentCloudChatConversationTotalUnreadCount(
                  builder: (BuildContext _, int totalUnreadCount) {
                    if (totalUnreadCount == 0) {
                      return Container();
                    }
                    return UnconstrainedBox(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colorTheme.tipsColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$totalUnreadCount",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorTheme.appBarBackgroundColor, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      NavigationBarData(
        index: 1,
        title: tL10n.contacts,
        selectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(colorTheme.primaryColor, BlendMode.srcATop),
              child: Image.asset(
                "assets/contact_active.png",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        unselectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
                colorFilter: ColorFilter.mode(colorTheme.secondaryTextColor.withOpacity(0.3), BlendMode.srcATop),
                child: Image.asset(
                  "assets/contact.png",
                  width: 24,
                  height: 24,
                )),
          ],
        ),
      ),
      NavigationBarData(
        index: 2,
        title: tL10n.settings,
        selectedIcon: ColorFiltered(
            colorFilter: ColorFilter.mode(colorTheme.primaryColor, BlendMode.srcATop),
            child: Image.asset(
              "assets/profile_active.png",
              width: 24,
              height: 24,
            )),
        unselectedIcon: ColorFiltered(
            colorFilter: ColorFilter.mode(colorTheme.secondaryTextColor.withOpacity(0.3), BlendMode.srcATop),
            child: Image.asset(
              "assets/profile.png",
              width: 24,
              height: 24,
            )),
      ),
    ];
  }

  List<Widget> bottomNavigatorList(TencentCloudChatThemeColors theme) {
    return getBottomNavigatorList(theme).map((e) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: widget.index == e.index ? theme.primaryColor.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: GestureDetector(
          onTap: () {
            widget.onChange(e.index!);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: widget.index == e.index ? e.selectedIcon : e.unselectedIcon,
                ),
                const SizedBox(height: 4),
                Text(
                  e.title,
                  style: TextStyle(
                    color: widget.index == e.index ? theme.primaryTextColor : theme.secondaryTextColor,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: bottomNavigatorList(colorTheme),
                ),
                Expanded(child: Container()),
                const CurrentUserAvatar(),
              ],
            ));
  }
}
