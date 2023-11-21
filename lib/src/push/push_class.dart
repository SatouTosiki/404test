import 'package:line_icons/line_icons.dart';
import 'package:test3/src/mypage/mypage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ユーザーがログインしていることを確認する関数

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
final myuid = auth.currentUser?.uid;

String? userName = user?.displayName; // ユーザー名を取得
final uid = auth.currentUser?.uid.toString(); //UIDの取得
final userimage = user?.photoURL;

List<File> images = []; // 選択された複数の画像を格納するリスト

final picker = ImagePicker();

// Future<User?> getCurrentUser() async {
//   return FirebaseAuth.instance.currentUser;
// }

class AddBookModel extends ChangeNotifier {
  String? title;
  String? comment;
  List<File> imageFiles = []; // 複数の画像ファイルのパスを格納するリスト
  List<Widget> textFields = []; //テキストフィールドを追加していくリスト
  List<Widget> ingredients = []; //具材を登録
  int? heart;
  //-----------------------------------------------------
  List<TextEditingController> textControllers = []; // テキストフィールド用のコントローラーリスト
  List<TextEditingController> ingredientsControllers =
      []; // 具材のテキストフィールド用のコントローラーリスト
  String? timestamp;
  bool isLoading = false;
  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    print("aa");
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
    final ingredientController = TextEditingController();
    ingredientsControllers.add(ingredientController); // コントローラーをリストに追加

    ingredients.add(
      TextField(
        maxLength: 10,
        maxLines: 1,
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: ingredientController, // コントローラーをテキストフィールドに設定
      ),
    );
    notifyListeners();
  }

  Future<void> addBook() async {
    try {
      // コレクションへの参照を取得
      CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('user_post');

      List<String> textFieldsValues = [];
      for (var controller in textControllers) {
        textFieldsValues.add(controller.text);
      }

      List<String> ingredientsValues = [];
      for (var controller in ingredientsControllers) {
        ingredientsValues.add(controller.text);
      }

      if (title == null || title == "") {
        throw 'タイトルが入力されていません';
      }

      if (comment == null || comment!.isEmpty) {
        throw '説明文が入力されていません';
      }

      for (var imageFile in imageFiles) {
        final task = await FirebaseStorage.instance
            .ref('user_post/${myuid}')
            .putFile(imageFile);

        final imgURL = await task.ref.getDownloadURL();
        imgURLs.add(imgURL);
      }

      // コレクションに新しいドキュメントを追加し、追加されたドキュメントの参照を取得
      final DocumentReference<Map<String, dynamic>> documentReference =
          await collectionRef.add({
        'title': title,
        'comment': comment,
        'imgURL': imgURLs,
        'time': timestamp,
        'name': userName,
        "Ingredients": ingredientsValues,
        "procedure": textFieldsValues,
        "user_id": uid,
        "user_image": userimage,
        "heart": heart,
      });

      // 投稿されたドキュメントのIDを取得
      final String mypushid = documentReference.id;

      print('新しいドキュメントのID: $mypushid');
      print("ログインID: $myuid");

      // mypush 関数を呼び出す
      await mypush(myuid!, mypushid);
    } catch (e) {
      print('エラー: $e');
    }
  }

  Future<int> mypush(String myuid, String mypushid) async {
    try {
      // ドキュメントIDを指定してドキュメントを作成
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myuid)
          .collection('pushs')
          .doc(mypushid)
          .set({});

      return 1; // 成功時に1を返す（例として）
    } catch (e) {
      print('エラー: $e');
      return 0; // エラー時に0を返す（例として）
    }
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
        TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: myModel.textFields.length >= 10
              ? null
              : () {
                  myModel.addTextField(); // モデルのメソッドを呼び出し
                },
          icon: Icon(
            LineIcons.plus,
            color: Colors.white,
          ),
          label: const Text(
            ' 作る手順の追加 ',
            style: TextStyle(fontSize: 20, color: Colors.white),
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
class reee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<AddBookModel>(context);

    return Column(
      children: [
        TextButton.icon(
          icon: Icon(
            LineIcons.plus,
            color: Colors.white,
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: myModel.ingredients.length >= 10
              ? null
              : () {
                  myModel.rere(); // モデルのメソッドを呼び出し
                },
          label: const Text(
            ' 材料を記入 ',
            style: TextStyle(fontSize: 20, color: Colors.white),
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
