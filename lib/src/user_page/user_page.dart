import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final uid = "userUid"; // 実際のUIDに置き換えてください

// ユーザーのデータを取得

class userpage extends StatelessWidget {
  String userName = ''; // userNameをウィジェット全体のスコープに移動
  String userEmail = ''; // userEmailをウィジェット全体のスコープに移動

  void fetchUserData() async {
    try {
      DocumentSnapshot userDocument = await firestore
          .collection('user_post') // ユーザーデータが格納されているコレクション名
          .doc(uid) // UIDを使って対象のユーザードキュメントを指定
          .get();

      if (userDocument.exists) {
        // ドキュメントが存在する場合、データにアクセスできます
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        userName = userData['name']; // userNameに値をセット
        userEmail = userData['email']; // userEmailに値をセット

        print('User Name: $userName');
        print('User Email: $userEmail');
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  final User? user;
  final String userUid; // userUidを保持するフィールドを追加

  // コンストラクタでuserとuserUidを受け取る
  userpage({required this.user, required this.userUid});

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
            IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.black,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User UID: $userUid'), // UID情報を表示
            Text('User Name: $userName', style: TextStyle(fontSize: 20)),
            Text('User Email: $userEmail', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class userpage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2"),
      ),
      body: Center(
        child: TextButton(
          child: Text("1ページ目に遷移する"),
          onPressed: () {},
        ),
      ),
    );
  }
}
