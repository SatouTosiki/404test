import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'oush.dart';

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


// class con extends StatelessWidget {
//   const con({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("投稿ページ"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // この行で前のページに戻る
//           },
//         ),
//         // ... 他のAppBarの設定 ...
//       ),
//       body: Center(
//         child: Text(
//           "Hello, World!",
//           style: TextStyle(fontSize: 24, color: Colors.black),
//         ),
//       ),
//     );
//   }
// }
