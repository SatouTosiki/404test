import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../push/push_class.dart';
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

Future<void> MyPushet() async {
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('user_post')
        .doc(myuid)
        .collection('pushs')
        .orderBy('time', descending: true)
        .get();
    List<Map<String, dynamic>> mydataList = [];

    await Future.forEach(querySnapshot.docs, (doc) async {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        mydataList.add(data);
      }
    });
    // データが取得できたら、Stateを更新して画面を再構築する
    setState(() {});
  } catch (e) {
    print('エラー画面表示できないなのです☆: $e');
  }
}
