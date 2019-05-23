import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'my_player_info.dart';

class MyPlayer extends StatefulWidget {
  @override
  _MyPlayerState createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  VideoPlayerController _controller;

  String playerUrl = '';

  static const _channelName = 'com.iosapp.demo/my_player';
  static const _methodChannel = const MethodChannel(_channelName);

  static const _eventChannelName = 'com.iosapp.demo/my_player_event';
  static const EventChannel _eventChannel =
      const EventChannel(_eventChannelName);

  @override
  void initState() {
    super.initState();
    _eventChannel.receiveBroadcastStream(_eventChannelName).listen(_onResult);
  }

  void _onResult(Object url) {
    _initPlayerWithUrl(url);
  }

  void _playOrPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _initPlayerWithUrl(String url) {
    print('initPlayerWithUrl $url');
    playerUrl = url;
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    if (playerUrl.length == 0) {
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
            floatingActionButton: FloatingActionButton(onPressed: () {
              askForUrlToPlay();
            }),
          ),
        ),
      );
    } else {
      return player_build(context);
    }
  }

  @override
  Widget player_build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player',
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: _controller.value.initialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller))
                        : Container(),
                    padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          // both ok
                          SystemNavigator.pop();
                          //_methodChannel.invokeMethod('pop');
                        }),
                  ),
                ],
              ),
              MyPlayerInfo(),
            ],
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            _playOrPause();
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // call native to get information
  Future<Null> askForUrlToPlay() async {
    String url;
    try {
      url = await _methodChannel.invokeMethod('askForUrlToPlay');
    } on PlatformException catch (e) {
      url = '';
    }

    _initPlayerWithUrl(url);
  }
}
