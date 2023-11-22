import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test3/src/main2.dart';
import 'GroupInfoPage.dart';

User? user = FirebaseAuth.instance.currentUser;

class DeleteUserPage extends StatefulWidget {
  DeleteUserPage({Key? key}) : super(key: key);

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${user?.displayName ?? ''}   is room',
              style: GoogleFonts.happyMonkey(
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 79, 104, 214),
        //backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final String? selectedText = await showDialog<String>(
                      context: context,
                      builder: (_) {
                        return SimpleDialogSample();
                      });
                  print('ユーザーを削除しました!');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GroupInfoPage()));
                },
                child: Text('ユーザーを削除')),
          ],
        ),
      ),
    );
  }
}

class SimpleDialogSample extends StatefulWidget {
  SimpleDialogSample({Key? key}) : super(key: key);

  @override
  State<SimpleDialogSample> createState() => _SimpleDialogSampleState();
}

class _SimpleDialogSampleState extends State<SimpleDialogSample> {
  void deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    await user?.delete();
    await FirebaseAuth.instance.signOut();

    // usersコレクションからユーザーを削除
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();

    // user_postコレクションから該当ユーザーの投稿を削除
    QuerySnapshot posts = await FirebaseFirestore.instance
        .collection('user_post')
        .where('user_id', isEqualTo: uid)
        .get();

    for (QueryDocumentSnapshot post in posts.docs) {
      await FirebaseFirestore.instance
          .collection('user_post')
          .doc(post.id)
          .delete();
    }

    // ユーザーを削除

    await FirebaseAuth.instance.signOut();
    print('ユーザーを削除しました!');
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('退会してもよろしいですか?'),
      children: [
        SimpleDialogOption(
          child: Text('退会する'),
          onPressed: () async {
            deleteUser();
            print('ユーザーを削除しました!');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GroupInfoPage()));
          },
        ),
        SimpleDialogOption(
          child: Text('退会しない'),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
            print('キャンセルされました!');
          },
        )
      ],
    );
  }
}
