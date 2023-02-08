import 'dart:async';
import 'dart:math';

import 'package:timuikit/utils/request.dart';

const messageCount = 40;

void main(List<String> args) {
  print("message called");
  print('Hello, World!');
  // Timer.periodic(const Duration(seconds: 1), (t) {
  //   for (var i = 0; i < messageCount; i++) {
  //     SendGroupMessageRestApi.sendMessage();
  //   }
  // });
}

class SendGroupMessageRestApi {
  static sendMessage() async {
    final random = Random().nextInt(1000000);
    await appRequest(
        baseUrl: "https://console.tim.qq.com",
        path: "/v4/group_open_http_svc/send_group_msg",
        params: {
          "sdkappid": 1400187352,
          "identifier": "admin",
          "usersig":
              "eJwtzEsLgkAUhuH-MuuQ48ycMYQWIlGJdDE3LgdmqlNo3rrTf8-U5fd88H5YGu*du62Zz7gDbNJvMrZo6UA9a5NTMR6NueiyJMN8VwK4U08gHx77LKm2nSMiB4BBW8r-pjzkElHJsULHrhulQbLdCF1VjZDL03wdZgvUq937esYXKKuC5HGL4tQU2Yx9fxjXMRo_",
          "contenttype": "json"
        },
        method: "post",
        data: {
          "GroupId": "@TGS#aCWHGJ3LC",
          "Random": random,
          "MsgBody": [
            {
              "MsgType": "TIMTextElem",
              "MsgContent": {"Text": "red packet"}
            }
          ]
        });
  }
}
