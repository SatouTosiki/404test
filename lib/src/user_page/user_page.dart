import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class userpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: Center(
        child: TextButton(
          child: Text("1ページ目に遷移する"),
          onPressed: () {
            // （1） 指定した画面に遷移する
            Navigator.push(
                context,
                MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => userpage2()));
          },
        ),
      ),
    );
  }
}

class userpage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: Center(
        child: TextButton(
          child: Text("1ページ目に遷移する"),
          onPressed: () {},
        ),
      ),
    );
  }
}
