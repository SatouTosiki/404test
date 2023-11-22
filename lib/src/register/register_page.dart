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
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(9),
                      child: Text(infoText),
                    ),
                    const Text(
                      '新規登録',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                    ),
                    const SizedBox(
                      height: 10,
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
                                  iconError = '';
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
                      padding: EdgeInsets.all(20),
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
                                passwordError = '';
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
                                nameError = '';
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
                                      emailError = '';
                                      passwordError = '';
                                      nameError = '';
                                      iconError = '';
                                    });

                                    if (!validate()) {
                                      return;
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

                                      // Firebase Authenticationのメール認証機能を利用して認証コードを送信
                                      await userCredential.user
                                          ?.sendEmailVerification();

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
                                      // エラーが発生した場合の処理を追加できます
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                          ),
                          SizedBox(height: 10),
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
                              padding: EdgeInsets.all(2.0),
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
