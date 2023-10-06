import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import '../screens/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Registe extends StatefulWidget {
  @override
  _RegisteState createState() => _RegisteState();
}

class _RegisteState extends State<Registe> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  String name = '';
  File? _selectedImage; // 選択された画像を保持する変数

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

                // プロフィール画像を選択するボタ

                Container(
                  padding: EdgeInsets.all(9),
                  child: Text(infoText),
                ),

                const Text(
                  '新規登録',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // プロフィール画像を表示
                CircleAvatar(
                  radius: 75,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!) // 選択された画像を表示
                      : null, // 選択された画像がない場合はnull
                ),
                const SizedBox(
                  height: 30,
                ),

                ElevatedButton(
                  onPressed: () async {
                    final pickedImage = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        _selectedImage = File(pickedImage.path);
                      });
                    }
                  },
                  child: Text('プロフィール画像を選択'),
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

                              // プロフィール画像をアップロード

                              if (_selectedImage != null) {
                                final user = _auth.currentUser;
                                final storageRef = FirebaseStorage.instance
                                    .ref('profile_images/${user?.uid}.jpg');
                                await storageRef.putFile(_selectedImage!);
                                final imageUrl =
                                    await storageRef.getDownloadURL();
                                await user?.updatePhotoURL(imageUrl);
                              }
                            } catch (e) {
                              setState(() {
                                infoText = '画像登録に失敗しました：$e';
                                print(infoText);
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
