import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
final myuid = auth.currentUser?.uid;

String? userName = user?.displayName;
final uid = auth.currentUser?.uid.toString();
final userimage = user?.photoURL;

List<File> images = [];

final picker = ImagePicker();

class AddBookModel extends ChangeNotifier {
  String? title;
  String? comment;
  List<File> imageFiles = [];
  List<Widget> textFields = [];
  List<Widget> ingredients = [];
  int? heart;

  List<TextEditingController> textControllers = [];
  List<TextEditingController> ingredientsControllers = [];
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
    textControllers.add(textController);

    textFields.add(
      TextField(
        maxLength: 50,
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: textController,
      ),
    );
    notifyListeners();
  }

  void rere() {
    final ingredientController = TextEditingController();
    ingredientsControllers.add(ingredientController);

    ingredients.add(
      TextField(
        maxLength: 10,
        maxLines: 1,
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: ingredientController,
      ),
    );
    notifyListeners();
  }

  Future<void> addBook() async {
    try {
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
            .ref('user_post/${imageFile}')
            .putFile(imageFile);

        final imgURL = await task.ref.getDownloadURL();
        imgURLs.add(imgURL);
      }

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

      final String mypushid = documentReference.id;

      print('新しいドキュメントのID: $mypushid');
      print("ログインID: $myuid");

      await mypush(myuid!, mypushid);
    } catch (e) {
      print('エラー: $e');
    }
  }

  Future<int> mypush(String myuid, String mypushid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myuid)
          .collection('pushs')
          .doc(mypushid)
          .set({});

      return 1;
    } catch (e) {
      print('エラー: $e');
      return 0;
    }
  }

  List<String> imgURLs = [];

  Future pickImage() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        if (imageFiles.length < 5) {
          String imagePath = pickedFile.path;
          imageFiles.add(File(imagePath));
          int length = imageFiles.length;
        } else {
          print("画像が多い");
        }
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
                  myModel.addTextField();
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
                  myModel.rere();
                },
          label: const Text(
            ' 材料を記入 ',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
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
