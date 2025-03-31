import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/operation_key.dart';
import 'package:tencent_cloud_chat_common/widgets/desktop_popup/tencent_cloud_chat_desktop_popup.dart';
import 'package:tencent_cloud_chat_common/widgets/dialog/tencent_cloud_chat_dialog.dart';
import 'package:tencent_cloud_chat_demo/desktop/tencent_specific/about_us.dart';
import 'package:tencent_cloud_chat_demo/desktop/tencent_specific/contact_us.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_setting_cancel_account.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_setting_contact.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_setting_leading.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_setting_privacy.dart';
import 'package:url_launcher/url_launcher.dart';

class TencentCloudChatSettingsAbout extends StatefulWidget {
  const TencentCloudChatSettingsAbout({super.key});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsAboutState();
}

class TencentCloudChatSettingsAboutState
    extends TencentCloudChatState<TencentCloudChatSettingsAbout> {
  bool isInternational =
      const bool.fromEnvironment("international", defaultValue: false);
  String privacyUrl = "";

  @override
  void initState() {
    super.initState();
    privacyUrl = isInternational
        ? "https://www.tencentcloud.com/document/product/1047/45408?lang=en&pg="
        : "https://privacy.qq.com/document/preview/1cfe904fb7004b8ab1193a55857f7272";
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        color: colorTheme.backgroundColor,
        child: Container(
          color: colorTheme.settingBackgroundColor,
          child: Column(
            children: [
              const TencentCloudChatSettingsAboutBody(),
              TencentCloudChatSettingsAboutTab(
                title: tL10n.privacyPolicy,
                onTap: () => {
                  launchUrl(
                    Uri.parse(privacyUrl),
                    mode: LaunchMode.externalApplication,
                  )
                },
              ),
              TencentCloudChatSettingsAboutTab(
                title: tL10n.userAgreement,
                onTap: () => {
                  launchUrl(
                    Uri.parse(
                        "https://web.sdk.qcloud.com/document/Tencent-IM-User-Agreement.html"),
                    mode: LaunchMode.externalApplication,
                  )
                },
              ),
              TencentCloudChatSettingsAboutTab(
                  title: tL10n.disclaimer,
                  onTap: () => {
                        TencentCloudChatDialog.showAdaptiveDialog(
                          context: context,
                          title: Text(tL10n.disclaimer),
                          content: const Text(
                              "Tencent Cloud Chat APP ('this product') is a sample app provided by Tencent Cloud. Tencent Cloud owns the copyright and ownership of this product. This product is for functional experience only and may not be used for any commercial purposes. It is strictly prohibited to spread any pornographic, abusive, violent, terrorist, political-related and other illegal content during use."),
                          actions: <Widget>[
                            TextButton(
                              child: Text(tL10n.cancel),
                              onPressed: () =>
                                  Navigator.of(context).pop(), // 关闭对话框
                            ),
                            TextButton(
                              child: Text(tL10n.confirm),
                              onPressed: () {
                                //关闭对话框并返回true
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        )
                      }),
              // TencentCloudChatSettingsAboutTab(
              //   title: tL10n.deleteAccount,
              //   onTap: () => {
              //     TencentCloudChatDesktopPopup.showPopupWindow(
              //       title: tL10n.deleteAccount,
              //       width: MediaQuery.of(context).size.width * 0.6,
              //       height: MediaQuery.of(context).size.height * 0.6,
              //       operationKey: TencentCloudChatPopupOperationKey.custom,
              //       context: context,
              //       child: (_) => const TencentCloudChatSettingCancelAccount(),
              //     )
              //   },
              // ),
              TencentCloudChatSettingsAboutTab(
                title: tL10n.aboutTencentCloudChat,
                onTap: () => {
                  TencentCloudChatDesktopPopup.showPopupWindow(
                    title: tL10n.aboutTencentCloudChat,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.6,
                    operationKey: TencentCloudChatPopupOperationKey.custom,
                    context: context,
                    child: (closeFunc) => DesktopAboutUs(closeFunc: closeFunc),
                  )
                },
              ),
              TencentCloudChatSettingsAboutTab(
                title: tL10n.contactUs,
                onTap: () => {
                  TencentCloudChatDesktopPopup.showPopupWindow(
                    title: tL10n.contactUs,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.6,
                    operationKey: TencentCloudChatPopupOperationKey.custom,
                    context: context,
                    child: (closeFunc) =>
                        DesktopContactUs(closeFunc: closeFunc),
                  )
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    final locale = TencentCloudChatIntl().getCurrentLocale(context);
    final isChinese = locale.languageCode == "zh";

    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              appBar: AppBar(
                leadingWidth: getWidth(100),
                leading: const TencentCloudChatSettingLeading(),
                backgroundColor: colorTheme.settingBackgroundColor,
              ),
              body: Container(
                color: colorTheme.settingBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const TencentCloudChatSettingsAboutBody(),
                          TencentCloudChatSettingsAboutTab(
                            title: tL10n.privacyPolicy,
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TencentCloudChatSettingPrivacy(
                                            title: tL10n.privacyPolicy,
                                            url: privacyUrl)),
                              )
                            },
                          ),
                          TencentCloudChatSettingsAboutTab(
                            title: tL10n.userAgreement,
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TencentCloudChatSettingPrivacy(
                                            title: tL10n.userAgreement,
                                            url:
                                                "https://web.sdk.qcloud.com/document/Tencent-IM-User-Agreement.html")),
                              )
                            },
                          ),
                          TencentCloudChatSettingsAboutTab(
                              title: tL10n.disclaimer,
                              onTap: () => {
                                    TencentCloudChatDialog.showAdaptiveDialog(
                                      context: context,
                                      title: Text(tL10n.disclaimer),
                                      content: const Text(
                                          "Tencent Cloud Chat APP ('this product') is a sample app provided by Tencent Cloud. Tencent Cloud owns the copyright and ownership of this product. This product is for functional experience only and may not be used for any commercial purposes. It is strictly prohibited to spread any pornographic, abusive, violent, terrorist, political-related and other illegal content during use."),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(tL10n.cancel),
                                          onPressed: () => Navigator.of(context)
                                              .pop(), // 关闭对话框
                                        ),
                                        TextButton(
                                          child: Text(tL10n.confirm),
                                          onPressed: () {
                                            //关闭对话框并返回true
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    )
                                  }),
                          // TencentCloudChatSettingsAboutTab(
                          //   title: tL10n.deleteAccount,
                          //   onTap: () => {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               const TencentCloudChatSettingCancelAccount()),
                          //     )
                          //   },
                          // ),
                          TencentCloudChatSettingsAboutTab(
                            title: tL10n.contactUs,
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TencentCloudChatSettingContact()),
                              )
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          if (isChinese)
                            GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri.parse("https://beian.miit.gov.cn"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Text(
                                "ICP备案号: 粤B2-20090059-2674A",
                                style: TextStyle(
                                  fontSize: textStyle.fontsize_14,
                                  color: colorTheme.secondaryTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (isChinese)
                            const SizedBox(
                              height: 6,
                            ),
                          if (isChinese)
                            Text(
                              "腾讯公司 版权所有",
                              style: TextStyle(
                                fontSize: textStyle.fontsize_14,
                                color: colorTheme.secondaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (isChinese)
                            const SizedBox(
                              height: 6,
                            ),
                          Text(
                            "Copyright © 2011-2024 Tencent. All Rights Reserved.",
                            style: TextStyle(
                              fontSize: textStyle.fontsize_13,
                              color: colorTheme.secondaryTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}

class TencentCloudChatSettingsAboutBody extends StatefulWidget {
  const TencentCloudChatSettingsAboutBody({super.key});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatSettingsAboutBodyState();
}

class TencentCloudChatSettingsAboutBodyState
    extends TencentCloudChatState<TencentCloudChatSettingsAboutBody> {
  String version = TencentCloudChat.instance.dataInstance.basic.version;

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(16), vertical: getHeight(12)),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: colorTheme.settingAboutBorderColor)),
                      color: colorTheme.settingTabBackgroundColor),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(tL10n.sdkVersion,
                            style: TextStyle(
                                color: colorTheme.settingTabTitleColor,
                                fontSize: textStyle.fontsize_16,
                                fontWeight: FontWeight.w400)),
                      ),
                      Text(version,
                          style: TextStyle(
                              color: colorTheme.settingTitleColor,
                              fontSize: textStyle.fontsize_16,
                              fontWeight: FontWeight.w400))
                    ],
                  ),
                )
              ],
            ));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(16), vertical: getHeight(12)),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: colorTheme.settingAboutBorderColor)),
                      color: colorTheme.settingTabBackgroundColor),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(tL10n.sdkVersion,
                            style: TextStyle(
                                color: colorTheme.secondaryTextColor,
                                fontSize: textStyle.fontsize_14)),
                      ),
                      Text(version,
                          style: TextStyle(
                              color: colorTheme.primaryTextColor,
                              fontSize: textStyle.fontsize_14,
                              fontWeight: FontWeight.w400))
                    ],
                  ),
                )
              ],
            ));
  }
}

class TencentCloudChatSettingsAboutTab extends StatefulWidget {
  final String title;
  final Function onTap;

  const TencentCloudChatSettingsAboutTab(
      {super.key, required this.title, required this.onTap});

  @override
  State<StatefulWidget> createState() =>
      TencentCloudChatSettingsAboutTabState();
}

class TencentCloudChatSettingsAboutTabState
    extends TencentCloudChatState<TencentCloudChatSettingsAboutTab> {
  _onClicked() {
    widget.onTap();
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => GestureDetector(
              onTap: _onClicked,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: getWidth(16), vertical: getHeight(12)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: colorTheme.settingAboutBorderColor)),
                    color: colorTheme.settingTabBackgroundColor),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: textStyle.fontsize_16,
                        color: colorTheme.settingTabTitleColor),
                  )),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: getSquareSize(12),
                    color: colorTheme.settingTabTitleColor,
                  )
                ]),
              ),
            ));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Material(
              color: colorTheme.settingTabBackgroundColor,
              child: InkWell(
                onTap: _onClicked,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(16), vertical: getHeight(12)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: colorTheme.settingAboutBorderColor),
                    ),
                  ),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: textStyle.fontsize_14,
                          color: colorTheme.secondaryTextColor),
                    )),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: getSquareSize(12),
                      color: colorTheme.secondaryTextColor,
                    )
                  ]),
                ),
              ),
            ));
  }
}
