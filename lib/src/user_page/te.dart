import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _selectedImage;
  bool _loading = false;

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _auth.currentUser?.displayName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IgnorePointer(
        ignoring: _loading,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('プロフィール編集'),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // プロフィール画像の選択
                      ElevatedButton(
                        onPressed: () async {
                          final pickedImage = await _imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedImage != null) {
                            setState(() {
                              _selectedImage = File(pickedImage.path);
                            });
                          }
                        },
                        child: Text('プロフィール画像を選択'),
                      ),

                      // 選択した画像を表示
                      _selectedImage != null
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.file(
                                _selectedImage!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(),

                      // ユーザーネームの変更
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'ユーザーネーム'),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // アップロードボタン
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });

                          try {
                            // プロフィール画像をアップロードまたは上書き
                            if (_selectedImage != null) {
                              final user = _auth.currentUser;
                              if (user != null) {
                                final storageRef = _storage
                                    .ref('profile_images/${user.uid}.jpg');
                                await storageRef.putFile(_selectedImage!);
                                final imageUrl =
                                    await storageRef.getDownloadURL();
                                await user.updatePhotoURL(imageUrl);
                              }
                            }

                            // ユーザーネームのアップデート
                            final user = _auth.currentUser;
                            if (user != null) {
                              final newDisplayName = _nameController.text;

                              // 'users' コレクション内の名前を更新
                              await _firestore
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({
                                'name': newDisplayName,
                              });

                              // 'user_post' コレクション内の名前も更新
                              await _firestore
                                  .collection('user_post')
                                  .where('user_id', isEqualTo: user.uid)
                                  .get()
                                  .then((querySnapshot) {
                                querySnapshot.docs.forEach((doc) async {
                                  await doc.reference
                                      .update({'name': newDisplayName});
                                });
                              });

                              await user.updateDisplayName(newDisplayName);
                            }

                            setState(() {
                              _loading = false;
                              _selectedImage = null;
                            });

                            // 保存操作後にSnackBarを表示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('変更の保存ができました'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } catch (e) {
                            print('データの保存中にエラーが発生しました: $e');
                            setState(() {
                              _loading = false;
                            });

                            // エラーが発生した場合にSnackBarを表示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('変更できませんでした'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text('保存'),
                      ),

                      // ローディングインジケータ
                      _loading
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'lib/src/img/卵なしチャーハン.gif',
                                height: 100,
                                width: 100,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
            if (_loading)
              ModalBarrier(
                color: Colors.black.withOpacity(0.3),
                dismissible: false,
              ),
          ],
        ),
      ),
    );
  }
}
