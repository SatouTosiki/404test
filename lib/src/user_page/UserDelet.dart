import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test3/src/main2.dart';
import 'package:test3/src/user_page/madaya.dart';
import 'GroupInfoPage.dart';

User? user = FirebaseAuth.instance.currentUser;
final myuid = auth.currentUser?.uid;
final auth = FirebaseAuth.instance;

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
  Future<void> deletePostall(String documentId) async {
    try {
      // user_post コレクションからドキュメントを削除

      // Firebase Storage から対応するサブディレクトリを削除
      Reference subDirectory = FirebaseStorage.instance.ref().child('$myuid');

      // Reference deepestReference =
      //     subDirectory.child('path_to_deepest_directory');

      // サブディレクトリ内のファイルを削除f
      ListResult listResult = await subDirectory.listAll();
      for (Reference fileRef in listResult.items) {
        await fileRef.delete();
      }

      await subDirectory.delete();

      // サブディレクトリを削除

      // 投稿ごとのストレージのパスを表示
      print('ドキュメントが正常に削除されました: $documentId');
      print('投稿ごとのストレージのパス: ${subDirectory.fullPath}');
    } catch (e) {
      print('ドキュメントの削除中にエラーが発生しました: $e');
    }
  }

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
    await FirebaseAuth.instance.signOut();
    deleteUser();
  }

  void deleteStorageFiles(String uid) async {
    try {
      // FirebaseStorageの参照を取得
      Reference storageRef = FirebaseStorage.instance.ref().child(uid);

      // 参照内のファイル一覧を取得
      ListResult result = await storageRef.listAll();

      // ファイルを削除
      for (Reference fileRef in result.items) {
        await fileRef.delete();
      }

      print('Storageのファイルを削除しました');
    } catch (e) {
      print('Storageファイルの削除中にエラーが発生しました: $e');
    }
  }

  void deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    void deleteStorageFolder(String uid) async {
      try {
        await FirebaseStorage.instance.ref(uid).delete();
        print('フォルダが正常に削除されました: $uid');
      } catch (e) {
        print('フォルダの削除中にエラーが発生しました: $e');
      }
    }

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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => madaPage()),
        );

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
            //deletePostall();
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
