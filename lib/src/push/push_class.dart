import 'package:test3/src/mypage/mypage.dart';
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

final picker = ImagePicker();

Future<User?> getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}

class AddBookModel extends ChangeNotifier {
  String? title;
  String? author;
  List<File> imageFiles = []; // 複数の画像ファイルのパスを格納するリスト
  List<Widget> textFields = []; //テキストフィールドを追加していくリスト
  List<Widget> ingredients = []; //具材を登録
  List<TextEditingController> textControllers = []; // テキストフィールド用のコントローラーリスト
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
    final textController = TextEditingController();
    textControllers.add(textController); // コントローラーをリストに追加

    textFields.add(
      TextField(
        maxLength: 50,
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: textController, // コントローラーをテキストフィールドに設定
      ),
    );
    notifyListeners(); // 状態変更を通知
  }

  void rere() {
    ingredients.add(
      const TextField(
        maxLength: 10,
        maxLines: 1,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
    );
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

    List<String> textFieldsValues = [];
    for (var controller in textControllers) {
      textFieldsValues.add(controller.text); // 各コントローラーから入力値を取得しリストに追加
    }

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
      "textFields": textFieldsValues, // 各テキストフィールドの入力値を Firestore に追加
      'name': userName, // ユーザー名を Firestore フィールドに追加
      //"textFields": textFields, //作り方手順のリスト
      "ingredients": ingredients, //材料
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

void setState(Null Function() param0) {}

class textbotton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<AddBookModel>(context);

    return Column(
      children: [
        TextButton(
          style: ButtonStyle(),
          onPressed: myModel.textFields.length >= 10
              ? null
              : () {
                  myModel.addTextField(); // モデルのメソッドを呼び出し
                },
          child: const Text(
            '➕ 作る手順の追加 ➕',
          ),
        ),

        // テキストフィールドをリストから表示
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: myModel.textFields,
          ),
        ),
      ],
    );
  }
}

//テキストフィールドをつかするクラス

class re extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<AddBookModel>(context);

    return Column(
      children: [
        TextButton(
          style: ButtonStyle(),
          onPressed: myModel.ingredients.length >= 10
              ? null
              : () {
                  myModel.rere(); // モデルのメソッドを呼び出し
                },
          child: const Text(
            '➕ 具材を記入 ➕',
          ),
        ),

        // テキストフィールドをリストから表示
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: myModel.ingredients,
          ),
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
