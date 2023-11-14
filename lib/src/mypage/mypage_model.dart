import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'mypage.dart';

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final myuid = auth.currentUser?.uid;

//フォロ中の取得どうかの確認
Future<int> myfollowing(String myuid) async {
  try {
    QuerySnapshot flollo = await FirebaseFirestore.instance
        .collection('users')
        .doc(myuid)
        .collection('following')
        .get();

    return flollo.docs.length;
  } catch (e) {
    print('フォロワー取得: $e');
    return 0;
  }
}

//フォロワーの取得
Future<int> myfollowers(String myuid) async {
  try {
    QuerySnapshot flollo = await FirebaseFirestore.instance
        .collection('users')
        .doc(myuid)
        .collection('followers')
        .get();

    return flollo.docs.length;
  } catch (e) {
    print('フォロワー取得: $e');
    return 0;
  }
}
