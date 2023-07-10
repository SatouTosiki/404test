import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math'; // 追加
import 'package:line_icons/line_icons.dart';
import 'test.dart';

class MyPage extends StatelessWidget {
  final User? user;

  MyPage({required this.user});

  @override
  Widget build(BuildContext context) {
    final Random random = Random(); // 追加
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user?.displayName ?? ''}のpage',
          style: GoogleFonts.happyMonkey(
            textStyle: const TextStyle(fontSize: 30),
          ),
        ),
        backgroundColor: Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        ), // ランダムな色を設定
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // ログアウト処理
                FirebaseAuth.instance.signOut();
                Navigator.pop(context); // マイページ画面を閉じてログイン画面に戻る
              },
              child: const Text('ログアウト'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     final currentUser = FirebaseAuth.instance.currentUser;
            //     if (currentUser != null) {
            //       // ログアウト処理
            //       await FirebaseAuth.instance.signOut();
            //       Navigator.pop(context); // マイページ画面を閉じてログイン画面に戻る
            //     } else {
            //       // ログインしていない場合の処理
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => test2()),
            //       );
            //     }
            //   },
            //   child: const Text('test'),
            // ),
          ],
        ),
      ),
    );
  }
}
