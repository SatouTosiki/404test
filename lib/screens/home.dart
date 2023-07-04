import 'package:flutter/material.dart';
import 'package:test3/main2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('ホーム画面',
              style: TextStyle(
                fontSize: 32,
              ))),
    );
  }
}
