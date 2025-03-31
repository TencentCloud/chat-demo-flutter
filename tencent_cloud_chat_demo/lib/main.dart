import 'dart:convert';
import 'dart:io';

import 'package:desktop_webview_window_for_is/desktop_webview_window_for_is.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tencent_calls_uikit/tuicall_kit.dart';
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
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_tatal_unread_count.dart';
import 'package:tencent_cloud_chat_demo/desktop/app_layout.dart';
import 'package:tencent_cloud_chat_demo/launching_page.dart';
import 'package:tencent_cloud_chat_demo/setting/tencent_cloud_chat_settings.dart';
import 'package:tencent_cloud_chat_demo/widgets/toast_utils.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_builders.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/special_case/tencent_cloud_chat_message_no_chat.dart';
import 'package:tencent_cloud_chat_message_reaction/tencent_cloud_chat_message_reaction.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';
import 'package:tencent_cloud_chat_search/tencent_cloud_chat_search.dart';
import 'package:tencent_cloud_chat_sound_to_text/tencent_cloud_chat_sound_to_text.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker.dart';
import 'package:tencent_cloud_chat_sticker/tencent_cloud_chat_sticker_init_data.dart';
import 'package:tencent_cloud_chat_text_translate/tencent_cloud_chat_text_translate.dart';

void main(List<String> args) {
  debugPrint('args: $args');
  if (runWebViewTitleBarWidget(args)) {
    return;
  }

  if (kIsWeb || Platform.isMacOS || Platform.isWindows) {
    runApp(const MyApp());
  } else {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // TencentCloudChatPush().forceUseFCMPushChannel(enable: true);
    TencentCloudChatPush().registerOnAppWakeUpEvent(onAppWakeUpEvent: () async {
      // debugPrint('onAppWakeUpEvent onAppWakeUpEvent');
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // final userID = prefs.getString(LoginPage.DEV_LOGIN_USER_ID);
      // final userSig = prefs.getString(LoginPage.DEV_LOGIN_USER_SIG);
      // TUICallKit.instance.login(
      //   TencentCloudChatLoginData.sdkAppID,
      //   userID ?? "",
      //   userSig ?? "",
      // );
    });


    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatMaterialApp(
      title: 'Tencent Cloud Chat',
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      // navigatorObservers: [TUICallKit.navigatorObserver],
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

  _changeLoginState(bool loginState) {
    safeSetState(() {
      currentIndex = 0;
      isLogin = loginState;
    });

    if (loginState == true) {
      _initTencentCloudChat();
    }
  }

  _initTencentCloudChat() async {
    if (TencentCloudChatLoginData.sdkAppID == 0 ||
        TencentCloudChatLoginData.userID.isEmpty ||
        TencentCloudChatLoginData.userSig.isEmpty) {
      debugPrint("Please enter the correct sdkappid, userid and usersig in the environment variables.");
      return;
    }

    final bool initRes = await TencentCloudChat.controller.initUIKit(
      config: TencentCloudChatConfig(
        userConfig: TencentCloudChatUserConfig(
          useUserOnlineStatus: true,
          autoDownloadMultimediaMessage: true,
        ),
      ),
      options: TencentCloudChatInitOptions(
        sdkAppID: TencentCloudChatLoginData.sdkAppID,
        userID: TencentCloudChatLoginData.userID,
        userSig: TencentCloudChatLoginData.userSig,
      ),
      components: TencentCloudChatInitComponentsRelated(
        usedComponentsRegister: [
          TencentCloudChatConversationManager.register,
          TencentCloudChatMessageManager.register,
          TencentCloudChatContactManager.register,
          TencentCloudChatSearchManager.register,
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
            enabledGroupTypesForMessageReadReceipt: ({String? groupID, String? userID, String? topicID}) =>
                [GroupType.Work, GroupType.Public, GroupType.Meeting],
          ),
        ),
        componentBuilders: TencentCloudChatComponentBuilders(
          /// You can provide your custom UI builders for each UI modular component here.
          /// These builders will be applied globally.
          /// If you prefer to use the default builders, you can leave this section empty.
          ///
          /// Example: For the Message component, config them as follows:
          messageBuilder:
              TencentCloudChatMessageBuilders(messageNoChatBuilder: () => const TencentCloudChatMessageNoChat()),
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
          onKickedOffline: () {
            ToastUtils.toast(tL10n.kickedOffTips);
            _resetSampleApp();
          },
          onUserSigExpired: () {
            ToastUtils.toast(tL10n.userSigExpiredTips);
            _resetSampleApp();
          },
        ),
        onTencentCloudChatSDKFailedCallback: (apiName, code, desc) {
          if (desc != null && desc.isNotEmpty) {
            ToastUtils.toast(desc);
          }
        },
        onTencentCloudChatUIKitUserNotificationEvent:
            (TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event) {
          ToastUtils.toast(event.text);
        },
      ),
      plugins: [
        TencentCloudChatPluginItem(
          name: "textTranslate",
          pluginInstance: TencentCloudChatTextTranslate(
            onTranslateFailed: () {
              // ZLog.feature(data: "text_translate_failed");
            },
          ),
        ),
        TencentCloudChatPluginItem(name: "soundToText", pluginInstance: TencentCloudChatSoundToText()),
        TencentCloudChatPluginItem(
          name: "messageReaction",
          pluginInstance: TencentCloudChatMessageReaction(
            context: context,
          ),
        ),
        TencentCloudChatPluginItem(
          name: "sticker",
          initData: TencentCloudChatStickerInitData(
            userID: TencentCloudChatLoginData.userID,
          ).toJson(),
          pluginInstance: TencentCloudChatStickerPlugin(
            context: context,
          ),
        ),
      ],
    );

    if (initRes == true) {
      _initPush();
    }
  }

  void _resetSampleApp({
    bool shouldLogout = false,
  }) async {
    await TencentCloudChat.controller.resetUIKit(
      shouldLogout: shouldLogout,
    );
    await TencentCloudChatLoginData.removeLocalSetting();
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
    //tencentCloudChatPush.setPushBrandId(brandID: TencentCloudChatPushBrandID.FCM);
    // TIMPushListener timPushListener = TIMPushListener(
    //       onRecvPushMessage: (TimPushMessage message) {
    //         String messageLog = message.toLogString();
    //         debugPrint(
    //             "message: $messageLog");
    //       },
    //
    //   onRevokePushMessage: (String messageId) {
    //     debugPrint(
    //         "message: $messageId");
    //   },
    //
    //   onNotificationClicked: (String ext) {
    //     debugPrint(
    //         "ext: $ext");
    //   }
    // );
    // tencentCloudChatPush.addPushListener(listener: timPushListener);
    // tencentCloudChatPush.disablePostNotificationInForeground(disable: true);

    tencentCloudChatPush.registerPush(
      onNotificationClicked: _onNotificationClicked,
      apnsCertificateID: 29064,
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
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return Container();
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    FlutterNativeSplash.remove();
    TencentCloudChatIntl().init(context);
    if (!isLogin) {
      return LaunchingPage(
        changeLoginState: (bool isLogin) => _changeLoginState(isLogin),
      );
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
      return LaunchingPage(
        changeLoginState: (bool isLogin) => _changeLoginState(isLogin),
      );
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
