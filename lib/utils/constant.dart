// ignore_for_file: constant_identifier_names

import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class Const {
  // 时间戳消息 前端模拟
  static const int V2TIM_ELEM_TYPE_TIME = 11;
  static const int REQUEST_ERROR_CODE = -9;
  static const int SERVER_ERROR_CODE = -99;
  // 消息滚动的底部 前端模拟
  static const int V2TIM_ELEM_TYPE_REFRESH = -999;
  // 房间消息的底部 （之后没有数据） 前端模拟
  static const int V2TIM_ELEM_TYPE_END = -9999;
  static List weekdayMap = [
    '',
    TIM_t("星期一"),
    TIM_t("星期二"),
    TIM_t("星期三"),
    TIM_t("星期四"),
    TIM_t("星期五"),
    TIM_t("星期六"),
    TIM_t("星期七")
  ];

  static const String SMS_LOGIN_TOKEN = "smsLoginToken";
  static const String SMS_LOGIN_PHONE = "smsLoginPhone";
  static const String DEV_LOGIN_USER_ID = "devLoginUserID";
  static const String DEV_LOGIN_USER_SIG = "devUserSig";
  static const String THEME_TYPE = "themeType";

  static const DAY_SEC = 86400;
  static const HOUR_SEC = 3600;
  static const MIN_SEC = 60;

  static const SEC_SERIES = [HOUR_SEC, MIN_SEC];

  static const V2_TIM_IMAGE_TYPES = {
    'ORIGINAL': 0,
    'BIG': 1,
    'SMALL': 2,
  };

  static final List<CustomEmojiFaceData> emojiList = [
    CustomEmojiFaceData(name: '4350', icon: "menu@2x.png", list: [
      "yz00@2x.png",
      "yz01@2x.png",
      "yz02@2x.png",
      "yz03@2x.png",
      "yz04@2x.png",
      "yz05@2x.png",
      "yz06@2x.png",
      "yz07@2x.png",
      "yz08@2x.png",
      "yz09@2x.png",
      "yz10@2x.png",
      "yz11@2x.png",
      "yz12@2x.png",
      "yz13@2x.png",
      "yz14@2x.png",
      "yz15@2x.png",
      "yz16@2x.png",
      "yz17@2x.png"
    ]),
    CustomEmojiFaceData(name: "4351", icon: "menu@2x.png", list: [
      "ys00@2x.png",
      "ys01@2x.png",
      "ys02@2x.png",
      "ys03@2x.png",
      "ys04@2x.png",
      "ys05@2x.png",
      "ys06@2x.png",
      "ys07@2x.png",
      "ys08@2x.png",
      "ys09@2x.png",
      "ys10@2x.png",
      "ys11@2x.png",
      "ys12@2x.png",
      "ys13@2x.png",
      "ys14@2x.png",
      "ys15@2x.png"
    ]),
    CustomEmojiFaceData(name: "4352", icon: "menu@2x.png", list: [
      "gcs00@2x.png",
      "gcs01@2x.png",
      "gcs02@2x.png",
      "gcs03@2x.png",
      "gcs04@2x.png",
      "gcs05@2x.png",
      "gcs06@2x.png",
      "gcs07@2x.png",
      "gcs08@2x.png",
      "gcs09@2x.png",
      "gcs10@2x.png",
      "gcs11@2x.png",
      "gcs12@2x.png",
      "gcs13@2x.png",
      "gcs14@2x.png",
      "gcs15@2x.png",
      "gcs16@2x.png"
    ])
  ];
}
