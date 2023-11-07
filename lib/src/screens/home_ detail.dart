import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid.toString();

class CommentWidget extends StatelessWidget {
  //コメントボタン内のtext表示部分
  final String commentText;
  CommentWidget(this.commentText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            commentText,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class icon extends StatelessWidget {
  //ユーザごとのプロフィール画像wiget

  const icon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipOval(
              //child: Image.network(src),
              ),
        ],
      ),
    );
  }
}

// class heartco extends StatefulWidget {
//   final String documentId;

//   heartco({
//     required this.documentId,
//   });
//   @override
//   heartcos createState() => heartcos();
// }

// class heartcos extends State<heartco> {
//   Future<void> hearttttt() async {
//     final co = widget.documentId;

//     final QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
//         .collection('user_post')
//         .doc(co) // ドキュメントIDを指定
//         .collection('heart')
//         .get();

//     List<String> commentList = [];

//     for (QueryDocumentSnapshot commentDoc in commentSnapshot.docs) {
//       Map<String, dynamic> commentData =
//           commentDoc.data() as Map<String, dynamic>;
//       String commentText = commentData['comment'];
//       commentList.add(commentText);
//     }

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.documentId), // documentIdをテキストとして表示
//       ),
//     );
//   }
// }
