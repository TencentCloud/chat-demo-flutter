import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_message_config.dart';
import 'package:tencent_cloud_chat_common/components/component_config/tencent_cloud_chat_user_config.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_contact_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/component_event_handlers/tencent_cloud_chat_message_event_handlers.dart';
import 'package:tencent_cloud_chat_common/components/component_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat_common/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat_common/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_callbacks.dart';
import 'package:tencent_cloud_chat_common/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat_common/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_common/widgets/material_app.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_tatal_unread_count.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/desktop/app_layout.dart';
import 'package:tencent_cloud_chat_demo/login/login.dart';
import 'package:tencent_cloud_chat_demo/login/toast_utils.dart';
import 'package:tencent_cloud_chat_demo/setting/tencent_cloud_chat_settings.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/special_case/tencent_cloud_chat_message_no_chat.dart';
import 'package:tencent_cloud_chat_message_reaction/tencent_cloud_chat_message_reaction.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';
// import 'package:tencent_cloud_chat_search/tencent_cloud_chat_search.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_init_data.dart';
import 'package:tencent_cloud_chat_text_translate/tencent_cloud_chat_text_translate.dart';
import 'package:tencent_cloud_chat_sound_to_text/tencent_cloud_chat_sound_to_text.dart';

void main() {
  if (kIsWeb || Platform.isMacOS || Platform.isWindows) {
    runApp(const MyApp());
    try {
      doWhenWindowReady(() {
        const initialSize = Size(1300, 830);
        appWindow.minSize = const Size(1100, 630);
        appWindow.size = initialSize;
        appWindow.alignment = Alignment.center;
        appWindow.show();
      });
    } catch (err) {
      //err
    }
  } else {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatMaterialApp(
      title: 'Tencent Cloud Chat',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [TUICallKit.navigatorObserver],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends TencentCloudChatState<MyHomePage> {
  int currentIndex = 0;

  List<Widget> pages = [];

  _MyHomePageState() : super(needFPSMonitor: true);

  bool isLogin = false;

  _generateLoginInfo(LoginInfo loginInfo) {
    safeSetState(() {
      currentIndex = 0;
      isLogin = true;
    });

    _initTencentCloudChat(loginInfo);
  }

  _initTencentCloudChat(LoginInfo loginInfo) async {
    await TencentCloudChat.controller.initUIKit(
      config: TencentCloudChatConfig(
        userConfig: TencentCloudChatUserConfig(
          useUserOnlineStatus: true,
          autoDownloadMultimediaMessage: true,
        ),
      ),
      options: TencentCloudChatInitOptions(
        sdkAppID: IMConfig.sdkAppID,
        userID: loginInfo.userID,
        userSig: loginInfo.userSig,
      ),
      components: TencentCloudChatInitComponentsRelated(
        usedComponentsRegister: [
          TencentCloudChatConversationManager.register,
          TencentCloudChatMessageManager.register,
          TencentCloudChatContactManager.register,
        ],
        componentConfigs: TencentCloudChatComponentConfigs(
          /// You can provide your custom configurations for each UI modular component here.
          /// These configurations will be applied globally.
          /// If you prefer to use the default configurations, you can leave this section empty.
          ///
          /// Example: For the Message component, config them as follows:
          messageConfig: TencentCloudChatMessageConfig(
            showSelfAvatar: ({String? groupID, String? userID, String? topicID}) => true,
            enableParseMarkdown: ({String? groupID, String? userID, String? topicID}) => true,
            enabledGroupTypesForMessageReadReceipt: ({String? groupID, String? userID, String? topicID}) => [GroupType.Work, GroupType.Public, GroupType.Meeting, GroupType.Community],
          ),
        ),
        componentBuilders: TencentCloudChatComponentBuilders(
          /// You can provide your custom UI builders for each UI modular component here.
          /// These builders will be applied globally.
          /// If you prefer to use the default builders, you can leave this section empty.
          ///
          /// Example: For the Message component, config them as follows:
          messageBuilder: TencentCloudChatMessageBuilders(
            messageNoChatBuilder: () => const TencentCloudChatMessageNoChat()
          ),
        ),
        componentEventHandlers: TencentCloudChatComponentEventHandlers(
          /// You can provide your custom event handlers for UI component-related events here.
          /// These handlers will be applied globally.
          /// If you prefer to use the default event handlers, you can leave this section empty.
          ///
          /// Example: For the Contact component, handling the events as follow:
          contactEventHandlers: TencentCloudChatContactEventHandlers(
            uiEventHandlers: TencentCloudChatContactUIEventHandlers(
              onTapContactItem: ({
                String? userID,
                String? groupID,
              }) async {
                final isMobile = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.mobile;
                if (!isMobile) {
                  desktopAppLayoutKey.currentState?.navigateToChat(
                    groupID: groupID,
                    userID: userID,
                  );
                  return true;
                } else {
                  return false;
                }
              },
            ),
          ),
          messageEventHandlers: TencentCloudChatMessageEventHandlers(
            uiEventHandlers: TencentCloudChatMessageUIEventHandlers(onTapLink: ({required String link}) {
              TencentCloudChatUtils.launchLink(link: "https://comm.qq.com/link_page/flutte_uikit_2.html?target=$link");
              return true;
            }),
          ),
        ),
      ),
      callbacks: TencentCloudChatCallbacks(
        onTencentCloudChatSDKEvent: V2TimSDKListener(
          onKickedOffline: _resetSampleApp,
          onUserSigExpired: _resetSampleApp,
        ),
        onTencentCloudChatSDKFailedCallback: (apiName, code, desc) {},
        onTencentCloudChatUIKitUserNotificationEvent: (TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event) {
          switch (event.eventCode) {
            default:
              TencentCloudChatDialog.showAdaptiveDialog(
                context: context,
                content: Text(event.text),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(tL10n.confirm),
                  ),
                ],
              );
          }
        },
      ),
      plugins: [
        TencentCloudChatPluginItem(
          name: "textTranslate",
          pluginInstance: TencentCloudChatTextTranslate(
            onTranslateFailed: () {
              // ZLog.feature(data: "text_translate_failed");
            },
            onTranslateSuccess: (localCustomData) {
              // ZLog.feature(data: "text_translate_success");
            },
          ),
        ),
        TencentCloudChatPluginItem(
          name: "soundToText",
          pluginInstance: TencentCloudChatSoundToText()
        ),
        TencentCloudChatPluginItem(
          name: "messageReaction",
          pluginInstance: TencentCloudChatMessageReaction(
            context: context,
          ),
        ),
        TencentCloudChatPluginItem(
          name: "sticker",
          initData: TencentCloudChatStickerInitData(
            userID: loginInfo.userID,
          ).toJson(),
          pluginInstance: TencentCloudChatStickerPlugin(
            context: context,
          ),
        ),
      ],
    );

    setState(() {
      isLogin = true;
    });

    _initPush();
  }

  void _resetSampleApp({
    bool shouldLogout = false,
  }) async {
    await TencentCloudChat.controller.resetUIKit(
      shouldLogout: shouldLogout,
    );
    safeSetState(() {
      isLogin = false;
    });
  }

  void _onNotificationClicked({required String ext, String? userID, String? groupID}) {
    debugPrint("_onNotificationClicked: $ext, userID: $userID, groupID: $groupID");
    if (TencentCloudChatUtils.checkString(userID) != null || TencentCloudChatUtils.checkString(groupID) != null) {
      navigateToMessage(
        context: context,
        options: TencentCloudChatMessageOptions(
          userID: TencentCloudChatUtils.checkString(userID),
          groupID: TencentCloudChatUtils.checkString(groupID),
        ),
      );
    }
  }

  void _initPush() async {
    final TencentCloudChatPush tencentCloudChatPush = TencentCloudChatPush();
    tencentCloudChatPush.registerPush(
      onNotificationClicked: _onNotificationClicked,
      apnsCertificateID: 40628,
    );
  }

  @override
  void initState() {
    super.initState();
    ToastUtils.init(context);
    currentIndex = 0;
    pages = [
      const TencentCloudChatConversation(),
      const TencentCloudChatContact(),
      TencentCloudChatSettings(
        onLogOut: () => _resetSampleApp(
          shouldLogout: true,
        ),
      ),
    ];

    // Future.delayed(const Duration(milliseconds: 10), _initTencentCloudChat);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    FlutterNativeSplash.remove();
    if (!isLogin) {
      return LoginPage(generateLoginInfo: _generateLoginInfo);
    }
    return TencentCloudChatDemoDesktopAppLayout(
      key: desktopAppLayoutKey,
      onLogOut: () => _resetSampleApp(
        shouldLogout: true,
      ),
    );
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    FlutterNativeSplash.remove();
    if (!isLogin) {
      return LoginPage(generateLoginInfo: _generateLoginInfo);
    }
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: (index) async {
                  if (index != currentIndex) {
                    setState(
                      () {
                        currentIndex = index;
                      },
                    );
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.chat_bubble_outline),
                        Positioned(
                          top: -5,
                          right: -10,
                          child: TencentCloudChatConversationTotalUnreadCount(
                            builder: (BuildContext _, int totalUnreadCount) {
                              if (totalUnreadCount == 0) {
                                return Container();
                              }
                              return UnconstrainedBox(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "$totalUnreadCount",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colorTheme.appBarBackgroundColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    label: tL10n.chats,
                  ),
                  BottomNavigationBarItem(icon: const Icon(Icons.contacts), label: tL10n.contacts),
                  BottomNavigationBarItem(icon: const Icon(Icons.settings), label: tL10n.settings),
                ],
              ),
              body: pages[currentIndex],
            ));
  }
}

class MyHomePageData {
  final String title;

  MyHomePageData({required this.title});

  Map<String, dynamic> toMap() {
    return {'title': title};
  }

  static MyHomePageData fromMap(Map<String, dynamic> map) {
    return MyHomePageData(title: map['title'] as String);
  }
}
