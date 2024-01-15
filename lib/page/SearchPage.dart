import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = '';
  String detail = '';
  String provine = '';
  String url = '';

  @override
  void initState() {
    Loaddata();
    super.initState();
  }

  void Loaddata() {
    var _name = Get.arguments['name'];
    var _detail = Get.arguments['detail'];
    var _provine = Get.arguments['provine'];
    var _url = Get.arguments['url'];

    setState(() {
      name = _name;
      detail = _detail;
      provine = _provine;
      url = _provine;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหา'),
      ),
    );
  }
}
