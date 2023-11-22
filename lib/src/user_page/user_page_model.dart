import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;

//フォローする関数
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
  final snackBar = SnackBar(
    content: Text('フォローを解除しました'),
  );
}

//フォロ中の取得どうかの確認
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
