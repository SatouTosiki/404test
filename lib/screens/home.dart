import 'package:flutter/material.dart';
import 'package:test3/main2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child: Text('ホーム画面',
              style: TextStyle(
                fontSize: 32,
              ))),
    );
  }
}
