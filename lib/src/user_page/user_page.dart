import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../push/push_class.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// ユーザーのデータを取得

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

  // void fetchUserData() async {
  //   try {
  //     DocumentSnapshot userDocument =
  //         await firestore.collection('user').doc(uid).get();

  //     if (userDocument.exists) {
  //       Map<String, dynamic> userData =
  //           userDocument.data() as Map<String, dynamic>;
  //       userName = userData['name'];
  //       userEmail = userData['user_id'];
  //       print('User Name: $userName');
  //       print('User Email: $userEmail');
  //       // データが読み込まれたらsetStateを呼んで再描画
  //       setState(() {});
  //     } else {
  //       print('User document not found');
  //     }
  //   } catch (e) {
  //     print('Error fetching user data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
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
                            Text("3"),
                          ],
                        ),
                        Column(
                          children: const [
                            Text(
                              "フォロー中",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text("ad"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Text('User UID: $name'),
                    Text('ID:$name'),
                    Text('id: $user_id'),
                    Text('User Name: $userName',
                        style: TextStyle(fontSize: 20)),
                    Text('User Email: $userEmail',
                        style: TextStyle(fontSize: 20)),
                  ],
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
