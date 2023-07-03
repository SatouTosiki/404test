import 'package:flutter/material.dart';
import 'package:test3/main2.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child: Text('お気に入り画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}
