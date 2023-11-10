import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィール編集'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // プロフィール画像の表示
            CircleAvatar(
              radius: 75,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedImage =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _selectedImage = File(pickedImage.path);
                  });
                }
              },
              child: Text('プロフィール画像を選択'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // プロフィール画像をアップロードまたは上書き
                if (_selectedImage != null) {
                  final user = _auth.currentUser;
                  if (user != null) {
                    final storageRef =
                        _storage.ref('profile_images/${user.uid}.jpg');
                    await storageRef.putFile(_selectedImage!);
                    final imageUrl = await storageRef.getDownloadURL();
                    await user.updatePhotoURL(imageUrl);
                  }
                }
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
