import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math'; // 追加

class MyPage extends StatelessWidget {
  final User? user;

  MyPage({required this.user});

  @override
  Widget build(BuildContext context) {
    final Random random = Random(); // 追加
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     '${user?.displayName ?? ''}のpage',
      //     style: GoogleFonts.happyMonkey(
      //       textStyle: const TextStyle(fontSize: 30),
      //     ),
      //   ),
      //   backgroundColor: Color.fromARGB(
      //     255,
      //     random.nextInt(256),
      //     random.nextInt(256),
      //     random.nextInt(256),
      //   ), // ランダムな色を設定
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右に要素を配置
            children: [
              Text(
                '${user?.displayName ?? ''} is room',
                style: GoogleFonts.happyMonkey(
                    textStyle: const TextStyle(fontSize: 25)),
              ),
              IconButton(
                icon: Icon(LineIcons.android),
                onPressed: () {
                  // ログアウト処理
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context); // マイページ画面を閉じてログイン画面に戻る
                },
                // child: const Text(
                //   'ログアウト',
                //   style: TextStyle(fontSize: 10),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
