import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

List<Widget> textFields = []; // テキストフィールドのリスト

class AddTextFieldButton extends StatefulWidget {
  @override
  _AddTextFieldButtonState createState() => _AddTextFieldButtonState();
}

class _AddTextFieldButtonState extends State<AddTextFieldButton> {
  List<Widget> textFields = []; // テキストフィールドのリスト

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // ボタンが押されたら新しいテキストフィールドを追加
            setState(() {
              textFields.add(TextField());
            });
          },
          child: Text('テキストフィールドを追加'),
        ),
        // テキストフィールドをリストから表示
        Column(
          children: textFields,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(""),
        )
      ],
    );
  }
}

// ユーザーがログインしていることを確認する関数

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
              '${user?.displayName ?? ''}   is room',
              style: GoogleFonts.happyMonkey(
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite), // 表示するアイコン
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
      body: Center(
        child: AddTextFieldButton(), // クラスを使ってボタンとテキストフィールドを表示
      ),
    );
  }
}
