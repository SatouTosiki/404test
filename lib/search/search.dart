import 'package:test3/main.dart';
import 'package:test3/main2.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // ここで適切な処理を実行する
    if (index == 0) {
      // Homeタブが選択された場合の処理
      // 画面遷移やコンテンツ切り替えなど
    } else if (index == 1) {
      // Searchタブが選択された場合の処理
      // 画面遷移やコンテンツ切り替えなど
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
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
