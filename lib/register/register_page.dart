import 'package:flutter/material.dart';
import 'package:test3/login/login_page.dart';
import 'package:test3/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/login_page.dart';
import 'package:lottie/lottie.dart';
import 'register_modl.dart';
import 'package:test3/main2.dart';

class Registe extends StatefulWidget {
  @override
  _Registe createState() => _Registe();
}

class _Registe extends State<Registe> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.home,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(title: 'My Home Page'),
              ),
            );
          },
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 10),
        //     child: IconButton(
        //       iconSize: 30,
        //       icon: const Icon(
        //         Icons.search_outlined,
        //         color: Colors.blue,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => Registe()),
        //         );
        //       },
        //     ),
        //   ),
        // ],
        title: const Text(
          '新規登録画面',
          style: TextStyle(color: Colors.blue, fontSize: 23),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center, //中央に配置
            child: Lottie.asset('assets/u.json'),
          ),
          const SizedBox(
            height: 39,
          ),
          Container(
            child: Container(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, //画面中央に寄せる
                children: [
                  // メールアドレス入力
                  TextFormField(
                    decoration: InputDecoration(labelText: 'メールアドレス'),
                    onChanged: (String value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  // パスワード入力
                  TextFormField(
                    decoration: InputDecoration(labelText: 'パスワード'),
                    obscureText: true, //パスワード見えないようにする
                    onChanged: (String value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),

                  TextField(
                    decoration: InputDecoration(labelText: "ユーザー名"),
                    onChanged: (String value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(9),
                    // メッセージ表示
                    child: Text(infoText),
                  ),
                  Container(
                    width: double.infinity,
                    // ユーザー登録ボタン
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20) //角丸める
                            ),
                      ),
                      child: const Text(
                        'ユーザー登録',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        try {
                          // メール/パスワードでユーザー登録
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          await userCredential.user?.updateDisplayName(name);
                        } catch (e) {
                          // ユーザー登録に失敗した場合
                          setState(() {
                            infoText = "登録に失敗しました："; //${e.toString()};
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  Container(
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        "ログインはこちら",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black, //押したときの色！！
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20) //角丸めてる
                            ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
