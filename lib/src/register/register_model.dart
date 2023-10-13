import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firestoreへのデータの格納
Future<void> addUserToFirestore(
    String userId, String username, String email) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore.collection('user').doc(userId).set({
    'username': username,
    'email': email,
    // 他のユーザー情報もここに追加
  });
}
