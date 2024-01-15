import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StramCctv extends StatefulWidget {
  const StramCctv({super.key});

  @override
  State<StramCctv> createState() => _StramCctvState();
}

class _StramCctvState extends State<StramCctv> {
  late BetterPlayerController _betterPlayerController;
  var name = '';
  var detail = '';
  var provine = '';
  var url = '';

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            fit: BoxFit.fill,
            fullScreenByDefault: false,
            autoPlay: true,
            showPlaceholderUntilPlay: true,
            autoDetectFullscreenDeviceOrientation: true,
            looping: true);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      //  "http://180.180.242.208:1935/Phase15/PER_15_009.stream/playlist.m3u8",
      "https://mtoczko.github.io/hls-test-streams/test-group/playlist.m3u8",
      useAsmsSubtitles: false,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    Loaddata();
    super.initState();
  }

  void Loaddata() {
    print(Get.arguments['url']);
    // var _name = Get.arguments['name'];
    // var _detail = Get.arguments['detail'];
    // var _provine = Get.arguments['provine'];
    // var _url = Get.arguments['url'];

    // print(
    //     'Stream name is : $_name  ,detail : $detail , provine : $_provine , url is  :  $_url');
    // setState(() {
    //   name = _name;
    //   detail = _detail;
    //   provine = _provine;
    //   url = _url;
    // });
    // Future.delayed(Duration(seconds: 3), () {
    //   //   InnitStream();
    // });

    //  InnitStream();
  }

  void InnitStream() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            fit: BoxFit.fill,
            fullScreenByDefault: false,
            autoPlay: true,
            showPlaceholderUntilPlay: true,
            autoDetectFullscreenDeviceOrientation: true,
            looping: true);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Get.arguments['url'].toString(),
      useAsmsSubtitles: false,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online CCTV'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
                color: Colors.black,
                height: 250,
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(controller: _betterPlayerController))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        var _name = Get.arguments['name'];
        var _detail = Get.arguments['detail'];
        var _provine = Get.arguments['provine'];
        var _url = Get.arguments['url'];

        print(
            'Stream name is : $_name  ,detail : $detail , provine : $_provine , url is  :  $_url');
        setState(() {
          name = _name;
          detail = _detail;
          provine = _provine;
          url = _url;
        });
        Future.delayed(Duration(seconds: 3), () {
          //   InnitStream();
        });
      }),
    );
  }
}
