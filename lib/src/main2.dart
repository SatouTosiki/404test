import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import "search/search.dart";
//--------------------------------
import 'screens/login_page.dart';
import 'screens/bookmark.dart';
import 'screens/Home.dart';
import 'screens/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mypage/mypage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedindex = 0; //ページ間管理

  final List<Widget> widgelist = [
    HomeScreen(),
    BookmarkScreen(),
    NotificationScreen(),
    Login(),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                LineIcons.search,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => search()),
                );
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      //body: widgelist[selectedindex], //body表示

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(LineIcons.home), label: "ホーム"),
          BottomNavigationBarItem(icon: Icon(LineIcons.cog), label: "ハート"),
          BottomNavigationBarItem(icon: Icon(LineIcons.heart), label: "ハート"),
          BottomNavigationBarItem(icon: Icon(LineIcons.home), label: "アカウント"),
        ],
        currentIndex: selectedindex,
        onTap: (index) {
          setState(() {
            selectedindex = index;
          });

          if (index == widgelist.indexOf(Login())) {
            // Login()アイテムが選択された場合の処理
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              // ログインしている場合の処理
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPage(user: currentUser)),
              );
            } else {
              // ログインしていない場合の処理
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            }
          }
        },
      ),

      body: widgelist[selectedindex], //body表示
    );
  }
}
