import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:thailandhightwaycamerav1/home/HomePage.dart';
import 'package:thailandhightwaycamerav1/page/SearchPage.dart';
import 'package:thailandhightwaycamerav1/page/StremCctv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
        appBarElevation: 0.5,
        visualDensity: VisualDensity.standard,
        scheme: FlexScheme.flutterDash,
        //   primary: HexColor('#F4D03F'),
      ),
      darkTheme: FlexThemeData.dark(
          secondary: Colors.black,
          scaffoldBackground: Colors.black12,
          scheme: FlexScheme.flutterDash,
          primaryContainer: Colors.black,
          blendLevel: 3),
      home: HomePagae(),
      getPages: [
        GetPage(name: '/search', page: () => SearchPage()),
        GetPage(name: '/strem', page: () => StramCctv()),
      ],
    );
  }
}
