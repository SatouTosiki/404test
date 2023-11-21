import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../screens/login_page.dart';
import 'package:lottie/lottie.dart';

class Registe extends StatefulWidget {
  @override
  _RegisteState createState() => _RegisteState();
}

class _RegisteState extends State<Registe> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String email = '';
  String password = '';
  String name = '';
  File? _selectedImage;

  String emailError = '';
  String passwordError = '';
  String nameError = '';
  String iconError = '';
  String infoText = '';
  bool isLoading = false;

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
          Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 100),
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
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              final pickedImage = await _imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedImage != null) {
                                setState(() {
                                  _selectedImage = File(pickedImage.path);
                                  iconError = ''; // アイコンが選択されたらエラーメッセージをクリア
                                });
                              }
                            },
                      child: Text('プロフィール画像を選択'),
                    ),
                    if (iconError.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          iconError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.all(35),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildTextField(
                            'メールアドレス',
                            email,
                            TextInputType.emailAddress,
                            (String value) {
                              setState(() {
                                email = value;
                                emailError = ''; // ユーザーが入力を再開したらエラーメッセージをクリア
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
                                passwordError = ''; // ユーザーが入力を再開したらエラーメッセージをクリア
                              });
                            },
                            passwordError,
                            obscureText: true,
                          ),
                          buildTextField(
                            'ユーザー名（7文字まで）',
                            name,
                            TextInputType.text,
                            (String value) {
                              setState(() {
                                name = value;
                                nameError = ''; // ユーザーが入力を再開したらエラーメッセージをクリア
                              });
                            },
                            nameError,
                            maxLength: 7,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator()
                                : const Text(
                                    '新規登録',
                                    style: TextStyle(fontSize: 18),
                                  ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      emailError = ''; // ボタンが押されたらエラーメッセージをクリア
                                      passwordError = '';
                                      nameError = '';
                                      iconError = '';
                                    });

                                    if (!validate()) {
                                      return; // バリデーションに失敗したら処理を中断
                                    }

                                    if (_selectedImage == null) {
                                      setState(() {
                                        iconError = 'アイコンを選択してください';
                                      });
                                      return;
                                    }

                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      final UserCredential userCredential =
                                          await _auth
                                              .createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );

                                      await userCredential.user
                                          ?.updateDisplayName(name);

                                      final user = _auth.currentUser;
                                      final storageRef = _storage.ref(
                                          'profile_images/${user?.uid}.jpg');
                                      await storageRef.putFile(_selectedImage!);
                                      final imageUrl =
                                          await storageRef.getDownloadURL();
                                      await user?.updatePhotoURL(imageUrl);

                                      final uuid = user?.uid;

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uuid)
                                          .set({
                                        'uid': uuid,
                                        'name': name,
                                        'email': email,
                                      });

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => Login(
                                            user: null,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      setState(() {
                                        infoText = '画像登録に失敗しました：$e';
                                        print(infoText);
                                      });
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                          ),
                          SizedBox(height: 40),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(user: null),
                                      ),
                                    );
                                  },
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Text(
                                'ログインに戻る',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 入力バリデーション
  bool validate() {
    bool isValid = true;

    if (email.isEmpty) {
      setState(() {
        emailError = 'メールアドレスを入力してください';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'パスワードを入力してください';
      });
      isValid = false;
    } else if (password.length < 6 || password.length > 12) {
      setState(() {
        passwordError = 'パスワードは6文字以上12文字以下で入力してください';
      });
      isValid = false;
    }

    if (name.isEmpty) {
      setState(() {
        nameError = 'ユーザー名を入力してください';
      });
      isValid = false;
    } else if (name.length > 7) {
      setState(() {
        nameError = 'ユーザー名は7文字までです';
      });
      isValid = false;
    }

    return isValid;
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
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
    );
  }
}
