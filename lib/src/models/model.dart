import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ログインしているユーザーのIDを取得
  Future<String?> getCurrentUserID() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        return user.uid;
      }
      return null;
    } catch (e) {
      print('ユーザーIDの取得に失敗しました: $e');
      return null;
    }
  }
}

class NewPage extends StatefulWidget {
  final String data;

  NewPage({required this.data});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新しいページ"),
      ),
      body: Center(
        child: Text("受け取ったデータ: ${widget.data}"),
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  int likeCount = 0;

  Future<void> toggleLike() async {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });

    // Firestoreにいいね情報を保存
    final DocumentReference postReference = FirebaseFirestore.instance
        .collection('user_post')
        .doc('ff7dhRuV1ds6s01L16g7');
    await postReference.update({'heart': likeCount});
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          size: 30,
          color: isLiked ? Colors.pink : Colors.white,
        ),
        onPressed: toggleLike,
      ),
    );
  }
}
