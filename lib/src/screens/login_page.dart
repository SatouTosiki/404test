import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import "package:test3/src/register/register_page.dart";
import 'package:test3/src/mypage/mypage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(80),
              child: Container(
                alignment: Alignment.center, //中央に配置
                child: Lottie.asset("assets/i.json"),
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
                      // ログインボタン
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), //角丸める
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
                            //print('ログイン成功：${user!.email}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyPage(user: user),
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
            )
          ],
        ),
      ),
    );
  }
}
