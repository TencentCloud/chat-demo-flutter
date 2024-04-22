import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:provider/provider.dart';

class EmptyWidget extends StatelessWidget{
  final String title;
  final String? description;

  const EmptyWidget({Key? key, required this.title, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return MoveWindow(
      child: Row(
        children: [
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topLeft, end: FractionalOffset.bottomRight,
                    colors: <Color>[
                      hexToColor("f2f3f6"),
                      hexToColor("f6f2f3"),
                      hexToColor("f2f3f6")
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      "assets/empty.png",
                      width: 100,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      title,
                      style:
                      TextStyle(color: theme.primaryColor, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    if(description != null)Text(
                      description!,
                      style:
                      TextStyle(color: theme.weakTextColor, fontSize: 14),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

}