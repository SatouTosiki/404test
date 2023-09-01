// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'src/main2.dart';
// import 'src/screens/login_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AddDocumentScreen(),
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

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/main2.dart';
import 'src/screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter app',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return MyHomePage();
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return Login(
              user: null,
            );
          },
        ),
      );
}
