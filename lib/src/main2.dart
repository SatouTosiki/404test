import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'screens/search.dart';
import 'screens/bookmark.dart';
import 'screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mypage/mypage.dart';
import 'push/push.dart';
import 'push/push2.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedindex = 0; //ページ間管理

  final List<Widget> widgelist = [
    //HomeScreen(),
    YourScreen(),
    BookmarkScreen(),
    AddBookPage(),
    search(),
    //Login(user: null),
    MyPage(user: currentUser),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 10), // パディングの値を調整
        ),
        title: Text(
          "chefGourmet",
          style: GoogleFonts.happyMonkey(
            textStyle: const TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(LineIcons.home), label: "ホーム"),
          BottomNavigationBarItem(icon: Icon(LineIcons.search), label: "探す"),
          BottomNavigationBarItem(icon: Icon(LineIcons.camera), label: "投稿"),
          BottomNavigationBarItem(icon: Icon(LineIcons.heart), label: "検索"),
          BottomNavigationBarItem(icon: Icon(LineIcons.home), label: "アカウント"),
        ],
        currentIndex: selectedindex,
        onTap: (index) {
          setState(() {
            selectedindex = index;
          });
        },
      ),

      body: widgelist[selectedindex], //body表示
    );
  }
}
