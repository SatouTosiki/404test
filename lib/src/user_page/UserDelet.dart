import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../mypage/mypage.dart';
import '../register/register_page.dart';
import 'GroupInfoPage.dart';

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
        title: Text('ユーザー削除'),
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
    final msg =
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    // ユーザーを削除

    await user?.delete();
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Registe()));
          },
        ),
        SimpleDialogOption(
          child: Text('退会しない'),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyPage()));
            print('キャンセルされました!');
            showDialog(
              context: context, // BuildContextが必要
              builder: (BuildContext context) {
                return AlertDialog(
                  // title: Text('投稿削除'),
                  content: Text('アカウント削除をキャンセルしました'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // ダイアログを閉じる
                      },
                      child: Text('閉じる'),
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    );
  }
}
