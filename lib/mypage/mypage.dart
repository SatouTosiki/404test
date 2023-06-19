import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test3/login/login_page.dart';

class MyPage extends StatelessWidget {
  final User? user;

  MyPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("マイページ"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ようこそ！',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
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
