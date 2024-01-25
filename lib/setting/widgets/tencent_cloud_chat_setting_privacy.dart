import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_theme_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class TencentCloudChatSettingPrivacy extends StatelessWidget {
  final String title;
  final String url;

  const TencentCloudChatSettingPrivacy({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse(url));
    return TencentCloudChatThemeWidget(
        build: (context, colorTheme, textStyle) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 1,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
                leading: IconButton(
                  padding: const EdgeInsets.only(left: 16),
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.white,
                  // 返回Home事件
                  onPressed: () => {Navigator.pop(context)},
                ),
                // centerTitle: true,
                backgroundColor: colorTheme.loginBackgroundColor,
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: WebViewWidget(controller: controller),
              ),
            ));
  }
}
