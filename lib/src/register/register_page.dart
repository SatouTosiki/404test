import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:lottie/lottie.dart';

import '../screens/login_page.dart';

class Registe extends StatefulWidget {
  @override
  _RegisteState createState() => _RegisteState();
}

class _RegisteState extends State<Registe> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // メッセージ表示用

  String infoText = '';

  // 入力したメールアドレス・パスワード

  String email = '';

  String password = '';

  String name = '';

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
              children: [
                SizedBox(height: 100), // 中央より少し上に配置

                Text(
                  '新規登録',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'メールアドレス'),
                        onChanged: (String value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'パスワード'),
                        obscureText: true,
                        onChanged: (String value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'ユーザー名'),
                        onChanged: (String value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(9),
                        child: Text(infoText),
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            '新規登録',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () async {
                            try {
                              final UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              await userCredential.user
                                  ?.updateDisplayName(name);
                            } catch (e) {
                              setState(() {
                                infoText = '登録に失敗しました：$e';
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: double.infinity,

                        // 新規登録ボタン

                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Login(user: null), // Login クラスのコンストラクタを呼び出し
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text(
                              'ログインに戻る',
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
