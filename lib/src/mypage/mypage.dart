import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class MyPage extends StatelessWidget {
  final User? user;

  MyPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${user?.displayName ?? ''} is room',
              style: GoogleFonts.happyMonkey(
                textStyle: const TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
            IconButton(
              icon: Icon(LineIcons.android),
              color: Colors.black,
              onPressed: () {
                // ログアウト処理
                FirebaseAuth.instance.signOut();
                Navigator.pop(context); // マイページ画面を閉じてログイン画面に戻る
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(10),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右に要素を配置
      //       children: [
      //         Text(
      //           '${user?.displayName ?? ''} is room',
      //           style: GoogleFonts.happyMonkey(
      //               textStyle: const TextStyle(fontSize: 25)),
      //         ),
      //         IconButton(
      //           icon: Icon(LineIcons.android),
      //           onPressed: () {
      //             // ログアウト処理
      //             FirebaseAuth.instance.signOut();
      //             Navigator.pop(context); // マイページ画面を閉じてログイン画面に戻る
      //           },
      //           // child: const Text(
      //           //   'ログアウト',
      //           //   style: TextStyle(fontSize: 10),
      //           // ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
