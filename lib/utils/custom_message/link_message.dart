import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class LinkMessage {
  String? link;
  String? text;
  String? businessID;

  LinkMessage.fromJSON(Map json) {
    link = json["link"];
    text = json["text"];
    businessID = json["businessID"];
  }
}

LinkMessage? getLinkMessage(V2TimCustomElem? customElem) {
  try {
    if (customElem?.data != null) {
      final customMessage = jsonDecode(customElem!.data!);
      return LinkMessage.fromJSON(customMessage);
    }
    return null;
  } catch (err) {
    return null;
  }
}