import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdvancedYouTubePlayer extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final bool showControls;
  final bool loop;
  final int startSeconds;

  const AdvancedYouTubePlayer({
    Key? key,
    required this.videoId,
    this.autoPlay = false,
    this.showControls = true,
    this.loop = false,
    this.startSeconds = 0,
  }) : super(key: key);

  @override
  State<AdvancedYouTubePlayer> createState() => _AdvancedYouTubePlayerState();
}

class _AdvancedYouTubePlayerState extends State<AdvancedYouTubePlayer>
    with WidgetsBindingObserver {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final physicalSize = PlatformDispatcher.instance.views.first.physicalSize;
    // final controller = widget.player.controller;
    if (physicalSize.width > physicalSize.height) {
      // controller.updateValue(controller.value.copyWith(isFullScreen: true));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      // widget.onEnterFullScreen?.call();
    } else {
      // controller.updateValue(controller.value.copyWith(isFullScreen: false));
      SystemChrome.restoreSystemUIOverlays();
      // widget.onExitFullScreen?.call();
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: _getAdvancedYouTubeHtml(),
                  mimeType: "text/html",
                  encoding: "utf8",
                ),
                initialSettings: InAppWebViewSettings(
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                  _addJavaScriptHandlers(controller);
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print("Console: ${consoleMessage.message}");
                },
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
        // _buildCustomControls(),
      ],
    );
  }

  Widget _buildCustomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
          IconButton(icon: const Icon(Icons.stop), onPressed: _stopVideo),
          IconButton(
            icon: const Icon(Icons.replay_10),
            onPressed: () => _seekTo(-10),
          ),
          IconButton(
            icon: const Icon(Icons.forward_10),
            onPressed: () => _seekTo(10),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: _toggleFullscreen,
          ),
        ],
      ),
    );
  }

  void _addJavaScriptHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'onPlayerStateChange',
      callback: (args) {
        final state = args[0] as int;
        setState(() {
          isPlaying = state == 1; // 1 = playing, 2 = paused
        });
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onPlayerReady',
      callback: (args) {
        print('Player is ready');
      },
    );
  }

  void _togglePlayPause() {
    if (isPlaying) {
      webViewController?.evaluateJavascript(source: "pauseVideo();");
    } else {
      webViewController?.evaluateJavascript(source: "playVideo();");
    }
  }

  void _stopVideo() {
    webViewController?.evaluateJavascript(source: "stopVideo();");
  }

  void _seekTo(int seconds) {
    webViewController?.evaluateJavascript(source: "seekToRelative($seconds);");
  }

  void _toggleFullscreen() {
    webViewController?.evaluateJavascript(source: "toggleFullscreen();");
  }

  String _getAdvancedYouTubeHtml() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                margin: 0;
                padding: 0;
                background-color: black;
            }
            #player {
                width: 100%;
                height: 100vh;
            }
        </style>
    </head>
    <body>
        <div id="player"></div>
        
        <script>
            var tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

            var player;
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('player', {
                    height: '100%',
                    width: '100%',
                    videoId: '${widget.videoId}',
                    playerVars: {
                        'autoplay': ${widget.autoPlay ? 1 : 0},
                        'controls': ${widget.showControls ? 1 : 0},
                        'loop': ${widget.loop ? 1 : 0},
                        'start': ${widget.startSeconds},
                        'modestbranding': 1,
                        'rel': 0,
                        'showinfo': 0
                    },
                    events: {
                        'onReady': onPlayerReady,
                        'onStateChange': onPlayerStateChange
                    }
                });
            }

            function onPlayerReady(event) {
                window.flutter_inappwebview.callHandler('onPlayerReady');
            }

            function onPlayerStateChange(event) {
                window.flutter_inappwebview.callHandler('onPlayerStateChange', event.data);
            }

            function playVideo() {
                player.playVideo();
            }

            function pauseVideo() {
                player.pauseVideo();
            }

            function stopVideo() {
                player.stopVideo();
            }

            function seekToRelative(seconds) {
                var currentTime = player.getCurrentTime();
                player.seekTo(currentTime + seconds);
            }

            function toggleFullscreen() {
                if (player.getIframe().requestFullscreen) {
                    player.getIframe().requestFullscreen();
                }
            }
        </script>
    </body>
    </html>
    ''';
  }
}

class YouTubeHelper {
  static String? extractVideoId(String url) {
    RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
      multiLine: false,
    );

    Match? match = regExp.firstMatch(url);
    return match?.group(1);
  }

  /// Converts fully qualified YouTube Url to video id.
  ///
  /// If videoId is passed as url then no conversion is done.
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }
}
