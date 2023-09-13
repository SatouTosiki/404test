import 'push.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ユーザーがログインしていることを確認する関数

User? user = FirebaseAuth.instance.currentUser;
String? userName = user?.displayName; // ユーザー名を取得
List<File> images = []; // 選択された複数の画像を格納するリスト
List<Widget> textFields = []; // テキストフィールドのリスト

final picker = ImagePicker();

Future<User?> getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}

class AddBookModel extends ChangeNotifier {
  String? title;
  String? author;
  List<File> imageFiles = []; // 複数の画像ファイルのパスを格納するリスト
  List<Widget> textFields = []; //テキストフィールドを追加していくリスト
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

  void addTextField() {
    textFields.add(TextField());
    notifyListeners(); // 状態変更を通知
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
      'name': userName, // ユーザー名を Firestore フィールドに追加
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

Future getImageFromGallery() async {
  final List<XFile>? pickedFiles = await picker.pickMultiImage(); // 複数の画像を選択
  setState(() {
    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        if (images.length < 5) {
          // リストにまだ5枚未満の画像がある場合に追加
          images.add(File(pickedFile.path)); // images リストに画像を追加
        }
      }
    }
  });
}

void setState(Null Function() param0) {}

class text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<AddBookModel>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            myModel.addTextField(); // モデルのメソッドを呼び出し
          },
          child: Text('テキストフィールドを追加'),
        ),
        // テキストフィールドをリストから表示
        Column(
          children: myModel.textFields,
        ),
      ],
    );
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

// class AddTextFieldButton extends StatefulWidget {
//   @override
//   _AddTextFieldButtonState createState() => _AddTextFieldButtonState();
// }

// class _AddTextFieldButtonState extends State<AddTextFieldButton> {
//   List<Widget> textFields = []; // テキストフィールドのリスト

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             // ボタンが押されたら新しいテキストフィールドを追加
//             setState(() {
//               textFields.add(TextField());
//             });
//           },
//           child: Text('テキストフィールドを追加'),
//         ),
//         // テキストフィールドをリストから表示
//         Column(
//           children: textFields,
//         ),
//       ],
//     );
//   }
// }
