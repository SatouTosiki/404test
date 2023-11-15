import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test3/src/user_page/user_page_model.dart';
import '../push/push_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
User? currentUser = auth.currentUser;

class userpage extends StatelessWidget {
  String userName = '';
  String userEmail = '';
  //final User? user;
  final String name;
  final String user_image;
  final String time;
  final String user_id;

  userpage({
    required this.name,
    required this.user_image,
    required this.time,
    required this.user_id,
  });

  Future<bool> checkIfFollowing() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot followingDoc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('following')
          .doc(user_id)
          .get();

      return followingDoc.exists;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isNotCurrentUser = currentUser?.uid != user_id;
    bool isFollowing = false;

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
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user_image),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder<int>(
                            future: followers(user_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('エラー: ${snapshot.error}');
                              } else {
                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'フォロワー\n',
                                        style: GoogleFonts.happyMonkey(
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder<int>(
                            future: following(user_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('エラー: ${snapshot.error}');
                              } else {
                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'フォロー中\n',
                                        style: GoogleFonts.happyMonkey(
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isNotCurrentUser)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool isFollowing = await checkIfFollowing();
                          if (isFollowing) {
                            unfollowUser(user_id);
                          } else {
                            followUser(user_id);
                          }
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          primary: Colors.blue, // ボタンのデフォルト色
                        ),
                        child: FutureBuilder<bool>(
                          future: checkIfFollowing(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('読み込み中...');
                            } else if (snapshot.hasError) {
                              return Text('エラー: ${snapshot.error}');
                            } else {
                              bool isFollowing = snapshot.data ?? false;
                              return Text(
                                isFollowing ? 'フォローを解除' : 'フォロー',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Container(
                    color: index.isEven ? Colors.blue : Colors.yellow,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
