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
  final User? user;
  final String uid;

  userpage({
    required this.user,
    required this.uid,
    //required this.name,
  });

  void fetchUserData() async {
    try {
      DocumentSnapshot userDocument =
          await firestore.collection('user').doc(uid).get();

      if (userDocument.exists) {
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        userName = userData['name'];
        userEmail = userData['user_id'];
        print('User Name: $userName');
        print('User Email: $userEmail');
        // データが読み込まれたらsetStateを呼んで再描画
        setState(() {});
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

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
            //Text('User UID: $name'),
            Text('ID:$uid'),
            Text('User Name: $userName', style: TextStyle(fontSize: 20)),
            Text('User Email: $userEmail', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
