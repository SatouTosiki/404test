import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;

//フォロ中の取得
Future<int> following(String userId) async {
  try {
    QuerySnapshot flollo = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('following')
        .get();

    return flollo.docs.length;
  } catch (e) {
    print('フォロワー取得: $e');
    return 0;
  }
}

//フォロワーの取得
Future<int> followers(String userId) async {
  try {
    QuerySnapshot flollo = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('followers')
        .get();

    return flollo.docs.length;
  } catch (e) {
    print('フォロワー取得: $e');
    return 0;
  }
}
