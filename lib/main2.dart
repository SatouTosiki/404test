import 'main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'register/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 10), // パディングの値を調整wwwwww
          child: CircleAvatar(
            backgroundImage: AssetImage(
              '/Users/satoutoshiki/Desktop/pr/test3/lib/img/rika.jpg',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registe()),
                );
              },
            ),
          ),
        ],
        title: Text(
          "料理SNS",
          style: GoogleFonts.getFont(
            color: Colors.blue, // テキストの色を赤に指定
            'Kaisei Opti',
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Container(
          //   alignment: Alignment.center, //中央に配置
          //   child: Lottie.asset('assets/404.json'),
          // )

          InkWell(
            onTap: () {
              // ボタンがタップされたときの処理
            },
            child: Container(
              width: 100,
              height: 100,
              child: Lottie.asset('assets/u.json'),
            ),
          )
        ],
      ),

      //下のバー

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          // 他のアイテム
        ],
      ),
    );
  }
}
