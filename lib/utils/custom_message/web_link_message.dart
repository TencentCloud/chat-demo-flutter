import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class WebLinkMessage {
  String? title;
  String? description;
  // ignore: non_constant_identifier_names
  Map<String, dynamic>? hyperlinks_text;

  WebLinkMessage.fromJSON(Map json) {
    title = json["title"];
    description = json["description"];
    hyperlinks_text = json["hyperlinks_text"];
  }
}

WebLinkMessage? getWebLinkMessage(V2TimCustomElem? customElem) {
  try {
    if (customElem?.extension != null) {
      final customMessage = jsonDecode(customElem!.extension!);
      return WebLinkMessage.fromJSON(customMessage);
    }
    return null;
  } catch (err) {
    return null;
  }
}