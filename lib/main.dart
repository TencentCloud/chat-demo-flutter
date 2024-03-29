import 'dart:convert';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:tencent_cloud_chat/components/component_config/tencent_cloud_chat_user_config.dart';
import 'package:tencent_cloud_chat/components/components_options/tencent_cloud_chat_message_options.dart';
import 'package:tencent_cloud_chat/components/tencent_cloud_chat_components_utils.dart';
import 'package:tencent_cloud_chat/cross_platforms_adapter/tencent_cloud_chat_screen_adapter.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_callbacks.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_init_data_config.dart';
import 'package:tencent_cloud_chat/models/tencent_cloud_chat_models.dart';
import 'package:tencent_cloud_chat/router/tencent_cloud_chat_navigator.dart';
import 'package:tencent_cloud_chat/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_code_info.dart';
import 'package:tencent_cloud_chat/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat/widget/app/material_app.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_contact/tencent_cloud_chat_contact.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation.dart';
import 'package:tencent_cloud_chat_conversation/tencent_cloud_chat_conversation_tatal_unread_count.dart';
import 'package:tencent_cloud_chat_demo/config.dart';
import 'package:tencent_cloud_chat_demo/desktop/app_layout.dart';
import 'package:tencent_cloud_chat_demo/login/login.dart';
import 'package:tencent_cloud_chat_demo/setting/tencent_cloud_chat_settings.dart';
import 'package:tencent_cloud_chat_demo/vote_detail_example.dart';
import 'package:tencent_cloud_chat_group_profile/tencent_cloud_chat_group_profile.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';
import 'package:tencent_cloud_chat_robot/tencent_cloud_chat_robot.dart';
import 'package:tencent_cloud_chat_user_profile/tencent_cloud_chat_user_profile.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

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
    FlutterNativeSplash.remove();
    return TencentCloudChatMaterialApp(
      title: 'Tencent Cloud Chat',
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

  String sdkappid = IMConfig.sdkappid;
  String userid = IMConfig.userid;
  String usersig = IMConfig.usersig;
  bool isInit = false;
  bool isLogin = false;
  bool isFirstTimeUser = false;
  String appId = "";

  changeLoginState(bool loginState) {
    safeSetState(() {
      currentIndex = 0;
      isLogin = loginState;
    });
    if (loginState == true) {
      initTencentCloudChat();
    }
  }

  initTencentCloudChat() async {
    if (isInit) {
      return;
    }

    TencentCloudChatPush().registerOnNotificationClickedEvent(onNotificationClicked: _onNotificationClicked);

    debugPrint("initTencentCloudChatConfig, ${IMConfig.sdkappid},${IMConfig.userid},${IMConfig.usersig}");
    if (IMConfig.sdkappid.isEmpty || IMConfig.userid.isEmpty || IMConfig.usersig.isEmpty) {
      debugPrint("Please specify `sdkappid`, `userid` and `usersig` in the `tencent_cloud_chat_demo/lib/config.dart` file before using this sample app.");
      return;
    }
    isInit = true;

    TencentCloudChatPush().setApnsCertificateID(apnsCertificateID: 40628);

    TencentCloudChatPush().registerOnAppWakeUpEvent(onAppWakeUpEvent: () {});

    await TencentCloudChat.controller.initUIKit(
      context: context,
      config: TencentCloudChatConfig(
        usedComponentsRegister: [
          TencentCloudChatConversationInstance.register,
          TencentCloudChatMessageInstance.register,
          TencentCloudChatUserProfileInstance.register,
          TencentCloudChatGroupProfileInstance.register,
          TencentCloudChatContactInstance.register,
        ],
        preloadDataConfig: TencentCloudChatInitDataConfig(
          getConversationDataAfterInit: true,
        ),
        userConfig: TencentCloudChatUserConfig(
          useUserOnlineStatus: true,
          autoDownloadMultimediaMessage: true,
        ),
      ),
      options: TencentCloudChatInitOptions(
        sdkAppID: int.parse(IMConfig.sdkappid),
        userID: IMConfig.userid,
        userSig: IMConfig.usersig,
        sdkListener: V2TimSDKListener(
          onKickedOffline: _resetUIKit,
          onUserSigExpired: _resetUIKit,
          onUIKitEventEmited: (event) {
            final type = event.type;
            switch (type) {
              case "navigateToChat":
                final isDesktopScreen = TencentCloudChatScreenAdapter.deviceScreenType == DeviceScreenType.desktop;
                if (isDesktopScreen) {
                  desktopAppLayoutKey.currentState?.navigateToChat(
                    groupID: event.detail["groupID"],
                    userID: event.detail["userID"],
                  );
                }
                break;

              default:
                break;
            }
          },
        ),
      ),
      callbacks: TencentCloudChatCallbacks(
        onTencentCloudChatSDKFailedCallback: (apiName, code, desc) {},
        onTencentCloudChatUIKitUserNotificationEvent: (TencentCloudChatComponentsEnum component, TencentCloudChatUserNotificationEvent event) {
          switch (event.eventCode) {
            case -10301:
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
            default:
              TDToast.showText(event.text, context: context);
          }
        },
      ),
      plugins: [
        TencentCloudChatPluginItem(
          name: "poll",
          pluginInstance: TencentCloudChatVotePlugin(),
          tapFn: (data) {
            var optionStr = data["option"];
            var dataStr = data["data"];
            if (optionStr == null) {
              return false;
            }
            if (dataStr == null) {
              return false;
            }
            var option = TencentCloudChatVoteDataOptoin.fromJson(json.decode(optionStr));
            var message = TencentCloudChatVoteLogic(message: V2TimMessage.fromJson(json.decode(dataStr)));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoteDetailExample(
                  option: option,
                  data: message,
                ),
              ),
            );
            return true;
          },
        ),
        TencentCloudChatPluginItem(
          name: "robot",
          pluginInstance: TencentCloudChatRobotPlugin(),
        )
      ],
    );

    _initPush();
    _initCallkit();

    safeSetState(() {
      isLogin = true;
    });
  }

  _initCallkit() async {
    final TUICallKit callKit = TUICallKit.instance;
    callKit.enableFloatWindow(true);
    callKit.login(
      int.parse(IMConfig.sdkappid),
      IMConfig.userid,
      IMConfig.usersig,
    );
  }

  void _resetUIKit() {
    TencentCloudChat.controller.resetUIKit();
    safeSetState(() {
      isInit = false;
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
    tencentCloudChatPush.registerPush(onNotificationClicked: _onNotificationClicked);
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    // eventbus.on<TencentCloudChatBasicData<TencentCloudChatBasicDataKeys>>()?.listen((event) {});
    pages = [
      const TencentCloudChatConversation(),
      const TencentCloudChatContact(),
      TencentCloudChatSettings(
        removeSettings: () {},
        setLoginState: changeLoginState,
      ),
    ];

    Future.delayed(const Duration(milliseconds: 10), initTencentCloudChat);
  }

  void getConversation(BuildContext context) {
    navigateToConversation(context: context);
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    TencentCloudChatIntl().init(context);
    if (!isLogin) {
      debugPrint("Not login");
      return const LoginPage();
    }

    return Material(
      color: Colors.transparent,
      child: TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
          color: colorTheme.backgroundColor,
          child: Center(
            child: Text(
              tL10n.tencentCloudChat,
              style: TextStyle(color: colorTheme.primaryColor, fontSize: textStyle.fontsize_20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    TencentCloudChatIntl().init(context);
    if (!isLogin) {
      debugPrint("Not login");
      return const LoginPage();
    }
    return TencentCloudChatDemoDesktopAppLayout(
      key: desktopAppLayoutKey,
      removeSettings: () {},
      setLoginState: changeLoginState,
    );
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    TencentCloudChatIntl().init(context);
    if (!isLogin) {
      debugPrint("Not login");
      return const LoginPage();
    }
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: (index) async {
                  // final res = await TencentCloudChatPush().getAndroidPushToken();
                  // print(res.data);
                  // print(res.data);

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
