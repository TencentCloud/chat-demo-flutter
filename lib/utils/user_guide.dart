// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';


import 'package:tencent_cloud_chat_demo/src/provider/user_guide_provider.dart';
import 'package:provider/provider.dart';

class UserGuide extends StatefulWidget {
  final String guideName;
  const UserGuide({Key? key, required this.guideName}) : super(key: key);

  @override
  _UserGuideState createState() => _UserGuideState();
}

class _UserGuideState extends State<UserGuide> {
  int _index = 0;
  final guideList = {
    "conversation": 3,
    "search": 1,
    "chat": 3,
    "userProfile": 2,
    "concat": 3,
    "friendProfile": 3,
    "groupProfile": 3
  };

  List<Widget> guideBuilder() {
    List<Widget> guidePictureList = [];
    try{
      final model = Provider.of<UserGuideProvider>(context);
      int builderLength = guideList[widget.guideName] ?? 0;
      String screenType =
      MediaQuery.of(context).size.width > 10000 ? 'large' : 'small';
      final String? deviceLocale =
      WidgetsBinding.instance.window.locale.toLanguageTag();
      final AppLocale appLocale = I18nUtils.findDeviceLocale(deviceLocale);
      String languageType =
      (appLocale == AppLocale.zhHans || appLocale == AppLocale.zhHant)
          ? 'zh'
          : 'en';
      for (int i = 1; i <= builderLength; i++) {
        guidePictureList.add(Positioned.fill(
            child: GestureDetector(
              onTap: (() {
                setState(() {
                  _index++;
                  if (_index == builderLength) {
                    model.guideName = '';
                    _index = 0;
                  }
                });
              }),
              child: Image.asset(
                "assets/user_guide/$screenType/$languageType/${widget.guideName}-$i.png",
                fit: BoxFit.fitHeight,
              ),
            )));
      }
      return guidePictureList;
    }catch(e){
      return guidePictureList;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/user_guide/back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        IndexedStack(index: _index, children: [
          ...guideBuilder(),
        ]),
      ],
    );
  }
}

void judgeGuide(String guideName, BuildContext context) async {
  try{
    String screenType =
    MediaQuery.of(context).size.width > 10000 ? 'large' : 'small';
    final String? deviceLocale =
        WidgetsBinding.instance.window.locale.toLanguageTag();
    // TODO
    final AppLocale appLocale = I18nUtils.findDeviceLocale(deviceLocale);
    String languageType =
        (appLocale == AppLocale.zhHans || appLocale == AppLocale.zhHant)
            ? 'zh'
            : 'en';
    List<String> unit = [
      'conversation',
      'search',
      'chat',
      'userProfile',
      'concat',
      'friendProfile',
      'groupProfile'
    ];
    final userGuideList = {
      "conversation": 3,
      "search": 1,
      "chat": 3,
      "userProfile": 2,
      "concat": 3,
      "friendProfile": 3,
      "groupProfile": 3
    };

    for (int i = 0; i < unit.length; i++) {
      int builderLength = userGuideList[unit[i]] ?? 0;
      for (int j = 1; j < builderLength; j++) {
        precacheImage(
            AssetImage(
                "assets/user_guide/$screenType/$languageType/${unit[i]}-$j.png"),
            context);
      }
    }

    final model = Provider.of<UserGuideProvider>(context, listen: false);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    List<String> guideList = prefs.getStringList('guidedPage') ?? [];
    if (!guideList.contains(guideName)) {
      prefs.setStringList(
          'guidedPage', [guideName, ...prefs.getStringList('guidedPage') ?? []]);
      model.guideName = guideName;
    }
  }catch(e){}
}
