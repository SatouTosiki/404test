import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:lottie/lottie.dart';

import 'package:test3/src/main2.dart';

import "package:test3/src/register/register_page.dart";

import 'package:test3/src/mypage/mypage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();

  final User? user;

  Login({required this.user});
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // メッセージ表示用

  String infoText = '';

  // 入力したメールアドレス・パスワード

  String email = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/haikei.json',
            repeat: true,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 中央に寄せる

              children: [
                SizedBox(
                  height: 100, // 中央より少し上に配置
                ),
                Text(
                  'ログイン',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
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
                        obscureText: true,
                        onChanged: (String value) {
                          setState(() {
                            password = value;
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

                        // ログインボタン

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'ログイン',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () async {
                            try {
                              UserCredential userCredential =
                                  await _auth.signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // ログイン成功時の処理

                              User? user = userCredential.user;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                            } catch (e) {
                              // ログイン失敗時の処理

                              Text:
                              print('ログイン失敗：$e');
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 16),

                      Container(
                        width: double.infinity,

                        // 新規登録ボタン

                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registe(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text(
                              '新規登録はこちら',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
