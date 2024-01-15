import 'package:app_settings/app_settings.dart';
import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:thailandhightwaycamerav1/menu/LeftMenu.dart';
import 'package:thailandhightwaycamerav1/models/CctvModels.dart';
import 'package:thailandhightwaycamerav1/page/SearchPage.dart';
import 'package:thailandhightwaycamerav1/page/StremCctv.dart';

class HomePagae extends StatefulWidget {
  const HomePagae({super.key});

  @override
  State<HomePagae> createState() => _HomePagaeState();
}

class _HomePagaeState extends State<HomePagae> {
  late BetterPlayerController _betterPlayerController;
  bool _loading = true;
  var dio = Dio();
  var listdata = [];
  var listsearch = [];
  bool _showsearchbox = false;

  @override
  void initState() {
    OpenGPS();
    super.initState();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ระบุตำแหน่งปิดอยู่ เปิดระบุตำแหน่งและลองอีกครั้ง')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  //funtion zone
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // load normal gps
        LoaddataProcess("15.244625939286454", "104.85703314422908");
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // load normal gps
      LoaddataProcess("15.244625939286454", "104.85703314422908");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void OpenGPS() async {
    bool isopengps = await _handleLocationPermission();
    if (isopengps == true) {
      var locationnow = await determinePosition();
      print('Location lat  :' + locationnow.latitude.toString());
      print('Location lat  :' + locationnow.longitude.toString());
      LoaddataProcess(
          locationnow.latitude.toString(), locationnow.longitude.toString());
    } else {
      Alertdialog(context, 'โปรดเปิด GPS และลองอีกครั้ง');
    }
  }

  Future<bool> Loaddata(String lat, String long) async {
    var location = lat + ',' + long;
    try {
      dio.options.headers["content-type"] = "application/json";
      dio.options.headers["auth-token"] = 'taocctv045649428';
      var res = await dio
          .get('https://teekhalink.com/cctv/searchcctvapp/' +
              location.toString())
          .then((value) => value);
      if (res.statusCode == 200) {
        List db = res.data;
        if (db.length == 0) {
          return false;
        } else {
          var alllenth = db.length;
          var newlist = db.map((e) => CCTVModel.fromMap(e)).toList();
          setState(() {
            listdata = newlist;
            listsearch = newlist;
          });
          //   print(newlist);
          return true;
        }
      } else if (res.statusCode == 403) {
        var textstatus = 'เซสชั่นหมดอายุโปรดเข้าระบบอีกครั้ง';

        return false;
      } else if (res.statusCode == 404) {
        var textstatus =
            'ไม่สามารถยืนยันตัวตนของท่านได้ โปรดออกจากระบบและเข้าระบบอีกครั้ง';
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void LoaddataProcess(String lat, String long) async {
    bool _statusloading = await Loaddata(lat, long);
    print("loading status is :  $_statusloading");
    if (_statusloading == true) {
      setState(() {
        _loading = false;
      });
    } else {}
  }

  void LoadingPlayingCCTV(
    context,
    index,
  ) {
    PlayCCTV(context, listdata[index].name, listdata[index].url,
        listdata[index].detail);

    print('play url is  : ' + listdata[index].url);
    try {
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
        // "https://mtoczko.github.io/hls-test-streams/test-group/playlist.m3u8",
        listdata[index].url,
        useAsmsSubtitles: false,
      );
      _betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);
      _betterPlayerController.setupDataSource(dataSource);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: LeftMenu(),
      appBar: AppBar(
        title: Text('Traffic Camera CCTV'),
        actions: [
          Container(
            child: IconButton(
                onPressed: () {
                  //  Get.to(SearchPage());
                  print('search page');
                },
                icon: Icon(Icons.favorite)),
          )
        ],
      ),
      body: Container(
        child: _loading == true
            ? _LoadingWidget()
            : Container(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            LoadingPlayingCCTV(context, index);
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/bg.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.black38,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 15, top: 10),
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle),
                                        ),
                                      )),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 5, left: 10),
                                          child: Card(
                                            elevation: 0,
                                            color: Colors.transparent,
                                            child: Text(
                                              listdata[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 0, left: 10),
                                          child: Card(
                                            elevation: 0,
                                            color: Colors.transparent,
                                            child: Text(
                                              listdata[index].detail,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 0, left: 10),
                                          child: Card(
                                            elevation: 0,
                                            color: Colors.transparent,
                                            child: Text(
                                              listdata[index].provine,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            LoadingPlayingCCTV(context, index);
                                          },
                                          icon: Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.white,
                                            size: 32,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container();
                    },
                    itemCount: listdata.length),
              ),
      ),
    );
  }

  void PlayCCTV(context, String name, String url, String detail) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            child: SimpleDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              children: [
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: 300,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child:
                            BetterPlayer(controller: _betterPlayerController),
                      ))),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      _betterPlayerController.dispose();
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(FontAwesomeIcons.stop),
                                    label: Text('หยุดเล่น')),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            onWillPop: () async => false);
      },
    );
  }

  void Alertdialog(context, textstatus) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            child: SimpleDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 100,
                                    child: Image.asset(
                                        'assets/images/map-pin.png')),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(textstatus),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          AppSettings.openLocationSettings();
                                        },
                                        icon: Icon(
                                            FontAwesomeIcons.locationArrow),
                                        label: Text('เปิด GPS')),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
            onWillPop: () async => false);
      },
    );
  }

  Widget _LoadingWidget() {
    return Center(
      child: Container(
        height: 100,
        child: Column(
          children: [
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text('กำลังโหลด..'),
            )
          ],
        ),
      ),
    );
  }
}
