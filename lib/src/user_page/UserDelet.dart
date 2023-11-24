import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  // Firebase Authenticationのキャッシュをクリアする関数

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
  Future<void> clearFirebaseAuthCache() async {
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance
          .signInAnonymously(); // ダミーで再ログインすることでキャッシュをクリア
    } catch (e) {
      print('Firebase Auth Cache Clear Error: $e');
      // エラーハンドリングが必要な場合は追加してください
    }
  }

  Future<void> reauthenticateAndDelete(String uid) async {
    // ユーザーが最後にログインしてから一定の時間が経過しているため、再ログインが必要
    // ここで再ログインの処理を行う
    // ...
    // 再ログイン後、再度ユーザーを削除
    deleteUser();
  }

  void deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    try {
      await user?.delete();

      // ユーザーに紐づくドキュメントを削除
      QuerySnapshot posts = await FirebaseFirestore.instance
          .collection('user_post')
          .where('user_id', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot post in posts.docs) {
        // ドキュメントを削除
        await post.reference.delete();
      }

      // usersコレクションからユーザーを削除
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // 再認証が必要な場合の処理
        await reauthenticateAndDelete(uid!);
        print("まだ消せてない");
      } else {
        // その他のエラーの場合の処理
        print('エラー: ${e.message}');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // 再認証が必要な場合の処理
        await reauthenticateAndDelete(uid!);
        print("まだ消せてない");
      } else {
        // その他のエラーの場合の処理
        print('エラー: ${e.message}');
      }
    }
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
            clearFirebaseAuthCache();
            print('ユーザーを削除しました!');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GroupInfoPage()),
            );
          },
        ),
        SimpleDialogOption(
          child: Text('退会しない'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
            print('キャンセルされました!');
          },
        ),
      ],
    );
  }
}
