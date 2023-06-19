import 'package:flutter/material.dart';
import 'package:test3/main.dart';
import 'package:test3/main2.dart';
import '../register/register_page.dart';
import '../register/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'login_modl.dart';

class Login extends StatefulWidget {
  @override
  _Registe createState() => _Registe();
}

class _Registe extends State<Login> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ログイン画面"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              alignment: Alignment.center, //中央に配置
              child: Lottie.asset('assets/i.json'),
            ),
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
                    // ユーザー登録ボタン
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20) //角丸める
                            ),
                      ),
                      child: const Text(
                        'ログイン',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        Future<void> signInWithEmailAndPassword(
                            String email, String password) async {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            // ログイン成功時の処理
                            User? user = userCredential.user;
                            print('ログイン成功：${user!.email}');
                          } catch (e) {
                            // ログイン失敗時の処理
                            print('ログイン失敗：$e');
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
