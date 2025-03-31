// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat_common.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_setting_choose_avatar.dart';
import 'package:tencent_cloud_chat_demo/setting/widgets/tencent_cloud_chat_setting_leading.dart';

class TencentCloudChatSettingsSetInfo extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingsSetInfo({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsSetInfoState();
}

class TencentCloudChatSettingsSetInfoState extends TencentCloudChatState<TencentCloudChatSettingsSetInfo> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              appBar: AppBar(
                leadingWidth: getWidth(100),
                leading: const TencentCloudChatSettingLeading(),
                title: Text(
                  tL10n.profile,
                  style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w600, color: colorTheme.settingTitleColor),
                ),
                centerTitle: true,
                backgroundColor: colorTheme.settingBackgroundColor,
              ),
              body: Container(
                color: colorTheme.settingInfoBackgroundColor,
                padding: EdgeInsets.only(top: getHeight(16)),
                child:
                  Column(children: [
                    TencentCloudChatSettingsSetInfoAvatar(userFullInfo: widget.userFullInfo),
                    TencentCloudChatSettingsSetInfoName(userFullInfo: widget.userFullInfo),
                    TencentCloudChatSettingSetInfoUserID(userFullInfo: widget.userFullInfo),
                    TencentCloudChatSettingsSetInfoInfo(userFullInfo: widget.userFullInfo,
                    )
                  ]),
              ),
            ));
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Material(
        child: Container(
          color: colorTheme.settingInfoBackgroundColor,
          // padding: EdgeInsets.only(top: getHeight(16)),
          child: Center(
            child: Column(children: [
              TencentCloudChatSettingsSetInfoAvatar(userFullInfo: widget.userFullInfo),
              TencentCloudChatSettingsSetInfoName(userFullInfo: widget.userFullInfo),
              TencentCloudChatSettingSetInfoUserID(userFullInfo: widget.userFullInfo),
              TencentCloudChatSettingsSetInfoInfo(
                userFullInfo: widget.userFullInfo,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class TencentCloudChatSettingsSetInfoAvatar extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingsSetInfoAvatar({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsSetInfoAvatarState();
}

class TencentCloudChatSettingsSetInfoAvatarState extends TencentCloudChatState<TencentCloudChatSettingsSetInfoAvatar> {
  String? image = "";

  @override
  void initState() {
    super.initState();
    image = widget.userFullInfo.faceUrl;
  }

  void _pickAvatar() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TencentCloudChatSettingChooseAvatar(
          selectedAvatarUrl: widget.userFullInfo.faceUrl ?? '',
        )
      )
    );

    if (result != null) {
      setState(() {
        widget.userFullInfo.faceUrl = result as String;
        image = widget.userFullInfo.faceUrl;
      });
    }
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: getHeight(16)),
        padding: EdgeInsets.only( top: getHeight(12)),
        color: colorTheme.settingBackgroundColor,
        child:
          Column(
            children: [
              TencentCloudChatAvatar(
                scene: TencentCloudChatAvatarScene.custom,
                imageList: [image],
                width: getSquareSize(90),
                height: getSquareSize(90),
                borderRadius: getSquareSize(45),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: textStyle.fontsize_16, color: colorTheme.settingInfoEditColor),
                ),
                onPressed: _pickAvatar,
                child: Text(tL10n.edit),
              )
            ],
          ),
      ),
    );
  }

  @override
  Widget desktopBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: getHeight(1)),
        padding: EdgeInsets.only(left: getWidth(16), top: getHeight(12)),
        color: colorTheme.settingBackgroundColor,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TencentCloudChatAvatar(
                  scene: TencentCloudChatAvatarScene.custom,
                  imageList: [image],
                  width: getSquareSize(40),
                  height: getSquareSize(40),
                  borderRadius: getSquareSize(4),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: textStyle.fontsize_16, color: colorTheme.settingInfoEditColor),
                  ),
                  onPressed: _pickAvatar,
                  child: Text(tL10n.edit),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TencentCloudChatSettingsSetInfoName extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingsSetInfoName({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsSetInfoNameState();
}

class TencentCloudChatSettingsSetInfoNameState extends TencentCloudChatState<TencentCloudChatSettingsSetInfoName> {
  final TextEditingController _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    _controller.text = widget.userFullInfo.nickName ?? "";
  }

  onChangeUserNickname() {
    final TextEditingController dialogTextEditingController = TextEditingController();
    dialogTextEditingController.text = _controller.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tL10n.setNickname),
          content: TextField(
            controller: dialogTextEditingController,
            // onChanged: (value) {
            //   modifyNickname = value;
            // },
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(tL10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(tL10n.confirm),
              onPressed: () async {
                var result = await TencentCloudChat.instance.chatSDKInstance.setSelfInfo(nickName: dialogTextEditingController.text);
                if (result.code == 0) {
                  _controller.text = dialogTextEditingController.text;
                }

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => GestureDetector(
            onTap: onChangeUserNickname,
            child: Container(
                transformAlignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
                color: colorTheme.settingBackgroundColor,
                child: AbsorbPointer(
                  child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: tL10n.setNickname,
                        hintStyle: TextStyle(
                          color: colorTheme.secondaryTextColor,
                          fontSize: textStyle.fontsize_16,
                        ),
                        border: const OutlineInputBorder(borderSide: BorderSide.none,),
                      ),
                      readOnly: true,
                      style: TextStyle(color: colorTheme.settingTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center
                  )
                )
            )
        )
    );
  }
}

class TencentCloudChatSettingSetInfoUserID extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingSetInfoUserID({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingSetInfoUserIDState();
}

class TencentCloudChatSettingSetInfoUserIDState extends TencentCloudChatState<TencentCloudChatSettingSetInfoUserID> {
  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Container(
              margin: EdgeInsets.only(top: getHeight(16), bottom: getHeight(20)),
              padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(12)),
              color: colorTheme.settingBackgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: Text(tL10n.userID, style: TextStyle(color: colorTheme.settingTabTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400)),
                  ),
                  Text(widget.userFullInfo.userID ?? "", style: TextStyle(color: colorTheme.settingTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400))
                ],
              ),
            ));
  }
}

class TencentCloudChatSettingsSetInfoInfo extends StatefulWidget {
  final V2TimUserFullInfo userFullInfo;

  const TencentCloudChatSettingsSetInfoInfo({super.key, required this.userFullInfo});

  @override
  State<StatefulWidget> createState() => TencentCloudChatSettingsSetInfoInfoState();
}

class TencentCloudChatSettingsSetInfoInfoState extends TencentCloudChatState<TencentCloudChatSettingsSetInfoInfo> {
  static List<String> gender = [tL10n.unknown, tL10n.male, tL10n.female];
  String genderValue = gender.first;
  String signature = "";
  DateTime currentTime = DateTime.now();
  String birthdayState = tL10n.unknown;

  @override
  initState() {
    super.initState();

    signature = widget.userFullInfo.selfSignature ?? "";
    if (widget.userFullInfo.gender != null) {
      genderValue = gender[widget.userFullInfo.gender ?? 0];
    }
    if (widget.userFullInfo.birthday != null && widget.userFullInfo.birthday! >= 19700101) {
      currentTime = DateTime.parse(widget.userFullInfo.birthday.toString());
    }
    birthdayState = _getBirthday();
  }

  onGenderChanged(String value) {
    int genderValue = gender.indexOf(value);
    TencentCloudChat.instance.chatSDKInstance.setSelfInfo(gender: genderValue);
  }

  showDateTimePicker() {
    DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(1970, 1, 1), maxTime: DateTime(2060, 12, 31), onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        birthdayState = "${date.year}-${date.month}-${date.day}";
      });
      int birthday = date.year * 10000 + date.month * 100 + date.day;
      TencentCloudChat.instance.chatSDKInstance.setSelfInfo(birthday: birthday);
    }, currentTime: currentTime, locale: LocaleType.en);
  }

  _getBirthday() {
    String birthday = tL10n.unknown;
    if (widget.userFullInfo.birthday != null) {
      if (widget.userFullInfo.birthday! >= 19700101) {
        DateTime dateTime = DateTime.parse(widget.userFullInfo.birthday.toString());
        birthday = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      }
    }
    return birthday;
  }

  onChangeSignature() {
    String mid = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tL10n.setSignature),
          content: TextField(
            onChanged: (value) {
              mid = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(tL10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(tL10n.confirm),
              onPressed: () {
                safeSetState(() {
                  signature = mid;
                });
                TencentCloudChat.instance.chatSDKInstance.setSelfInfo(signature: signature);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget defaultBuilder(BuildContext context) {
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Column(
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: getHeight(1)),
                    padding: EdgeInsets.symmetric(horizontal: getWidth(14), vertical: getHeight(12)),
                    color: colorTheme.settingBackgroundColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(tL10n.signature, style: TextStyle(color: colorTheme.settingTabTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400)),
                        ),
                        GestureDetector(
                          onTap: onChangeSignature,
                          child: Row(children: [
                            Text(signature, style: TextStyle(color: colorTheme.settingTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400)),
                            SizedBox(
                              width: getWidth(8),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: getSquareSize(12),
                              color: colorTheme.settingTitleColor,
                            )
                          ]),
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: getHeight(1)),
                    padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(12)),
                    color: colorTheme.settingBackgroundColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(tL10n.gender, style: TextStyle(color: colorTheme.settingTabTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400)),
                        ),
                        DropdownButton<String>(
                          alignment: Alignment.centerRight,
                          value: genderValue,
                          icon: Container(
                            margin: EdgeInsets.only(left: getWidth(8)),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: getSquareSize(12),
                            ),
                          ),
                          style: TextStyle(fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400, color: colorTheme.contactItemFriendNameColor),
                          elevation: 16,
                          underline: Container(),
                          isDense: true,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            safeSetState(() {
                              genderValue = value!;
                              onGenderChanged(value);
                            });
                          },
                          items: gender.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(16), vertical: getHeight(12)),
                    color: colorTheme.settingBackgroundColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(tL10n.birthday, style: TextStyle(color: colorTheme.settingTabTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400)),
                        ),
                        GestureDetector(
                          onTap: showDateTimePicker,
                          child: Row(children: [
                            Text(birthdayState, style: TextStyle(color: colorTheme.settingTitleColor, fontSize: textStyle.fontsize_16, fontWeight: FontWeight.w400)),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: getSquareSize(12),
                              color: colorTheme.settingTitleColor,
                            )
                          ]),
                        )
                      ],
                    )),
              ],
            ));
  }
}

class TencentCloudChatSettingsSetInfoData {
  final V2TimUserFullInfo userFullInfo;

  TencentCloudChatSettingsSetInfoData({required this.userFullInfo});

  Map<String, dynamic> toMap() {
    return {'blockList': userFullInfo.toString()};
  }

  static TencentCloudChatSettingsSetInfoData fromMap(Map<String, dynamic> map) {
    return TencentCloudChatSettingsSetInfoData(userFullInfo: map['userFullInfo'] as V2TimUserFullInfo);
  }
}

// class TencentCloudChatSettingsSetInfoInstance {
//   TencentCloudChatSettingsSetInfoInstance._internal();
//   factory TencentCloudChatSettingsSetInfoInstance() => _instance;
//   static final TencentCloudChatSettingsSetInfoInstance _instance =
//       TencentCloudChatSettingsSetInfoInstance._internal();
//   static TencentCloudChatComponentsEnum register() {
//     TencentCloudChatRouter().registerRouter(
//         routeName: TencentCloudChatRouteNames.settingsInfo,
//         builder: (context) => TencentCloudChatSettingsSetInfo(
//             userFullInfo: TencentCloudChatRouter()
//                 .getArgumentFromMap<TencentCloudChatSettingsSetInfoData>(
//                     context, 'options')!
//                 .userFullInfo));
//     return TencentCloudChatComponentsEnum.settingsInfo;
//   }
// }
