import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:test3/src/main2.dart';
import "package:test3/src/register/register_page.dart";
import 'package:test3/src/screens/resetting.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
  final User? user;
  Login({required this.user});
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String emailError = '';
  String passwordError = '';
  String loginError = '';
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'login',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      buildTextField(
                        'メールアドレス',
                        email,
                        TextInputType.emailAddress,
                        (String value) {
                          setState(() {
                            email = value;
                            emailError = '';
                          });
                        },
                        emailError,
                      ),
                      buildTextField(
                        'パスワード',
                        password,
                        TextInputType.text,
                        (String value) {
                          setState(() {
                            password = value;
                            passwordError =
                                ''; // Clear previous error when user starts typing
                          });
                        },
                        passwordError,
                        obscureText: true,
                      ),
                      Container(
                        padding: EdgeInsets.all(9),
                        child: Text(
                          // Display login error message
                          loginError,
                          style: TextStyle(color: Colors.red),
                        ),
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
                            'ログイン',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () async {
                            emailFocusNode.unfocus();
                            passwordFocusNode.unfocus();

                            if (email.isEmpty || password.isEmpty) {
                              setState(() {
                                emailError =
                                    email.isEmpty ? 'エラー：メールアドレスを入力してください' : '';
                                passwordError = password.isEmpty
                                    ? 'エラー：パスワードを入力してください'
                                    : '';
                                loginError = 'エラー：メールアドレスもしくはパスワードを入力してください';
                              });
                            } else {
                              try {
                                final userCredential =
                                    await _auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                // メールの確認が完了しているかどうかを確認
                                final isVerified =
                                    userCredential.user?.emailVerified ?? false;

                                if (isVerified) {
                                  // 確認が完了していればユーザーをホームページに進める
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(),
                                    ),
                                  );
                                } else {
                                  // メールの確認が完了していない場合
                                  // メール送信
                                  await userCredential.user
                                      ?.sendEmailVerification();

                                  // ユーザーに確認メッセージを表示
                                }
                              } catch (e) {
                                // エラーハンドリング
                                print('ログインエラー: $e');
                                setState(() {
                                  loginError = 'エラー：ログインに失敗しました';
                                });
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
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
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              '新規登録はこちら',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                          child: const Text(
                            'パスワードの再設定',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => resetting(),
                              ),
                            );
                          }),
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

  Widget buildTextField(
    String labelText,
    String value,
    TextInputType keyboardType,
    ValueChanged<String> onChanged,
    String errorText, {
    bool obscureText = false,
    int? maxLength,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText.isNotEmpty ? errorText : null,
        labelStyle: TextStyle(
          color: errorText.isNotEmpty ? Colors.red : Colors.black,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
    );
  }
}
