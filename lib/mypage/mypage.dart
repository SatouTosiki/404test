import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test3/login/login_page.dart';
import 'dart:math'; // 追加

class MyPage extends StatelessWidget {
  final User? user;

  MyPage({required this.user});

  @override
  Widget build(BuildContext context) {
    final Random random = Random(); // 追加

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user?.displayName ?? ''}の部屋',
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
          ],
        ),
      ),
    );
  }
}
