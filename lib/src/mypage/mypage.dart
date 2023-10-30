import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test3/src/push/push_class.dart';

import '../screens/login_page.dart';

User? user = FirebaseAuth.instance.currentUser; //ログインしているユーザーを取得suerに

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
                icon: Icon(
                  LineIcons.running,
                  size: 45,
                ),
                color: Colors.green,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Login(
                        user: null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // プロフィール画像を表示
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // 要素を左右に均等に配置
                      children: [
                        CircleAvatar(
                          radius: 50, // プロフィール画像の半径
                          backgroundImage: NetworkImage(
                              user?.photoURL ?? ''), // ユーザーのプロフィール画像のURL
                        ),
                        Column(
                          children: const [
                            Text(
                              "フォロワー",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text("実装予定"),
                          ],
                        ),
                        Column(
                          children: const [
                            Text(
                              "フォロー中",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text("実装予定"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //カラム数
                  ),
                  itemCount: 9, //要素数
                  itemBuilder: (context, index) {
                    //要素を戻り値で返す
                    return Container(
                      color: index.isEven ? Colors.blue : Colors.yellow,
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
