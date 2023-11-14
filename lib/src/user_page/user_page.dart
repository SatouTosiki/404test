import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';
import '../push/push_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
User? currentUser = auth.currentUser;
// ユーザーのデータを取得
// フォロー関数
Future<void> followUser(String userId) async {
  User? currentUser = auth.currentUser;

  if (currentUser != null) {
    // フォロワーのコレクションに追加
    await firestore
        .collection('users')
        .doc(userId)
        .collection('followers')
        .doc(currentUser.uid)
        .set({
      // ここにフォロー時に保存したいデータがあれば追加できます
      'timestamp': FieldValue.serverTimestamp(), // タイムスタンプを保存する例
    });

    // 自分のフォロー中のコレクションに追加
    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('following')
        .doc(userId)
        .set({
      // ここにフォロー時に保存したいデータがあれば追加できます
      'timestamp': FieldValue.serverTimestamp(), // タイムスタンプを保存する例
    });
  }
}

// フォロー解除関数
Future<void> unfollowUser(String userId) async {
  User? currentUser = auth.currentUser;

  if (currentUser != null) {
    // フォロワーのコレクションから削除
    await firestore
        .collection('users')
        .doc(userId)
        .collection('followers')
        .doc(currentUser.uid)
        .delete();

    //自分のフォロー中のコレクションから削除
    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('following')
        .doc(userId)
        .delete();
  }
}

class userpage extends StatelessWidget {
  String userName = '';
  String userEmail = '';
  //final User? user;
  final String name;
  final String user_image;
  final String time;
  final String user_id;

  userpage(
      { //required this.user,
      required this.name,
      required this.user_image,
      required this.time,
      required this.user_id

      //required this.name,
      });

  @override
  Widget build(BuildContext context) {
    // ユーザーIDが一致するかどうかの条件
    bool isNotCurrentUser = currentUser?.uid != user_id; //自分のページなら表示しない
    bool isFollowing = false; // ユーザーがフォローしているかどうかの状態を仮定
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LineIcons.arrowLeft),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                '$name',
                style: GoogleFonts.happyMonkey(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // プロフィール画像を表示
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // 要素を左右に均等に配置
                      children: [
                        CircleAvatar(
                          radius: 50, // プロフィール画像の半径
                          backgroundImage:
                              NetworkImage(user_image), // プロフィール画像を表示
                        ),
                        Column(
                          children: const [
                            Text(
                              "フォロワー",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text("実装予定"),
                          ],
                        ),
                        Column(
                          children: const [
                            Text(
                              "フォロー中",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text("実装予定"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isNotCurrentUser) // ユーザーIDが一致する場合に表示
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text('フォロー'), //
                          onPressed: () {
                            if (isNotCurrentUser) {
                              // フォローの場合
                              followUser(user_id);
                            } else {
                              // アンフォローの場合
                              unfollowUser(user_id);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Text('User UID: $name'),
                    Text('ID:$name'),
                    Text('id: $user_id'),
                  ],
                ),

                Text(
                  "実装予定",
                  style: TextStyle(fontSize: 20),
                ),

                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //カラム数
                  ),
                  itemCount: 9, //要素数
                  itemBuilder: (context, index) {
                    //要素を戻り値で返す
                    return Container(
                      color: index.isEven ? Colors.blue : Colors.yellow,
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
