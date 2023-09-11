import 'push.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

// ユーザーがログインしていることを確認する関数

Future<User?> getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}

class AddBookModel extends ChangeNotifier {
  String? title;

  String? author;

  List<File> imageFiles = []; // 複数の画像ファイルのパスを格納するリスト

  String? timestamp;

  bool isLoading = false;

  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;

    notifyListeners();
  }

  void endLoading() {
    isLoading = false;

    notifyListeners();
  }

  Future addBook() async {
    if (title == null || title == "") {
      throw 'タイトルが入力されていません';
    }

    if (author == null || author!.isEmpty) {
      throw '説明文が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('user_post').doc();

    for (var imageFile in imageFiles) {
      // storageにアップロード

      final task = await FirebaseStorage.instance
          .ref('user_post/${doc.id}/${imageFile.path}')
          .putFile(imageFile);

      final imgURL = await task.ref.getDownloadURL();

      imgURLs.add(imgURL);
    }

    // firestoreに追加

    await doc.set({
      'title': title,
      'author': author,
      'imgURL': imgURLs,
      'time': timestamp,
    });
  }

  List<String> imgURLs = []; // 画像のダウンロードURLを格納するリスト

  Future pickImage() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        if (imageFiles.length < 5) {
          String imagePath = pickedFile.path;

          imageFiles.add(File(imagePath)); // 画像ファイルのパスをリストに追加」

          int length = imageFiles.length;
        } else {
          print("画像が多い");
        }

        // 各画像ファイルのパスにアクセ
      }

      notifyListeners();
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

 

//colorクラス

 

// class RecipeForm extends StatelessWidget {

//   @override

//   Widget build(BuildContext context) {

//     return Column(

//       children: const [

//         //Text("レシピを追加"),

//         TextField(

//           decoration: InputDecoration(hintText: "タイトル"),

//         ),

//         TextField(

//           decoration: InputDecoration(hintText: "説明"),

//         ),

//       ],

//     );

//   }

// }

 

// class AddDocumentScreen extends StatelessWidget {

//   final TextEditingController titleController = TextEditingController();

//   final TextEditingController contentController = TextEditingController();

 

//   void addDocument() {

//     String title = titleController.text;

//     String content = contentController.text;

 

//     CollectionReference documents =

//         FirebaseFirestore.instance.collection('user_post');

 

//     documents.add({

//       'title': title,

//       'content': content,

//     }).then((docRef) {

//       print('Document added with ID: ${docRef.id}');

//     }).catchError((error) {

//       print('Error adding document: $error');

//     });

//   }

 

//   @override

//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(

//         title: Text('Add Document'),

//       ),

//       body: Padding(

//         padding: EdgeInsets.all(16.0),

//         child: Column(

//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [

//             TextField(

//               controller: titleController,

//               decoration: InputDecoration(labelText: 'Title'),

//             ),

//             TextField(

//               controller: contentController,

//               decoration: InputDecoration(labelText: 'Content'),

//             ),

//             SizedBox(height: 16.0),

//             ElevatedButton(

//               onPressed: addDocument,

//               child: Text('Add Document'),

//             ),

//           ],

//         ),

//       ),

//     );

//   }

// }

 