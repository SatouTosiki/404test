import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'screens/search.dart';
import 'screens/bookmark.dart';
import 'screens/Home.dart';
import 'mypage/mypage.dart';

import 'push/push2.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedindex = 0;
  final PageController _pageController = PageController();
  final List<Widget> widgelist = [
    YourScreen(),
    SearchScreen(),
    AddBookPage(),
    BookmarkScreen(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LineIcons.home, size: 30),
            label: "ホーム",
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.search, size: 30),
            label: "探す",
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.camera, size: 30),
            label: "投稿",
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.heart, size: 30),
            label: "お気に入り",
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.user, size: 30),
            label: "アカウント",
          ),
        ],
        currentIndex: selectedindex,
        onTap: (index) {
          setState(() {
            selectedindex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        children: widgelist,
        onPageChanged: (index) {
          setState(() {
            selectedindex = index;
          });
        },
      ),
    );
  }
}
