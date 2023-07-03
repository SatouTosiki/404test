import 'package:flutter/material.dart';
import 'package:test3/main2.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          const Center(child: Text('お知らせ画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}
