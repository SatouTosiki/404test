import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'register/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:line_icons/line_icons.dart';
import "search/search.dart";
import 'login/login_page.dart';
//--------------------------------
import 'screens/account.dart';
import 'screens/bookmark.dart';
import 'screens/home.dart';
import 'screens/notification.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
          // child: CircleAvatar(
          //   backgroundImage: AssetImage(
          //     '/Users/satoutoshiki/Desktop/pr/test3/lib/img/rika.jpg',
          //   ),
          // ),
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
      body: widgelist[selectedindex], //body表示

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
        },
      ),
    );
  }
}
