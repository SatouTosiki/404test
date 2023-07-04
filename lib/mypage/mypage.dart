//import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test3/login/login_page.dart';

class MyPage extends StatelessWidget {
  final User? user;

  MyPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user?.displayName ?? ''}の部屋',
          style: GoogleFonts.happyMonkey(
            textStyle: const TextStyle(fontSize: 30),
          ),
        ),
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
