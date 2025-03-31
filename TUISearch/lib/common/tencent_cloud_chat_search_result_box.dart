import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:tencent_cloud_chat_search/common/tencent_cloud_chat_search_result_item.dart';
import 'package:tencent_cloud_chat_search/common/tencent_cloud_chat_search_result_more_button.dart';

class TencentCloudChatSearchResultBox extends StatefulWidget {
  final String title;
  final List<TencentCloudChatSearchResultBoxItemData> resultList;

  const TencentCloudChatSearchResultBox({Key? key, required this.title, required this.resultList}) : super(key: key);

  @override
  State<TencentCloudChatSearchResultBox> createState() => _TencentCloudChatSearchResultBoxState();
}

class _TencentCloudChatSearchResultBoxState extends State<TencentCloudChatSearchResultBox> {
  int _resultListRenderCount = 5;

  @override
  Widget build(BuildContext context) {
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: colorTheme.dividerColor.withOpacity(0.2),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 14, color: colorTheme.primaryTextColor),
                    ),
                  ))
                ],
              ),
            ),
            Divider(
              height: 1,
              color: colorTheme.dividerColor.withOpacity(0.8),
            ),
            Column(
              children: [
                ...widget.resultList.getRange(0, min(widget.resultList.length, _resultListRenderCount)).map((e) {
                  return TencentCloudChatSearchResultItem(
                    data: e,
                  );
                }).toList(),
                if (_resultListRenderCount < widget.resultList.length)
                  TencentCloudChatSearchResultMoreButton(
                    onPressed: () {
                      setState(() {
                        _resultListRenderCount += 5;
                      });
                    },
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
