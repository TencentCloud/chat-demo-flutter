import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:video_player/video_player.dart';

class TencentCloudChatMessageVideoPlayer extends StatefulWidget {
  final V2TimMessage message;
  final bool controller;
  final bool isSending;

  const TencentCloudChatMessageVideoPlayer({
    super.key,
    required this.message,
    required this.controller,
    required this.isSending,
  });

  @override
  State<StatefulWidget> createState() => TencentCloudChatMessageVideoPlayerState();
}

enum CurrentVideoType {
  online,
  local,
}

class CurrentVideoInfo {
  final String path;
  final CurrentVideoType type;
  final double aspectRatio;

  CurrentVideoInfo({
    required this.path,
    required this.type,
    required this.aspectRatio,
  });
}

class TencentCloudChatMessageVideoPlayerState extends State<TencentCloudChatMessageVideoPlayer> {
  final String _tag = "TencentCloudChatMessageVideoPlayer";

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  _initializePlayer() {
    try {
      final info = getMessageInfo();
      if (info != null && mounted) {
        if (info.type == CurrentVideoType.online) {
          _controller = VideoPlayerController.networkUrl(Uri.parse(info.path));
        } else {
          _controller = VideoPlayerController.file(File(info.path));
        }

        _controller.addListener(() {
          setState(() {});
        });
        _controller.setLooping(true);
        _controller.initialize();
      }
    } catch (e) {
      debugPrint("Video initialization error: $e");
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  CurrentVideoInfo? getMessageInfo() {
    if (widget.message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      double aspectRatio = (9 / 16);

      if (widget.isSending) {
        var lp = widget.message.videoElem!.videoPath ?? "";
        if (lp.isNotEmpty) {
          console("view sending message video path");
          if (File(lp).existsSync() && !kIsWeb) {
            return CurrentVideoInfo(path: lp, type: CurrentVideoType.local, aspectRatio: aspectRatio);
          }
        }
      }

      if (widget.message.videoElem!.snapshotWidth != null && widget.message.videoElem!.snapshotHeight != null) {
        if (widget.message.videoElem!.snapshotHeight != 0) {
          aspectRatio = (widget.message.videoElem!.snapshotWidth!) / (widget.message.videoElem!.snapshotHeight!);
        }
      }

      if (TencentCloudChatUtils.checkString(widget.message.videoElem!.videoPath) != null) {
        // 先查本地发送的视频地址
        if (File(widget.message.videoElem!.videoPath!).existsSync()) {
          console("video: local video path exists");
          return CurrentVideoInfo(
              path: widget.message.videoElem!.videoPath!, type: CurrentVideoType.local, aspectRatio: aspectRatio);
        }
      } else if (TencentCloudChatUtils.checkString(widget.message.videoElem!.localVideoUrl) != null) {
        // 再查本地下载的视频地址
        if (File(widget.message.videoElem!.localVideoUrl!).existsSync()) {
          console("video: local url exists");
          return CurrentVideoInfo(
              path: widget.message.videoElem!.localVideoUrl!, type: CurrentVideoType.local, aspectRatio: aspectRatio);
        }
      } else {
        // 最后再查在线地址(todo 使用 getMessageOnlineUrl 查询)
        if (widget.message.videoElem != null) {
          if (widget.message.videoElem!.snapshotUrl != null) {
            console("video: online url ${widget.message.videoElem!.videoUrl}");
            return CurrentVideoInfo(
              path: widget.message.videoElem!.videoUrl!,
              type: CurrentVideoType.online,
              aspectRatio: aspectRatio,
            );
          }
        }
        // if (!kIsWeb) {
        //   V2TimMessageOnlineUrl? urlres = await TencentCloudChat.instance.chatSDKInstance.messageSDK
        //       .getMessageOnlineUrl(msgID: widget.message.msgID ?? "");
        //   if (urlres != null) {
        //     if (urlres.videoElem != null) {
        //       if (TencentCloudChatUtils.checkString(urlres.videoElem!.videoUrl) != null) {
        //         console("view video online url ${urlres.videoElem!.videoUrl}");
        //         return CurrentVideoInfo(
        //             path: urlres.videoElem!.videoUrl!, type: CurrentVideoType.online, aspectRatio: aspectRatio);
        //       }
        //     }
        //   }
        // }
      }
    } else {
      console("The component received a non-video message parameter. please check");
    }
    console("has no view video source. please check");
    return null;
  }

  console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: json.encode(
        {
          "msgID": widget.message.msgID ?? "",
          "log": log,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.hasRiskContent == true) {
      return const Center(
        child: Text(
          "Risk Video",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (_controller == null) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 40),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            _ControlsOverlay(controller: _controller,),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: false,
                  padding: const EdgeInsets.only(bottom: 4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
