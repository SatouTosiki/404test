import 'package:flutter/material.dart';
import 'oush.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'oush.dart';

class con extends StatelessWidget {
  const con({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿ページ"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // この行で前のページに戻る
          },
        ),
        // ... 他のAppBarの設定 ...
      ),
      body: Center(
        child: Text(
          "Hello, World!",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
