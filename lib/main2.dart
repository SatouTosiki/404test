import 'main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 10), // パディングの値を調整
          child: CircleAvatar(
            backgroundImage: AssetImage(
              '/Users/satoutoshiki/Desktop/pr/test3/lib/img/rika.jpg',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ),
        ],
        title: Text(
          "料理SNS",
          style: GoogleFonts.getFont(
            color: Colors.blue, // テキストの色を赤に指定
            'Kaisei Opti',
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Row(
        children: [
          Column(),
        ],
      ),
    );
  }
}
