import 'package:flutter/material.dart';

class LeftMenu extends StatefulWidget {
  const LeftMenu({super.key});

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 150,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  child: Image.asset('assets/images/icon.png')),
            ),
            Container(
                child: Text(
              'BOX CCTV',
              style: TextStyle(fontSize: 18),
            )),
            Text('แอพพลิเคชั่นติดตามจราจรผ่านกล้อง CCTV')
          ],
        ),
      ),
    );
  }
}

//ads banner id : ca-app-pub-1546426480316306/3365294620
//ads full id : ca-app-pub-1546426480316306/9300255383
