import 'oush.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'oush.dart';

//pushで使うclass記述用ファイル

//カラーコード指定のためのclass
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

class RecipeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        //Text("レシピを追加"),
        TextField(
          decoration: InputDecoration(hintText: "タイトル"),
        ),
        TextField(
          decoration: InputDecoration(hintText: "説明"),
        ),
      ],
    );
  }
}

class AddDocumentScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void addDocument() {
    String title = titleController.text;
    String content = contentController.text;

    CollectionReference documents =
        FirebaseFirestore.instance.collection('user_post');

    documents.add({
      'title': title,
      'content': content,
    }).then((docRef) {
      print('Document added with ID: ${docRef.id}');
    }).catchError((error) {
      print('Error adding document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Document'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addDocument,
              child: Text('Add Document'),
            ),
          ],
        ),
      ),
    );
  }
}
