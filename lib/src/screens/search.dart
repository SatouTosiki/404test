import 'package:flutter/material.dart';
import 'package:test3/src/main2.dart';

class search extends StatelessWidget {
  const search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '検索画面',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
