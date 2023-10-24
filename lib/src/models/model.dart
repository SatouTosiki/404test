import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// class LikeService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // いいねを追加するメソッド
//   Future<void> addLike(String postId) async {
//     final postRef = _firestore.collection('posts').doc(postId);

//     await _firestore.runTransaction((transaction) async {
//       final postSnapshot = await transaction.get(postRef);
//       if (postSnapshot.exists) {
//         final currentLikes = postSnapshot.data()['likes'] ?? 0;
//         transaction.update(postRef, {'likes': currentLikes + 1});
//       }
//     });
//   }
// }

class ChildWidget extends StatelessWidget {
  final Function(String) onIconClick; // ドキュメントIDを通知するためのコールバック
  ChildWidget(this.onIconClick);
  // ここでドキュメントIDを取得し、クリック時に親ウィジェットに通知
  void handleIconClick() {
    String documentId = '6avraWwuqq5CNBOffVIF'; // ドキュメントIDを取得
    // 親ウィジェットにドキュメントIDを通知
    onIconClick(documentId);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () {
        print("確認");
      },
    );
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
