/*
 * @discripe: 直播
 */
import 'package:flutter/material.dart';
import 'package:live_flutter_plugin/v2_tx_live_code.dart';
import 'package:live_flutter_plugin/v2_tx_live_player.dart';
import 'package:live_flutter_plugin/v2_tx_live_player_observer.dart';
import 'package:live_flutter_plugin/widget/v2_tx_live_video_widget.dart';

class LiveRoomPlayer extends StatefulWidget {
  final String playUrl;

  const LiveRoomPlayer({Key? key, required this.playUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LivePlayState();
}

class _LivePlayState extends State<LiveRoomPlayer> {
  late V2TXLivePlayer _livePlayer;
  int? _localViewId;
  bool _isPlaying = false;
  bool _onError = false;
  bool _stopPlay = false;
  bool _firstPlay = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  initPlayer() async {
    _livePlayer = await V2TXLivePlayer.create();
    _livePlayer.addListener(onPlayerObserver);
  }

  onPlayerObserver(V2TXLivePlayerListenerType type, param) {
    // if()
    if (type == V2TXLivePlayerListenerType.onError) {
      _onError = true;
      setState(() {});
    } else if (type == V2TXLivePlayerListenerType.onVideoPlaying) {
      final isFirstPlay = param['firstPlay'] as bool;
      if (isFirstPlay) {
        _firstPlay = true;
      }
    } else if (type == V2TXLivePlayerListenerType.onStatisticsUpdate) {
      final videoBitrate = param['videoBitrate'].toString();
      final audioBitrate = param['audioBitrate'].toString();
      if (videoBitrate == "0" && audioBitrate == "0") {
        if (!_firstPlay) {
          setState(() {
            _stopPlay = true;
          });
        } else {
          _firstPlay = false;
        }
      } else {
        if (_stopPlay) {
          setState(() {
            _stopPlay = false;
          });
        }
      }
    }
  }

  void startPlay() async {
    if (_isPlaying) {
      return;
    }
    if (_localViewId != null) {
      debugPrint("_localViewId $_localViewId");
      var code = await _livePlayer.setRenderViewID(_localViewId!);
      if (code != V2TXLIVE_OK) {
        debugPrint("StartPlay error： please check remoteView load");
      }
    }
    var url = widget.playUrl;
    debugPrint("play url: $url");
    var playStatus = await _livePlayer.startLivePlay(url);
    debugPrint("play status: $playStatus");
    if (playStatus != V2TXLIVE_OK) {
      setState(() {
        _onError = true;
      });
      debugPrint("play error: $playStatus url: $url");
      return;
    }
    await _livePlayer.setPlayoutVolume(100);
    // await _livePlayer.setCacheParams(1, 1);
    setState(() {
      _isPlaying = true;
    });
  }

  stopPlay() async {
    await _livePlayer.stopPlay();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _livePlayer.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.7),
        child: Stack(
          children: [
            Container(
              color:
                  (_stopPlay || _onError) ? Colors.white : Colors.transparent,
              child: V2TXLiveVideoWidget(
                onViewCreated: (viewId) async {
                  _localViewId = viewId;
                  startPlay();
                },
              ),
            ),
            if (_onError)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: Text(
                      "主播暂未开播",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (_stopPlay)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: Text(
                      "主播暂未开播",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
          ],
        ));
  }
}
